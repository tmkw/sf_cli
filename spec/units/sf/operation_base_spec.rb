RSpec.describe 'SfCli::Sf::Base' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:base) { SfCli::Sf::OperationBase.new(sf) }

  describe '#field_value_pairs' do
    it "joins each key and value with '='" do
      expect(base.__send__ :field_value_pairs, {a: 100}).to eq 'a=100'
    end

    it "joins each converted pairs with white space" do
      expect(base.__send__(:field_value_pairs, {a: 100, b: 200})).to eq 'a=100 b=200'
    end

    context 'when value is a string object' do
      it "puts single quatation around the value" do
        expect(base.__send__ :field_value_pairs, {a: 'abc'}).to eq "a='abc'"
      end

      it 'can convert and join pairs regardless the value is string or not' do
        expect(base.__send__ :field_value_pairs, {
          a: 'abc',
          b: 100,
          'c' => 500,
          'd' => "I am here",
        })
        .to eq "a='abc' b=100 c=500 d='I am here'"
      end
    end
  end
end
