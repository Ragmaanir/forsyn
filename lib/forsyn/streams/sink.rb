module Forsyn
  module Streams
    class Sink < Stream

      attr_reader :target

      def initialize(target, children: [], **args)
        @target = target
        super(children: children, **args)
      end

      def process(event)
        @target << event
        dispatch(event)
      end

    end
  end
end
