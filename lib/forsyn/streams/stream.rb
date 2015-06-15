module Forsyn
  module Streams
    class Stream

      attr_reader :children

      def initialize(children:)
        @children = children
      end

      def process(*)
      end

    private

      def dispatch(event)
        children.each{ |c| c.process(event) }
      end

    end
  end
end
