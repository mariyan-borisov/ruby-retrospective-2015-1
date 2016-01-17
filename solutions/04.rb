class Card

  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end

  def ==(card)
    @rank == card.rank and @suit == card.suit
  end

end

class Hand

  def initialize(cards)
    @cards = cards.dup
  end

  def size
    @cards.size
  end

  def has_queen_and_king?(suits)
    suits.any? do |suit|
      [:queen, :king].all? { |rank| @cards.include? Card.new(rank, suit) }
    end
  end

end

class WarHand < Hand

  def play_card
    @cards.delete_at(rand(@cards.length))
  end

  def allow_face_up?
    @cards.size <= 3
  end

end

class BeloteHand < Hand

  def highest_of_suit(suit)
    cards_of_suit = @cards.select { |card| card.suit == suit }
    cards_of_suit.max_by { |card| BeloteDeck::RANKS.index(card.rank) }
  end

  def belote?
    has_queen_and_king?(BeloteDeck::SUITS)
  end

  def tierce?
    cards_in_a_row?(3)
  end

  def quarte?
    cards_in_a_row?(4)
  end

  def quint?
    cards_in_a_row?(5)
  end

  def carre_of_jacks?
    carre?(:jack)
  end

  def carre_of_nines?
    carre?(9)
  end

  def carre_of_aces?
    carre?(:ace)
  end

  private

  def cards_in_a_row?(count)
    BeloteDeck::SUITS.any? do |suit|
      cards_of_suit = @cards.select { |card| card.suit == suit }
      cards_of_suit.map!(&:rank)
      ranks_included = BeloteDeck::RANKS.map do |rank|
        cards_of_suit.include?(rank)
      end
      chunks = ranks_included.chunk { |included| included }
      consecutive_chunks = chunks.select { |chunk| chunk.first }
      consecutive_chunks.max_by { |chunk| chunk.last.size }.last.size == count
    end
  end

  def carre?(rank)
    @cards.count { |card| card.rank == rank } == 4
  end

end

class SixtySixHand < Hand

  def twenty?(trump_suit)
    has_queen_and_king?(SixtySixDeck::SUITS - trump_suit)
  end

  def forty?(trump_suit)
    has_queen_and_king?([trump_suit])
  end

end

class Deck

  include Enumerable

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace].freeze
  SUITS = [:spades, :hearts, :diamonds, :clubs].freeze
  DEAL_COUNT = 1

  def initialize(cards = nil)
    if cards == nil
      @cards = self.class::RANKS.product(self.class::SUITS).map do |card|
        Card.new(card[0], card[1])
      end
    else
      @cards = cards.dup
    end
  end

  def each(&block)
    @cards.each &block
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards[0]
  end

  def bottom_card
    @cards[-1]
  end

  def shuffle
    @cards.shuffle!
    self
  end

  def sort
    ranks = self.class::RANKS
    suits = self.class::SUITS
    @cards.sort! do |first_card, second_card|
      if first_card.suit == second_card.suit
        ranks.index(second_card.rank) <=> ranks.index(first_card.rank)
      else
        suits.index(first_card.suit) <=> suits.index(second_card.suit)
      end
    end
    self
  end

  def to_s
    @cards.join "\n"
  end

  def deal
    self.class::DEAL_CLASS.new(@cards.slice!(0, self.class::DEAL_COUNT))
  end

end

class WarDeck < Deck

  DEAL_COUNT = 26
  DEAL_CLASS = WarHand

end

class BeloteDeck < Deck

  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace].freeze
  DEAL_COUNT = 8
  DEAL_CLASS = BeloteHand

end

class SixtySixDeck < Deck

  RANKS = [9, :jack, :queen, :king, 10, :ace].freeze
  DEAL_COUNT = 6
  DEAL_CLASS = SixtySixHand

end
