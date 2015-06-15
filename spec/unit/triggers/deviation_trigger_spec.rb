describe Forsyn::Triggers::DeviationTrigger do

  let(:checker)         { described_class.new('Test', 100, critical: 10, abnormal: 9) }
  let(:normal_sample)   { Forsyn::Sample.new(Time.now, 108) }
  let(:critical_sample) { Forsyn::Sample.new(Time.now, 111) }

  it 'passes the alert-state to the responder' do
    responder = double('responder').as_null_object
    checker.responders << responder

    checker.check(normal_sample)
    expect(responder).to have_received(:receive).with(checker, Forsyn::AlertState::States::NORMAL, anything())

    checker.check(critical_sample)
    expect(responder).to have_received(:receive).with(checker, Forsyn::AlertState::States::CRITICAL, anything())
  end

  it 'recognizes a negative deviation' do
    responder = double('responder').as_null_object
    checker.responders << responder

    checker.check(Forsyn::Sample.new(Time.now, 89))
    expect(responder).to have_received(:receive).with(checker, Forsyn::AlertState::States::CRITICAL, anything())
  end

end
