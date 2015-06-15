class Value < Struct(:value, :unit)
  def <=>(other)
    case other
      when Value then value <=> other.value
      else raise
    end
  end
end
