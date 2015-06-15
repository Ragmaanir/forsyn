module Forsyn
  module Streams

    class Splitter < Stream

      attr_reader :splitter, :buckets

      def initialize(splitter, children:, **args)
        @child_templates = children
        @splitter = splitter
        @buckets = {}
        super(children: [], **args)
      end

      def process(event)
        bucket = splitter.call(event)

        children = @child_templates.map(&:clone)

        if !buckets[bucket].present?
          buckets[bucket] = children
          @children += children
        end

        dispatch(event, bucket)
      end

    private

      def dispatch(event, bucket)
        buckets[bucket].each{ |c| c.process(event) }
      end

    end

  end
end
