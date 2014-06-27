module Forsyn
  class AlertState

  private

    def initialize(value)
      @value = value
    end

  public

    CRITICAL = AlertState.new(3)
    ABNORMAL = AlertState.new(2)
    NOTABLE  = AlertState.new(1)
    NORMAL   = AlertState.new(0)
    UNKNOWN  = AlertState.new(-1)

    attr_reader :value

    def <=>(other)
      value <=> other.value if other.is_a?(AlertState)
    end

  end

end
