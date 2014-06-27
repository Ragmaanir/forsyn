module Forsyn
  class AlertState

  private

    def initialize(name, value)
      @name = name
      @value = value
    end

  public

    module States
      CRITICAL = AlertState.new('Critical', 3)
      ABNORMAL = AlertState.new('Abnormal', 2)
      NOTABLE  = AlertState.new('Notable',  1)
      NORMAL   = AlertState.new('Normal',   0)
      UNKNOWN  = AlertState.new('Unknown', -1)

      ALL = [CRITICAL, ABNORMAL, NOTABLE, NORMAL, UNKNOWN]
    end

    def self.worst(*values)
      values = values.to_a.flatten

      max = values.map(&:value).max

      from_value(max)
    end

    def self.from_value(value)
      States::ALL.find{ |v| v.value == value } || raise(ArgumentError)
    end

    attr_reader :value

    def <=>(other)
      value <=> other.value if other.is_a?(AlertState)
    end

    def to_s
      @name
    end

  end

end
