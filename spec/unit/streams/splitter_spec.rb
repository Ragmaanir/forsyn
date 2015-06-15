describe Forsyn::Streams::Splitter do
  it '' do
    target = []
    sink = Forsyn::Streams::Sink.new(target)

    stream = described_class.new(
      ->(e){ e.special },
      children: [sink]
    )

    e1 = OpenStruct.new(special: true)
    e2 = OpenStruct.new(special: false)
    e3 = OpenStruct.new(special: true)

    stream.process(e1)
    stream.process(e2)
    stream.process(e3)

    assert{ target == [e1, e2, e3] }
    assert{ stream.buckets.keys == [true, false] }
    assert{ stream.buckets.values.first != stream.buckets.values.last }
  end

  it '' do
    target = []
    sink = Forsyn::Streams::Sink.new(target)

    stream = described_class.new(
      ->(e){ e.special },
      children: [
        Forsyn::Streams::RateLimiter.new(
          1, 1.second,
          children: [sink]
        )
      ]
    )

    e1 = OpenStruct.new(special: true)
    e3 = OpenStruct.new(special: false)
    e2 = OpenStruct.new(special: true)
    e4 = OpenStruct.new(special: false)

    stream.process(e1)
    stream.process(e2)
    stream.process(e3)
    stream.process(e4)

    assert{ target == [e1, e3] }
    assert{ stream.buckets.keys == [true, false] }
    assert{ stream.buckets.values.first != stream.buckets.values.last }
  end

  it '' do
    fake_stream = OpenStruct.new(count: 0)

    def fake_stream.process(e)
      self.count += 1
    end

    stream = described_class.new(
      ->(e){ e.special },
      children: [fake_stream]
    )

    e1 = OpenStruct.new(special: true)
    e2 = OpenStruct.new(special: false)
    e3 = OpenStruct.new(special: true)

    stream.process(e1)
    stream.process(e2)
    stream.process(e3)

    assert{ stream.children.length == 2 }
    assert{ stream.children.first.count == 2 }
    assert{ stream.children.second.count == 1 }
  end
end
