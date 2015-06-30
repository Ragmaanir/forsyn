module Forsyn
  class Server

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
