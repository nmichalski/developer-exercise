require 'blackjack'

describe 'Blackjack' do
  describe Card do
    before(:all) do
      @card = Card.new(:hearts, :ten, 10)
    end

    it 'should have the correct suit' do
      @card.suit.should == :hearts
    end

    it 'should have the correct name' do
      @card.name.should == :ten
    end

    it 'should have the correct value' do
      @card.value.should == 10
    end
  end

  describe Deck do
    before(:all) do
      @deck = Deck.new
    end

    it 'should have 52 playable_cards in a new deck' do
      @deck.playable_cards.size.should == 52
    end

    it 'should not have dealt cards in the playable_cards' do
      card = @deck.deal_card
      @deck.playable_cards.should_not include(card)
    end

    it 'should have 52 playable_cards in a shuffled deck' do
      @deck.shuffle
      @deck.playable_cards.size.should == 52
    end
  end

  describe Hand do
  end
end
