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
end
