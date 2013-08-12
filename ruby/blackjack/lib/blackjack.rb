class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end

  def min_value
    @name == :ace ? @value.min : @value
  end

  def max_value
    @name == :ace ? @value.max : @value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]
  }

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITS.each do |suit|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suit, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def points
    calculated_points = @cards.inject(0) {|sum, card| sum += card.max_value}
    return calculated_points if calculated_points <= 21

    number_of_aces = @cards.count{|card| card.name == :ace}
    while (calculated_points > 21) && (number_of_aces != 0)
      calculated_points -= 10
      number_of_aces -= 1
    end

    calculated_points
  end

  def first_card
    @cards.first
  end

  def add_card(card)
    @cards << card
  end
end

class Player
  attr_accessor :hand, :game

  def initialize(game)
    @game = game
    @hand = Hand.new
  end

  def hit
    dealt_card = @game.deal_card
    @hand.add_card(dealt_card)
  end

  def finish_drawing_cards
    hit if should_hit?
  end

  def should_hit?
    rand(2) == 0 #player randomly hits once
  end

  def has_bust?
    @hand.points > 21
  end

  def has_blackjack?
    @hand.points == 21
  end

  def hand_value
    @hand.points
  end
end

class Dealer < Player
  def shown_card
    @hand.first_card
  end

  def finish_drawing_cards
    while @hand.points < 17
      hit
    end
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new(self)
    @dealer = Dealer.new(self)
  end

  def initial_deal
    2.times do
      @player.hit
      @dealer.hit
    end
  end

  def deal_card
    @deck.deal_card
  end

  def player_finishes_drawing_cards
    @player.finish_drawing_cards
  end

  def dealer_finishes_drawing_cards
    @dealer.finish_drawing_cards
  end

  def decide_winner
    winner = nil
    if @player.hand_value > @dealer.hand_value
      winner = 'player'
    elsif @player.hand_value < @dealer.hand_value
      winner = 'dealer'
    end
    winner
  end

  def complete_a_round
    initial_deal
    return 'player wins with blackjack!' if @player.has_blackjack?

    player_finishes_drawing_cards
    return 'player bust!' if @player.has_bust?
    return 'player wins with blackjack!' if @player.has_blackjack?

    dealer_finishes_drawing_cards
    return 'player wins since dealer bust!' if @dealer.has_bust?

    winner = decide_winner
    return (winner ? "#{winner} wins with a better hand!" : "it's a push!")
  end
end
