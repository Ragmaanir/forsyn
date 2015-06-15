describe Forsyn::Streams::Filter do
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

    assert{ target == [e1, e3] }
  end
end
