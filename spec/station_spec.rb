require 'station'

describe Station do

  subject {Station.new("Holborn", 1)}

  it 'returns the name of the station' do
    expect(subject.name).to eq "Holborn"
  end

  it 'returns which zone the station is' do
    expect(subject.zone).to eq 1
  end

end
