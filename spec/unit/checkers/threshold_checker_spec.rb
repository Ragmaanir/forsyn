describe Forsyn::Checkers::ThresholdChecker do

  let(:checker)         { described_class.new('TestChecker', critical: 10, abnormal: 9) }
  let(:normal_sample)   { Forsyn::Sample.new(Time.now, 8) }
  let(:critical_sample) { Forsyn::Sample.new(Time.now, 11) }

  it 'warns when no responder set' do
    expect(Forsyn.logger).to receive(:warn)

    checker.check(normal_sample)
  end

  it 'passes the alert-state to the responder' do
    responder = double('responder').as_null_object
    checker.responders << responder

    checker.check(normal_sample)
    expect(responder).to have_received(:receive).with(checker, Forsyn::AlertState::States::NORMAL, anything())

    checker.check(critical_sample)
    expect(responder).to have_received(:receive).with(checker, Forsyn::AlertState::States::CRITICAL, anything())
  end

end
