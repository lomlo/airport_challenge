require 'airport'

describe Airport do
  subject(:airport) { described_class.new }
  let(:plane) { double :plane }
  let(:plane_alt) { double :plane_alt }
  let(:weather) { double :weather }

    describe '#dock' do
      it 'instructs an airport to dock a plane' do
        expect(airport).to receive(:dock)
        airport.dock(plane, weather)
      end
      it 'should add a plane to the airport' do
        allow(weather).to receive(:stormy?).and_return(false)
        airport.dock(plane, weather)
        expect(airport.planes).to include plane
      end
      it 'should ask the airport to check the weather' do
        expect(airport).to respond_to(:check_weather).with(1).arguments
      end
    end

    describe '#release' do
      it 'instructs the airport to release a plane' do
        expect(airport).to receive(:release)
        airport.release(plane)
      end
      it "should remove the plane the aiport" do
        allow(weather).to receive(:stormy?).and_return(false)
        airport.dock(plane, weather)
        airport.release(plane, weather)
        expect(airport.planes).to_not include plane
      end
      it "instructs the airport to check the weather" do
        allow(weather).to receive(:stormy?).and_return(false)
        expect(airport).to receive(:check_weather)
        airport.release(plane, weather)
      end
    end

    describe '#check_for_landed(plane)' do
      before do
        allow(weather).to receive(:stormy?).and_return(false)
      end
      it 'should confirm true if a plane has landed' do
        airport.dock(plane, weather)
        expect(airport.check_for_landed(plane)).to eq true
      end
      it 'should confirm false if a plane is not at airport' do
        expect(airport.check_for_landed(plane)).to eq false
      end
      it 'confirms if a specific plane is at the airport' do
        airport.dock(plane, weather)
        airport.dock(plane_alt, weather)
        expect(airport.check_for_landed(plane)).to eq true
        expect(airport.check_for_landed(plane_alt)).to eq true
        airport.release(plane_alt, weather)
        expect(airport.check_for_landed(plane)).to eq true
        expect(airport.check_for_landed(plane_alt)).to eq false
      end
    end

    describe '#check weather' do
      it { is_expected.to respond_to(:check_weather)}
      it 'raises an error if the weather is stormy' do
        allow(weather).to receive(:stormy?).and_return(true)
        expect{ airport.check_weather(weather) }.to raise_error('No planes can take off in a storm')
      end
      it "doesn't raise error if the weather is not stormy" do
        allow(weather).to receive(:stormy?).and_return(false)
        expect{ airport.check_weather(weather) }.not_to raise_error
      end
    end
end
