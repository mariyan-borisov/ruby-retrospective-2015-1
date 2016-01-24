class Integer
  def prime?
    return false if self <= 1
    2.upto(self**0.5).all? { |number| self % number != 0 }
  end
end

class RationalSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each
    i = j = 1
    direction = 1
    changed = false
    unique_numbers = []
    @count.times do |x|
      new_number = Rational(i, j)
      while unique_numbers.include? new_number
        i, j, direction, changed = *increment_direction(i, j, direction, changed)
        new_number = Rational(i, j)
      end
      unique_numbers << new_number
      yield new_number
    end
  end

  private
  def increment_direction(i, j, direction, direction_changed)
    if j == 1 and not direction_changed
      direction_changed = true
      direction = -direction
      i += 1
    elsif i == 1 and not direction_changed
      direction_changed = true
      direction = -direction
      j += 1
    else
      direction_changed = false
      i += direction
      j -= direction
    end
    [i, j, direction, direction_changed]
  end
end

class PrimeSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each
    prime_numbers = (2..Float::INFINITY).lazy.select { |number| number.prime? }.take(@count)
    prime_numbers.each { |number| yield number }
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(count, first: 1, second: 1)
    @count = count
    @first_number = first
    @second_number = second
  end

  def each
    previous = @first_number
    current = @second_number
    @count.times do |_|
      yield previous
      previous, current = current, previous + current
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rational = RationalSequence.new(n)
    groups = rational.partition { |number| number.numerator.prime? or number.denominator.prime? }
    groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
  end

  def aimless(n)
    prime_numbers = PrimeSequence.new(n).to_a
    prime_numbers << 1 if n.odd?
    rational_numbers = []
    prime_numbers.each_slice(2) { |array| rational_numbers << Rational(array[0], array[1]) }
    rational_numbers.reduce(0, :+)
  end

  def worthless(n)
    fibonacci_number = FibonacciSequence.new(n).to_a.last
    rational_numbers = RationalSequence.new(n).to_a
    sum = 0
    rational_numbers.take_while do |number|
      sum += number
      sum <= fibonacci_number
    end
  end
end
