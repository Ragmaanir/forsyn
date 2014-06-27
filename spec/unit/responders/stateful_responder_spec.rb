describe Forsyn::Responders::StatefulResponder do

  let(:responder) { described_class.new }
  let(:checker)   {
    Forsyn::Checkers::ThresholdChecker.new('TestChecker', critical: 10, abnormal: 5)
  }

  let(:normal_sample)   { Forsyn::Sample.new(Time.now, 2) }
  let(:warn_sample)     { Forsyn::Sample.new(Time.now, 6) }
  let(:critical_sample) { Forsyn::Sample.new(Time.now, 11) }

  it 'can be connected to checkers' do
    responder.input_from(checker)
    expect(responder.checkers).to include(checker)
  end

  it 'detects :alert state immediately' do
    responder.input_from(checker)

    checker.check(critical_sample)

    expect(responder.current_level).to eq(Forsyn::AlertState::States::CRITICAL)
  end

  it 'stays in worst state for cooldown-time' do
    responder.input_from(checker)

    checker.check(normal_sample)

    expect(responder.current_level).to eq(Forsyn::AlertState::States::NORMAL)

    checker.check(warn_sample)

    expect(responder.current_level).to eq(Forsyn::AlertState::States::ABNORMAL)

    checker.check(critical_sample)

    expect(responder.current_level).to eq(Forsyn::AlertState::States::CRITICAL)

    checker.check(normal_sample)

    expect(responder.current_level).to eq(Forsyn::AlertState::States::CRITICAL)
  end
end
