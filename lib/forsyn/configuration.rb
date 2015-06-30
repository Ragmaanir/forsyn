module Forsyn
  class Configuration

    class MisconfigurationError < RuntimeError
    end

    def self.attribute(name, type, options)
      name = name.to_s
      type = [type].flatten

      self.send :define_method, name do
        instance_variable_get('@'+name) || options[:default]
      end

      self.send :define_method, "#{name}=" do |value|
        raise ArgumentError if type.none?{ |t| value.kind_of?(t) }
        instance_variable_set('@'+name, value)
        validate!
      end

    end

    attribute :hard_queue_size_limit, Integer, default: 10_000
    attribute :soft_queue_size_limit, Integer, default: 9_000

    attribute :hard_client_event_limit, Integer, default: 1_000
    attribute :soft_client_event_limit, Integer, default: 900

    attribute :logger, Object, default: Logger.new(STDOUT)

    def finalize!
      #@finalized = true
      freeze
    end

  private

    def validate!
      raise MisconfigurationError if hard_queue_size_limit < soft_queue_size_limit
      raise MisconfigurationError if hard_client_event_limit < soft_client_event_limit
    end

  end
end
