# frozen_string_literal: true

require_relative '../../../lib/matakana.rb'
require_relative '../../../lib/helpers/utils.rb'

include Matakana::Utils

describe Matakana do
  let(:dummy_class) { Matakana::DataStores.new }

  describe '#check_key' do
    let(:valid_parameter) { :valid_search_type }
    let(:invalid_parameter) { [:invalid_search_type] }

    context 'when the parameter is a valid key type' do
      it 'does not raise an error' do
        expect { dummy_class.check_key(valid_parameter) }.not_to raise_error
      end

      it 'passes the parameter to key_exists' do
        expect(dummy_class).to receive(:key_exists?).with(valid_parameter)
        dummy_class.check_key(valid_parameter)
      end
    end

    context 'when the parameter is not a valid key type' do
      it 'raises an error' do
        expect { dummy_class.check_key(invalid_parameter) }.to raise_error(TypeError, /key must be a String or Symbol/)
      end
    end
  end

  describe '#key_exists?' do
    let(:valid_parameter) { :valid }
    let(:invalid_parameter) { :invalid }

    before do
      dummy_class.save('valid', 'search_result')
    end

    context 'when the key is present' do
      it 'returns nil' do
        expect(dummy_class.key_exists?(valid_parameter)).to eq(nil)
      end
    end

    context 'when the key is not present' do
      it 'inserts the key to storage with an empty array as the value' do
        expect(dummy_class.key_exists?(invalid_parameter)).to eq([])
      end
    end
  end

  describe '#merge_arr' do
    let(:insert_array) { [{ key_1: 'value_1' }, { key_2: 'value_2' }, { key_1: 'value_3' }] }
    let(:insert_hash) { { key_1: 'value_1' } }

    context 'when the object is an array' do
      let(:expected_output) { [{ key_1: %w[value_1 value_3] }, { key_2: ['value_2'] }] }
      it 'merges the array based on the hash keys' do
        expect(insert_array.merge_arr).to eq(expected_output)
      end
    end

    context 'when the object is not an array' do
      it 'returns nil' do
        expect(insert_hash.merge_arr).to eq(nil)
      end
    end
  end

  describe '#sort' do
    before do
      dummy_class.save('valid_1', 'save_result')
      dummy_class.save('valid_0', 'save_result')
    end

    it 'sorts the storage keys' do
      expect(dummy_class.sort).to eq(%i[valid_0 valid_1])
    end
  end

  describe '#value_type' do
    let(:return_array) { %i[the count is too high] }
    let(:non_returned_array) { %i[perfect] }
    let(:non_returned_value) { :perfect }

    it 'returns the array if there are more than one values' do
      expect(dummy_class.value_type(return_array)).to eq(return_array)
    end

    it 'returns the first value if the array has one value' do
      expect(dummy_class.value_type(non_returned_array)).to eq(non_returned_value)
    end
  end
end
