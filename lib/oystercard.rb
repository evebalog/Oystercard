
class Oystercard

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  TRAVEL_COST = 1
  attr_reader :balance, :entry_station, :journeys, :exit_station

  def initialize(set_balance = DEFAULT_BALANCE)
    raise "Cannot set balance over £#{MAXIMUM_BALANCE}" if set_balance > MAXIMUM_BALANCE
    @balance = set_balance
    @journeys = []
  end

  def top_up(value)
    raise "Cannot top up, you exceeded the £#{MAXIMUM_BALANCE} maximum balance" if @balance + value > MAXIMUM_BALANCE
    @balance += value
  end

  def in_journey?
    !!@entry_station
  end

  def touch_in(entry_station)
    raise "Insufficient funds on card" if @balance < MINIMUM_BALANCE
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(TRAVEL_COST)
    @exit_station = exit_station
    @journey = { :entry_station => entry_station, :exit_station => exit_station }
    @journeys << @journey
    @entry_station = nil
  end

  private

  def deduct(value)
    @balance -= value
  end
end
