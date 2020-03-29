# frozen_string_literal: true

require_relative '../../../lib/matakana.rb'

describe Matakana do
  let(:dummy_class) { Matakana::DataStores.new }

  context 'If the module variable is defined' do
    let(:expected_output) { { key_1: ['val_1'] } }

    before do
      dummy_class.save('key_1', 'val_1')
    end

    it 'will not override the existing datum when called externally' do
      expect(dummy_class.storage).to eq(expected_output)
    end
  end

  context 'If the module variable is not defined' do
    let(:expected_output) { {} }

    it 'will initialize the storage hash when called externally' do
      expect(dummy_class.storage).to eq(expected_output)
    end
  end
end
