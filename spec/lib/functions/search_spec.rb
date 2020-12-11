# frozen_string_literal: true

require_relative '../../../lib/matakana'

describe Matakana do
  let(:dummy_class) { Matakana::Functions::Main.new }

  describe '#fuzzy_search' do
    context 'when the search term will fuzzy yield results' do
      let(:arr) do
        [
          { key_0: 'val_0' },
          { key_1: 'val_1' },
          { key_11: 'val_11' },
          { key_: 'nil' },
          { key: 'nil' }
        ]
      end

      let(:search_term) { '1' }

      before do
        dummy_class.bulk_save(arr)
      end

      it 'yields the values for matched keys' do
        expect(dummy_class.fuzzy_search(search_term)).to eq(
          [
            ['val_1'],
            ['val_11']
          ],
        )
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
      it 'returns explicit message' do
        expect(dummy_class.find_by('key_1')).to eq('Term not present')
      end
    end
  end
end
