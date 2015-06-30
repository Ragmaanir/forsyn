describe Forsyn::Configuration do

  let(:cfg) { described_class.new }

  it 'uses a default value' do
    assert{ cfg.hard_queue_size_limit == 10_000 }
  end

  it 'stores a assigned value' do
    cfg.hard_queue_size_limit = 13370

    assert{ cfg.hard_queue_size_limit == 13370 }
  end

  it 'raises when type incorrect' do
    expect{ cfg.hard_queue_size_limit = 'lol' }.to raise_error(ArgumentError)
  end

  it 'raises when hard limit smaller than soft limit' do
    expect{ cfg.hard_queue_size_limit = 1 }.to raise_error(Forsyn::Configuration::MisconfigurationError)
  end

  it '' do
    cfg.finalize!
    expect{ cfg.hard_queue_size_limit = 13370 }.to raise_error(RuntimeError)
  end

end
