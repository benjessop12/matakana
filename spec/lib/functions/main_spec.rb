# frozen_string_literal: true

require_relative '../../../lib/matakana'

describe Matakana do
  let(:dummy_class) { Matakana::Functions::Main.new }

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
            let(:expected_output) do
              {
                key_1: ['value_0', { nested_hash: 'value_1' }]
              }
            end
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
      let(:arr) do
        [
          { key_0: 'val_0' },
          { key_1: 'val_1' },
          { key_2: 'val_2' },
          { key_3: 'val_3' },
          { key_4: 'val_4' }
        ]
      end

      it 'inserts all hashes inside array to core datum hash' do
        dummy_class.bulk_save(arr)
        expect(dummy_class.storage).to eq(
          {
            key_0: ['val_0'],
            key_1: ['val_1'],
            key_2: ['val_2'],
            key_3: ['val_3'],
            key_4: ['val_4']
          },
        )
      end
    end

    context 'when bulk data is not an array type' do
      let(:arr) { { key_0: 'val_0', key_1: 'val_1' } }

      it 'does not insert to the core datum hash' do
        expect { dummy_class.bulk_save(arr) }
          .to raise_error(
            Matakana::Exceptions::InvalidStoredType,
            /Invalid stored type. Expected Array. Got Hash/,
          )
      end
    end
  end
end
