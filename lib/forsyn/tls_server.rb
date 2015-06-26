module Forsyn
  class TlsServer

    class Connection < EventMachine::Connection

      attr_accessor :event_queue

      def receive_data(data)
        puts data
        send_data({status: 200}.to_json)

        @event_queue.push(data)

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
    end

    def initialize(host: '127.0.0.1', port: 7331, ssl: nil)
      @host = host
      @port = port
      #@socket = TCPSocket.new(host, port)
      #@tls_socket = OpenSSL::SSL::SSLSocket.new(@socket, ctx)
    end

    def run
      EventMachine.run do

        event_backend = EventBackends::ElasticsearchBackend.new
        event_queue = Queue.new

        dispatcher = BufferedDispatcher.new(event_queue) do |events|
          event_backend.store(events)
        end

        dispatcher.run

        %w{SIGTERM SIGKILL INT}.each do |sig|
          Signal.trap(sig) {
            EventMachine.stop
            dispatcher.stop
            puts "STOPPED"
          }
        end

        EventMachine.start_server(@host, @port, Connection) do |conn|
          conn.event_queue = event_queue
        end

        puts "STARTED"
      end
    end

  end
end
