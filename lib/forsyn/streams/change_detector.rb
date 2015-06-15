module Forsyn
  module Streams
    class ChangeDetector < Stream

      def initialize(selector, default: nil, **args)
        @selector = selector
        @previous = default
        super(**args)
      end

      def process(data)
        value = @selector.call(data)
        if @previous != value
          @previous = value
          dispatch(data)
        end
      end

    end
  end
end
