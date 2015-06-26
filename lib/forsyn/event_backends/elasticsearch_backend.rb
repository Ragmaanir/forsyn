module Forsyn
  module EventBackends

    class Client
      include Elasticsearch::API

      def initialize(connection_or_options={})
        case connection_or_options
          when Hash then @options = connection_or_options
          when nil then raise ArgumentError
          else @connection = connection_or_options
        end
      end

      def connection
        @connection ||= default_connection
      end

    private

      def default_connection
        ::Faraday::Connection.new(
          url: 'http://localhost:9200',
          request: {
            open_timeout: 5,
            timeout: 5
          }
        )
      end

      def perform_request(method, path, params, body)
        puts "#{method} #{path} #{params}"

        connection.run_request(
          method.downcase.to_sym,
          path,
          ( body ? MultiJson.dump(body): nil ),
          {'Content-Type' => 'application/json'}
        )
      end
    end

    class ElasticsearchBackend < Backend

      def initialize(client: Client.new)
        @client = client
      end

      def store(events)
        bulk = events.map { |e|
          { index: {data: e} }
        }
        @client.index(index: 'main', type: 'events', body: bulk)
      end

    end

  end
end
