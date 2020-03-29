# frozen_string_literal: true

require_relative '../../../lib/matakana.rb'

describe Matakana do
  let(:dummy_class) { Class.new.include(described_class).new }

  before do
    described_class.class_variable_set :@@storage, nil
  end

  describe '#save' do
    context 'when key exists as key in core hash' do
      before do
        dummy_class.save('key_1', 'value_0')
      end

      context 'when key and value are passed as parameters' do
        it 'will append the value correctly if type is string' do
          dummy_class.save('key_1', 'value_1')
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: %w[value_0 value_1] })
        end

        it 'will append the value correctly if type is fixnum' do
          dummy_class.save('key_1', 1)
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: ['value_0', 1] })
        end

        it 'will append the value correctly if type is float' do
          dummy_class.save('key_1', 1.0)
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: ['value_0', 1.0] })
        end

        it 'will append the value correctly if type is array' do
          dummy_class.save('key_1', ['value_1'])
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: ['value_0', ['value_1']] })
        end

        it 'will append the value correctly if the type is hash' do
          dummy_class.save('key_1', { nested_hash: 'value_1' })
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: ['value_0', { nested_hash: 'value_1' }] })
        end
      end

      context 'when key is passed without value as parameter' do
        it 'will not append nil value' do
          dummy_class.save('key_1')
          expect(described_class.class_variable_get :@@storage).to eq({ key_1: ['value_0'] })
        end
      end
    end
  end

  describe '#bulk_save' do
    context 'when bulk data is an array type' do
      let(:arr) { [{ key_0: 'val_0' }, { key_1: 'val_1' }, { key_2: 'val_2' }, { key_3: 'val_3' }, { key_4: 'val_4' }] }

      it 'inserts all hashes inside array to core datum hash' do
        dummy_class.bulk_save(arr)
        expect(described_class.class_variable_get :@@storage).to eq({ key_0: ['val_0'], key_1: ['val_1'], key_2: ['val_2'], key_3: ['val_3'], key_4: ['val_4'] })
      end
    end

    context 'when bulk data is not an array type' do
      let(:arr) { { key_0: 'val_0', key_1: 'val_1' } }

      it 'does not insert to the core datum hash' do
        dummy_class.bulk_save(arr)
        expect(described_class.class_variable_get :@@storage).to eq(nil)
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
        expect(dummy_class.get_keys(options)).to eq({ key_1: ['value_1'], key_0: ['value_1'] })
      end
    end

    context 'when quickly parameter is not passed to options' do
      it 'sorts the core hash' do
        expect(dummy_class).to receive(:sort).exactly(1).time
        dummy_class.get_keys
      end

      it 'returns the hash in a sorted manner' do
        expect(dummy_class.get_keys).to eq({ key_0: ['value_1'], key_1: ['value_1'] })
      end
    end
  end
end
