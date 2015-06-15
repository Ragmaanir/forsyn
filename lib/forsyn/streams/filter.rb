module Forsyn
  module Streams
    class Filter < Stream

      def initialize(filter, **args)
        @filter = filter
        super(**args)
      end

      def process(event)
        dispatch(event) if @filter.call(event)
      end

    end
  end
end
