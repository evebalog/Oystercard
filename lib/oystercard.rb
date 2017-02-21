
class Oystercard

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90

  attr_reader :balance

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
  end

  def top_up(value)
    raise "Cannot top up, you exceeded the £#{MAXIMUM_BALANCE} maximum balance" if @balance + value > MAXIMUM_BALANCE
    @balance += value
  end
end
