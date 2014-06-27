module Forsyn
  class AlertState

  private

    def initialize(value)
      @value = value
    end

  public

    ALARM   = AlertState.new(3)
    WARN    = AlertState.new(2)
    INFO    = AlertState.new(1)
    NORMAL  = AlertState.new(0)
    UNKNOWN = AlertState.new(-1)

    attr_reader :value

    def <=>(other)
      case other
        when AlertState then value <=> other.value
        else false
      end
    end

  end

end
