# frozen_string_literal: true

require_relative '../../../lib/matakana.rb'

describe Matakana do
  let(:dummy_class) { Matakana::DataStores.new }

  describe '#save' do
    context 'when key exists as key in core hash' do
      before do
        dummy_class.save('key_1', 'value_0')
      end

      context 'when key and value are passed as parameters' do
        shared_examples_for 'append the value correctly' do
          it 'appends the value correctly based on input type' do
            dummy_class.save(key, value)
            expect(dummy_class.storage).to eq(expected_output)
          end
        end

        context 'if type is string' do
          include_examples 'append the value correctly' do
            let(:key) { 'key_1' }
            let(:value) { 'value_1' }
            let(:expected_output) { { key_1: %w[value_0 value_1] } }
          end
        end

        context 'if type is fixnum' do
          include_examples 'append the value correctly' do
            let(:key) { 'key_1' }
            let(:value) { 1 }
            let(:expected_output) { { key_1: ['value_0', 1] } }
          end
        end

        context 'if type is float' do
          include_examples 'append the value correctly' do
            let(:key) { 'key_1' }
            let(:value) { 1.0 }
            let(:expected_output) { { key_1: ['value_0', 1.0] } }
          end
        end

        context 'if type is array' do
          include_examples 'append the value correctly' do
            let(:key) { 'key_1' }
            let(:value) { ['value_1'] }
            let(:expected_output) { { key_1: ['value_0', ['value_1']] } }
          end
        end

        context 'if type is hash' do
          include_examples 'append the value correctly' do
            let(:key) { 'key_1' }
            let(:value) { { nested_hash: 'value_1' } }
            let(:expected_output) { { key_1: ['value_0', { nested_hash: 'value_1' }] } }
          end
        end
      end

      context 'when key is passed without value as parameter' do
        it 'will not append nil value' do
          dummy_class.save('key_1')
          expect(dummy_class.storage).to eq({ key_1: ['value_0'] })
        end
      end
    end
  end

  describe '#bulk_save' do
    context 'when bulk data is an array type' do
      let(:arr) { [{ key_0: 'val_0' }, { key_1: 'val_1' }, { key_2: 'val_2' }, { key_3: 'val_3' }, { key_4: 'val_4' }] }

      it 'inserts all hashes inside array to core datum hash' do
        dummy_class.bulk_save(arr)
        expect(dummy_class.storage).to eq({ key_0: ['val_0'], key_1: ['val_1'], key_2: ['val_2'], key_3: ['val_3'], key_4: ['val_4'] })
      end
    end

    context 'when bulk data is not an array type' do
      let(:arr) { { key_0: 'val_0', key_1: 'val_1' } }

      it 'does not insert to the core datum hash' do
        dummy_class.bulk_save(arr)
        expect(dummy_class.storage).to eq({})
      end
    end
  end

  describe '#find_by' do
    context 'when key exists in the core hash' do
      before do
        dummy_class.save('key_1', 'value_1')
      end

      it 'returns the value of the key as an array' do
        expect(dummy_class.find_by('key_1')).to eq(['value_1'])
      end
    end

    context 'when key does not exist in the core hash' do
      it 'returns nil' do
        expect(dummy_class.find_by('key_1')).to eq(nil)
      end
    end
  end

  describe '#get_keys' do
    before do
      dummy_class.save('key_1', 'value_1')
      dummy_class.save('key_0', 'value_1')
    end

    context 'when quickly parameter is passed to options' do
      let(:options) { { quickly: true } }

      it 'does not sort the core hash' do
        expect(dummy_class).to receive(:sort).exactly(0).times
        dummy_class.get_keys(options)
      end

      it 'returns the hash in an unsorted manner' do
        expect(dummy_class.get_keys(options)).to eq(%i[key_1 key_0])
      end
    end

    context 'when quickly parameter is not passed to options' do
      it 'sorts the core hash' do
        expect(dummy_class).to receive(:sort).exactly(1).time
        dummy_class.get_keys
      end

      it 'returns the hash in a sorted manner' do
        expect(dummy_class.get_keys).to eq(%i[key_0 key_1])
      end
    end
  end
end
