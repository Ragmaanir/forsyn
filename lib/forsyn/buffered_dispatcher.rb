module Forsyn

  class BufferedDispatcher

    def initialize(queue, &on_dispatch)
      @queue = queue
      @running = false
      @on_dispatch = on_dispatch || raise(ArgumentError)
    end

    def running?
      @running
    end

    def stop
      @running = false

      if !@thread.join
        @thread.terminate
      end
    end

    def run
      raise "Already running" if @thread
      @running = true

      @thread = Thread.new do
        begin
          while running?
            sleep 1
            process_events
          end
        rescue StandardError => e
          puts e.message
          puts e.backtrace
        end
      end
    end

  private

    def process_events
      buffer = []

      while !@queue.empty?
        buffer << @queue.pop
      end

      dispatch(buffer) if buffer.present?
    end

    def dispatch(buffer)
      @on_dispatch.call(buffer)
    end
  end

end
