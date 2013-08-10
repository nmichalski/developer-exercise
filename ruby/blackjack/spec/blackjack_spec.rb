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
    before(:each) do
      @king_of_clubs  = Card.new(:clubs,  :king, 10)
      @ace_of_clubs   = Card.new(:clubs,  :ace,  [11, 1])
      @ace_of_hearts  = Card.new(:hearts, :ace,  [11, 1])
      @ace_of_spades  = Card.new(:spades, :ace,  [11, 1])
      @four_of_spades = Card.new(:spades, :four, 4)

      @hand = Hand.new
    end

    it 'should treat an ace like an 11 when it doesnt result in a bust' do
      @hand.cards = [@king_of_clubs, @ace_of_hearts]
      @hand.points.should == 21
    end

    it 'should treat an ace like a 1 when it would otherwise result in a bust' do
      @hand.cards = [@king_of_clubs, @ace_of_hearts, @four_of_spades]
      @hand.points.should == 15
    end

    it 'should treat multiple (3) aces like a 1 when it would otherwise result in a bust' do
      @hand.cards = [@king_of_clubs, @ace_of_clubs, @ace_of_hearts, @ace_of_spades, @four_of_spades]
      @hand.points.should == 17
    end
  end

  describe Player do
    before(:each) do
      @deck = Deck.new
      @player = Player.new
    end

    it 'should be dealt a hand with 2 cards' do
      @player.initial_deal(@deck)

      @player.hand.cards.size.should == 2
    end

    it 'should be able to see the card the dealer is showing' do
      dealer = Dealer.new
      dealer.initial_deal(@deck)
      dealer.shown_card.should == dealer.hand.cards.first
    end

    it 'should bust (lose immediately) when hand value is more than 21' do
      @player.initial_deal(@deck)

      while @player.hand_value <= 21
        @player.hit(@deck.deal_card)
      end

      @player.has_bust?.should == true
    end

    it 'should blackjack (win immediately) when hand value is exactly 21' do
      @player.hand.stub!(:points).and_return(21)

      @player.has_blackjack?.should == true
    end
  end

  describe Dealer do
    before(:each) do
      @deck = Deck.new
      card1 = Card.new(:clubs, :king, 10)
      card2 = Card.new(:hearts, :six, 6)
      card3 = Card.new(:spades, :four, 4)
      @deck.playable_cards = [card1, card2, card3]

      @dealer = Dealer.new
      @dealer.initial_deal(@deck)
    end

    it 'should have an initial hand with 2 cards' do
      @dealer.hand.cards.size.should == 2
    end

    it 'should stay at any hand value at 17 or higher' do
      expect { @dealer.finish_drawing_cards(@deck) }.to change{@dealer.hand_value}.to(20)
    end

    it 'should draw cards after the player until it wins or loses' do
      player = Player.new
      player.hand.stub!(:points).and_return(18)

      @dealer.finish_drawing_cards(@deck)

      @dealer.has_bust?.should == false
      @dealer.has_blackjack?.should == false
      @dealer.hand_value.should > player.hand_value
    end
  end

  it 'should play a game' do
    expect do
      deck = Deck.new
      player = Player.new
      dealer = Dealer.new

      player.initial_deal(deck)
      dealer.initial_deal(deck)

      if player.has_blackjack?
        raise "player wins (with blackjack)!"
      elsif rand(0..1) == 0 #player randomly hits once
        player.hit(deck.deal_card)
        raise "dealer wins (player bust)!" if player.has_bust?
      end

      #dealer hits according to his 17 rule
      dealer.finish_drawing_cards(deck)
      raise "player wins (dealer bust)!" if dealer.has_bust?

      if player.hand_value > dealer.hand_value
        raise "player wins (> dealer hand)!"
      elsif player.hand_value < dealer.hand_value
        raise "dealer wins (> player hand)!"
      else # player.hand_value == dealer.hand_value
        raise "it's a push!"
      end
    end.to raise_error
  end
end
