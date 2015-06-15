require 'active_support'
require 'active_support/core_ext'

module Forsyn
  class JsonBasedBuilder

    def initialize(options={})
    end

    def build(json)
      raise ArgumentError unless json.is_a?(Hash)
      @components = {}

      json.each do |kind, instances|
        instances.each do |instance|
          create(kind, instance)
        end
      end

      System.new(components: @components)
    end

  private

    def create(kind, name:, type:, options:)
      raise ArgumentError("#{kind} already registered: #{name}") if @components[kind][name]
      instance = type.constantize.new(options)
      @components[kind][name] = instance

    end

    # def create_trigger(name:, type:, options:)
    #   raise ArgumentError("Trigger already registered: #{name}") if @triggers[name]
    #   @triggers[name] = type.constantize.new(options)
    # end

    # def create_responder(name:, type:, options:)
    #   raise ArgumentError("Responder already registered: #{name}") if @responders[name]
    #   @responders[name] = type.constantize.new(options)
    # end

    # def create_notifier(name:, type:, options:)
    #   raise ArgumentError("Notifier already registered: #{name}") if @notifiers[name]
    #   @notifiers[name] = type.constantize.new(options)
    # end

  end
end

{
  classifiers: {
    default: {
      by: ['host', 'type']
    }
  },
  preprocessors: {
    free_memory_percentage: {
      event: 'machine.memory',
      process: ->(event){ event.free / event.total },
      as: 'machine.memory:free_percentage'
    }
  },
  triggers: {
    free_memory_threshold: {
      type: 'ThresholdTrigger',
      thresholds: {
        critical: ->(event){ event.free_percentage < 0.1 }
      }
    }
  },
  responders: {

  }
}

# preprocess('machine.memory') do |event|
#   emit(:free_percentage, event.free / event.total)
# end

# class Pipeline

#   def initialize
#     @processors = []
#   end

#   def >>(processor)
#     if last = @processors.last
#       last.next_processor = processor
#     end

#     @processors << processor
#     self
#   end

#   def process(item)
#     @processors.first.process(item)
#   end

#   def self.>>(processor)
#     pipe = Pipeline.new
#     pipe >> processor
#     pipe
#   end

#   def inspect
#     "#{self.class}(#{@processors.map(&:class)})"
#   end

# end

# # class ProcessorFactory

# #   def initialize(factory_function)
# #     @factory_function = factory_function
# #   end

# #   #def call(next_processor)
# #   #  @factory_function.call(next_processor)
# #   #end

# #   def >>(next_processor)
# #     @factory_function.call(next_processor)
# #   end

# # end

# class Processor

#   attr_accessor :next_processor

#   def initialize(next_processor)
#     @next_processor = next_processor
#   end

#   def process(item)
#     raise NotImplementedError
#   end

#   # def >>(next_processor)
#   #   @next_processor = next_processor
#   #   Pipeline.new(self)
#   # end

#   def inspect
#     "#{self.class.name}(next_processor: #{next_processor.inspect})"
#   end

# end

# class Filter < Processor

#   attr_reader :filter_function

#   def initialize(filter_function, *args)
#     @filter_function = filter_function
#     super(*args)
#   end

#   def process(item)
#     if filter_function.call(item)
#       next_processor.process(item)
#     end
#   end

# end

# class Categorize < Processor

#   attr_reader :categorization_function

#   def initialize(categorization_function, *args)
#     @categorization_function = categorization_function
#     super(*args)
#     @streams = {}
#   end

#   def process(item)
#     key = categorization_function.call(item)
#     @streams[key] ||= next_processor.clone
#     @streams[key].process(item)
#   end

# end

# class Select < Processor

#   attr_reader :selection_function

#   def initialize(selection_function, *args)
#     @selection_function = selection_function
#     super(*args)
#   end

#   def process(item)
#     data = selection_function.call(item)
#     next_processor.process(*data)
#   end

# end

# class Print < Processor

