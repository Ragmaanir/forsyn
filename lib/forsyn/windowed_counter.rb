module Forsyn

  class WindowedCounter

    def initialize(max_window_age: 5.seconds)
      @max_window_age = max_window_age
      reset_window!
    end

    def increment(client)
      raise ArgumentError unless client.is_a?(String)

      reset_window! if window_passed?

      @window[client] += 1
    end

    def [](client)
      raise ArgumentError unless client.is_a?(String)
      @window[client]
    end

  private

    def reset_window!
      @window = Hash.new(0)
      @window_start = Time.now.utc
    end

    def window_age
      Time.now.utc - @window_start
    end

    def window_passed?
      window_age > @max_window_age
    end

  end

end
