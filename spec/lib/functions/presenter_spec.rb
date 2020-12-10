# frozen_string_literal: true

require_relative '../../../lib/matakana'

describe Matakana do
  let(:dummy_class) { Matakana::Functions::Main.new }

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