#   def initialize(*args)
#     super(nil, *args)
#   end

#   def process(item)
#     print item
#   end

# end

# def Filter(arg)
#   proc = case arg
#     when Hash then ->(item) { arg.all?{ |k,v| item.send(k) == v } }
#     when Proc then arg
#     else raise
#   end

#   #ProcessorFactory.new(->(n){ Filter.new(proc, n) })
#   Filter.new(proc, nil)
# end

# def Categorize(*args)
#   proc = if args.length == 1 && args.first.is_a?(Proc)
#     args.first
#   else
#     ->(item){ args.map{ |arg| item.send(arg) } }
#   end

#   #ProcessorFactory.new(->(n){ Categorize.new(proc, n) })
#   Categorize.new(proc, nil)
# end

# def Select(*args)
#   proc = if args.length == 1 && args.first.is_a?(Proc)
#     args.first
#   else
#     ->(item){ args.map{ |arg| item.send(arg) } }
#   end

#   #ProcessorFactory.new(->(n){ Select.new(proc, n) })
#   Select.new(proc, nil)
# end

# class Threshold < Processor

#   def initialize(cmp_op, thresholds)
#     @cmp_op = cmp_op
#     @thresholds = thresholds
#     @sorted = @thresholds.sort_by{ |k,v| v }
#     @sorted = @sorted.reverse if @cmp_op == :<
#   end

#   def process(item)
#     res = @sorted.find{ |k, v| v.send(@cmp_op, item) } || [:normal, nil]
#     @next_processor.process(res.first)
#   end

# end

# class OnChange < Processor

#   def initialize(default)
#     @last_value = default
#   end

#   def process(item)
#     if item != @last_value
#       next_processor.process(item)
#       @last_value = item
#     end
#   end

# end

# #s = Pipeline >> Filter(type: 'machine.memory') >> Categorize(:host, :type) >> Select(:free_percentage) #>> Threshold(:<, critical: 0.1, abnormal: 0.2) >> OnChange >> RateLimit(1, 5.minutes) >> EmailNotifier
# s = Pipeline >>
#       Filter(type: 'machine.memory') >>
#       Categorize(:host) >>
#       Select(:free_percentage) >>
#       Threshold.new(:<, critical: 0.1, abnormal: 0.25) >>
#       OnChange.new(:normal) >>
#       Print.new

# require 'ostruct'
# puts "-"*100
# s.process(OpenStruct.new(type: 'machine.memory', host: 'a', free_percentage: 0.5))
# s.process(OpenStruct.new(type: 'machine.memory', host: 'b', free_percentage: 0.5))

require 'ostruct'

s = Filter.new(
      ->(e){ e.importance > 2 },
      children: [
        Splitter.new(
          ->(e){ e.type },
          children: [
            RateLimiter.new(
              1,
              1.second,
              children: [Printer.new]
            )
          ]
        )
      ]
    )

s.process(OpenStruct.new(importance: 7, type: 'cool'))
s.process(OpenStruct.new(importance: 8, type: 'cool'))
sleep 1
s.process(OpenStruct.new(importance: 8, type: 'cool'))

# class StreamBuilder

#   def initialize
#     @pipeline = []
#   end

#   def filter_by(property_values)
#     @pipeline << ->(n, e) {
#       n(e) if property_values.all?{ |k,v| e[k] == v }
#     }
#     self
#   end

#   def split_by(*properties)
#     @pipeline << ->(n,e) {

#     }
#     self
#   end

#   def threshold_for(property, direction, thresholds)
#     self
#   end

#   def on_change(default)
#     self
#   end

#   def print
#     self
#   end

#   def result
#     @pipeline
#   end
# end

# def stream
#   StreamBuilder.new
# end

# s = stream.
#       filter_by(type: 'machine.memory').
#       split_by(:host).
#       threshold_for(:free_percentage, :<, critical: 0.1, abnormal: 0.25).
#       on_change(:normal).
#       print

# s.result.call(test: 'test')
