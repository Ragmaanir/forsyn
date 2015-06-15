describe Forsyn::Streams::RateLimiter do
  it '' do
    target = []
    sink = Forsyn::Streams::Sink.new(target)

    stream = described_class.new(
      1, 1.second,
      children: [sink]
    )

    e1 = OpenStruct.new(special: true)
    e2 = OpenStruct.new(special: true)
    e3 = OpenStruct.new(special: true)

    now = Time.now

    at(now) do
      stream.process(e1)
      stream.process(e2)
    end

    at(now+2.seconds) do
      stream.process(e3)
    end

    assert{ target == [e1, e3] }
  end
end
