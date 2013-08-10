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
    :ace   => [11, 1]}

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
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

  def initial_deal(deck)
    2.times do
      @hand.add_card(deck.deal_card)
    end
  end

  def hit(card)
    @hand.add_card(card)
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

  def finish_drawing_cards(deck)
    while @hand.points < 17
      hit(deck.deal_card)
    end
  end
end
