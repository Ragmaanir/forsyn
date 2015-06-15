describe Forsyn::Responders::StatefulResponder do

  States = Forsyn::AlertState::States

  let(:responder) { described_class.new }
  let(:trigger)   {
    Forsyn::Triggers::ThresholdTrigger.new('Test', critical: 10, abnormal: 5)
  }

  let(:normal_sample)   { Forsyn::Sample.new(Time.now, 2) }
  let(:warn_sample)     { Forsyn::Sample.new(Time.now, 6) }
  let(:critical_sample) { Forsyn::Sample.new(Time.now, 11) }

  it 'can be connected to checkers' do
    responder.input_from(trigger)
    assert { trigger.in?(responder.inputs) }
  end

  it 'detects :alert state immediately' do
    responder.input_from(trigger)

    trigger.check(critical_sample)

    assert { responder.current_level == States::CRITICAL }
  end

  it 'stays in worst state for cooldown-time' do
    responder.input_from(trigger)

    trigger.check(normal_sample)

    assert { responder.current_level == States::NORMAL }

    trigger.check(warn_sample)

    assert { responder.current_level == States::ABNORMAL }

    trigger.check(critical_sample)

    assert { responder.current_level == States::CRITICAL }

    trigger.check(normal_sample)

    assert { responder.current_level == States::CRITICAL }

    Timecop.freeze(responder.cooldown.from_now) do
      trigger.check(Forsyn::Sample.new(Time.now, 2))
      assert { responder.current_level == States::NORMAL }
    end
  end
end
