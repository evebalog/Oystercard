require 'oystercard'

describe Oystercard do

  it 'has a default balance of zero' do
    expect(subject.balance). to eq(0)
  end

end
