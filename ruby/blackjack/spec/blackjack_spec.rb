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
      @game = Game.new
      @game.initial_deal
      @player = @game.player
    end

    it 'should be dealt a hand with 2 cards' do
      @player.hand.cards.size.should == 2
    end

    it 'should be able to see the card the dealer is showing' do
      dealer = @game.dealer
      dealer.shown_card.should == dealer.hand.cards.first
    end

    it 'should bust (lose immediately) when hand value is more than 21' do
      while @player.hand_value <= 21
        @player.hit
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
      @game = Game.new
      @game.initial_deal
    end

    it 'should have an initial hand with 2 cards' do
      dealer = @game.dealer
      dealer.hand.cards.size.should == 2
    end

    it 'should stay at any hand value at 17 or higher' do
      dealer = @game.dealer
      dealer.hand.stub!(:points).and_return(17)
      dealer.should_receive(:hit).exactly(0).times

      dealer.finish_drawing_cards
    end

    it 'should draw cards after the player until it wins or loses' do
      player = @game.player
      player.hand.stub!(:points).and_return(18)
      player.stub!(:should_hit?).and_return(false)

      dealer = @game.dealer
      dealer.hand.stub!(:points).and_return(20)
      dealer.finish_drawing_cards

      dealer.hand_value.should > player.hand_value
    end
  end

  describe Game do
    before(:all) do
      @game = Game.new
    end

    it 'should connect both players to the same game' do
      @game.player.game.should == @game
      @game.dealer.game.should == @game
    end

    it 'should initially deal 2 cards to the player and dealer' do
      @game.initial_deal
      @game.player.hand.cards.size.should == 2
      @game.dealer.hand.cards.size.should == 2
    end

    it 'should decide a winner when hand values arent blackjack or bust' do
      @game.player.stub!(:hand_value).and_return(20)
      @game.dealer.stub!(:hand_value).and_return(18)
      @game.decide_winner.should == 'player'
    end

    it 'should play a game' do
      game_over_message = @game.complete_a_round
      possible_outcomes = [
        'player wins with blackjack!',
        'player bust!',
        'player wins since dealer bust!',
        'player wins with a better hand!',
        'dealer wins with a better hand!',
        "it's a push!"
      ]
      possible_outcomes.should include(game_over_message)
    end
  end
end
