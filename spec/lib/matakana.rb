# frozen_string_literal: true

require_relative '../../lib/matakana'

describe Matakana do
  before do
    described_class.class_variable_set :@@storage, nil
  end

  context 'When the gem is called externally' do
    let(:dummy_class) { Class.new.include(described_class).new }

    it 'initializes the core data hash' do
      expect(dummy_class.initialize_storage).to eq({})
    end

    it 'allows extended module methods to be called from external class' do
      dummy_class.initialize_storage
      expect(dummy_class.save('key_1', 'value_1')).to eq(['value_1'])
    end
  end
end
