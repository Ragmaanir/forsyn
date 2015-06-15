module Forsyn
  module Streams

    class Printer < Stream
      def initialize
        super(children: [])
      end

      def process(event)
        puts(event)
        dispatch(event)
      end
    end

  end
end
