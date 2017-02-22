require 'oystercard'

describe Oystercard do

  describe 'attributes' do
    it 'has a default balance of zero' do
      expect(subject.balance).to eq Oystercard::DEFAULT_BALANCE
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#top_up' do

    it 'can top up oystercard with set amount' do
      expect{ subject.top_up 10 }.to change{ subject.balance }.by 10
    end

    it 'raises an error if top up would increase balance over top up limit' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up(1)}.to raise_error "Cannot top up, you exceeded the £#{maximum_balance} maximum balance"
    end

  end

  describe 'journey' do
    let(:entry_station) {double :station}
    let(:exit_station) {double :station}

    context '#in_journey?' do

      it 'checks the card is not in journey' do
        expect(subject.in_journey?).to eq false
      end

    end
    context '#touch_in' do
      it { is_expected.to respond_to(:touch_in).with(1).argument }

      it 'raises an error if there are insufficient funds' do
        expect{ subject.touch_in(entry_station) }.to raise_error "Insufficient funds on card"
      end

      it "starts the oystercard's journey" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        expect(subject.in_journey?).to eq true
      end

      it "adds an entry station to the card on touch in" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        expect(subject.entry_station).to eq(entry_station)

      end

    end

    context '#touch_out' do

      it "finishes the oystercard's journey" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject.in_journey?).to eq false
      end

      it "decreases the card's balance on touch out" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        expect{ subject.touch_out(exit_station) }.to change{ subject.balance}.by -Oystercard::TRAVEL_COST
      end

      it 'deducts amount from the balance' do
        subject.top_up(10)
        expect{ subject.touch_out(exit_station) }.to change{subject.balance }.by -Oystercard::MINIMUM_BALANCE
      end

      it 'stores exit station' do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject.exit_station).to eq exit_station
      end

      let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

      it 'stores a journey' do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject.journeys).to include journey
      end
    end
  end
end
