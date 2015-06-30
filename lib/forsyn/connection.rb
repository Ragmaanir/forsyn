module Forsyn

  # class WindowedRateLimiter
  #   def initialize(limit:, window_size: 5.seconds)
  #     @window_size = window_size
  #     @limit = limit
  #     reset_window!
  #   end

  #   def rate_limit_exceeded?(client)
  #     reset_window! if window_passed?

  #     @window[client] += 1

  #     @window[client] > @limit
  #   end

  # private

  #   def reset_window!
  #     @window = Hash.new(0)
  #     @window_start = Time.now.utc
  #   end

  #   def window_passed?
  #     (Time.now.utc - @window_start) > @window_size
  #   end

  # end

  class Connection < EventMachine::Connection

    attr_reader :logger

    def configure(event_queue:)
      @event_queue = event_queue

      @event_count = 0
      @window_start = Time.now.utc
      @window_size = 5.seconds

      @@client_event_count ||= {}
    end

    def receive_data(data)
      count_client_request

      hash = catch(:forsyn_halt) do

        if @@client_event_count[client_ip] > config.hard_client_event_limit
          reject_request(:hard_client_event_limit)
        end

        if @event_queue.size > config.hard_queue_size_limit
          reject_request(:hard_queue_size_limit)
        end

        @event_queue.push(data)

        if @@client_event_count[client_ip] > config.soft_client_event_limit
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
      throw :forsyn_halt, hash.merge(status: status)
    end

    def config
      Forsyn.configuration
    end

    def logger
      Forsyn.logger
    end

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
end
