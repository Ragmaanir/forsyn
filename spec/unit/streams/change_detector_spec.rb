describe Forsyn::Streams::ChangeDetector do
  it '' do
    target = []
    sink = Forsyn::Streams::Sink.new(target)

    stream = described_class.new(
      ->(e){ e.special },
      default: true,
      children: [sink]
    )

    e1 = OpenStruct.new(special: true)
    e2 = OpenStruct.new(special: false)

    stream.process(e1)
    stream.process(e2)

    assert{ target == [e2] }
  end
end
