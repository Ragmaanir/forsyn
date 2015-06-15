module Forsyn
  module Mockup
    class NodeBuilder
      def initialize(&block)
        block.call(self)
      end

      def total_memory(bytes)

      end
    end
  end
end
