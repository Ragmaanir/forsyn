module Forsyn

  class Connection < EventMachine::Connection

    attr_reader :logger

    def configure(event_queue:, request_counter:)
      @event_queue = event_queue
      @request_counter = request_counter
    end

    def receive_data(data)
      @request_counter.increment(client_ip)

      hash = catch(:forsyn_halt) do

        if @request_counter[client_ip] > config.hard_client_event_limit
          reject_request(:hard_client_event_limit)
        end

        if @event_queue.size > config.hard_queue_size_limit
          reject_request(:hard_queue_size_limit)
        end

        @event_queue.push(data)

        if @request_counter[client_ip] > config.soft_client_event_limit
          respond_with(:accepted, advice: :throttle)
        end

        if @event_queue.size > config.soft_queue_size_limit
          respond_with(:accepted, advice: :throttle)
        end

        respond_with(:accepted)
      end

      send_data(hash.to_json)
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

    def reject_request(reason)
      respond_with(:rejected, reason: reason)
    end

    def respond_with(status, hash={})
      logger.debug{ "#{client_ip}: #{status} (#{hash})" }
      throw :forsyn_halt, hash.merge(status: status)
    end

    def config
      Forsyn.configuration
    end

    def logger
      Forsyn.logger
    end

    def client_info
      Socket.unpack_sockaddr_in(get_peername)
    end

    def client_ip
      client_info.last
    end

    def client_port
      client_info.first
    end

  end
end
