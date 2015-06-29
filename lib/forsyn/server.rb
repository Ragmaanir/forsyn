require 'pry'
module Forsyn
  class Server

    MAX_QUEUE_SIZE = 10_000

    class Connection < EventMachine::Connection

      MAX_EVENT_COUNT = 1_000

      attr_reader :logger

      def configure(event_queue:, logger: Forsyn.logger)
        @event_queue = event_queue
        @logger = logger

        @event_count = 0
        @window_start = Time.now.utc
        @window_size = 5.seconds

        @@client_event_count ||= {}
      end

      def receive_data(data)
        count_client_request

        if @@client_event_count[client_ip] < MAX_EVENT_COUNT
          if @event_queue.size < MAX_QUEUE_SIZE
            @event_queue.push(data)
            send_data({status: 200}.to_json)
          else
            logger.warn "MAX_QUEUE_SIZE exceeded"
            send_data({status: 503, reason: 'MAX_QUEUE_SIZE'}.to_json)
          end
        else
          logger.warn "MAX_EVENT_COUNT exceeded for #{client_ip}"
          send_data({status: 503, reason: 'MAX_EVENT_COUNT'}.to_json)
        end

        close_connection_after_writing
      end

      def post_init
        # transport = EventMachine::HttpRequest
        # @client = Elasticsearch::Client.new(transport: transport)
        # @client.extend(Elasticsearch::API)
        # @client.search index: 'test'
      end

      def connection_completed
      end

      def unbind
      end

    private

      def client_info
        #get_peername[2,6].unpack "nC4"
        Socket.unpack_sockaddr_in(get_peername)
      end

      def client_ip
        client_info.last
      end

      def client_port
        client_info.first
      end

      def window_exceeded?
        size = @window_start - Time.now.utc
        size > @window_size
      end

      def count_client_request
        @@client_event_count[client_ip] ||= 0
        @@client_event_count[client_ip] += 1

        if window_exceeded?
          @window_start = Time.now.utc
          @@client_event_count[client_ip] = 1
        end
      end

    end

    attr_reader :host, :port, :logger

    def initialize(host: '127.0.0.1', port: 7331, ssl: nil, logger: Forsyn.logger)
      @host = host
      @port = port
      #@socket = TCPSocket.new(host, port)
      #@tls_socket = OpenSSL::SSL::SSLSocket.new(@socket, ctx)
      @logger = logger
      @running = false

      @event_backend = EventBackends::ElasticsearchBackend.new
      @event_queue = Queue.new

      @dispatcher = BufferedDispatcher.new(@event_queue) do |events|
        @event_backend.store(events)
      end
    end

    def run
      raise "Already running" if @running
      @running = true

      EventMachine.run do

        trap_signals

        @dispatcher.run

        EventMachine.start_server(@host, @port, Connection) do |conn|
          conn.configure(event_queue: @event_queue)
        end

        logger.info "Started"
      end

      logger.info "Stopped"
    end

  private

    def stop
      if @running
        @running = false
        EventMachine.stop
        @dispatcher.stop
      end
    end

    def trap_signals
      %w{TERM INT}.each do |sig|
        Signal.trap(sig) {
          stop
        }
      end
    end

  end
end
