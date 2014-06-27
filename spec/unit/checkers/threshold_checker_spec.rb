describe Forsyn::Checkers::ThresholdChecker do

  let(:checker) { described_class.new('TestChecker', alert: 10, warn: 9) }

  it 'warns when no responder set' do
    ok = Forsyn::Sample.new(Time.now, 8)

    expect(Forsyn.logger).to receive(:warn)
    checker.check(ok)
  end

  it 'passes the alert-state to the responder' do
    ok    = Forsyn::Sample.new(Time.now, 8)
    alert = Forsyn::Sample.new(Time.now, 11)

    responder = double('responder').as_null_object
    checker.responders << responder

    checker.check(ok)
    expect(responder).to have_received(:receive).with(checker, :normal, anything())

    checker.check(alert)
    expect(responder).to have_received(:receive).with(checker, :alert, anything())
  end

end
