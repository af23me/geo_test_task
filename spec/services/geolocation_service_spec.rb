# frozen_string_literal: true

RSpec.describe GeolocationService do
  describe '#search_key' do
    subject(:perform_method) { described_class.search_key(incoming_value) }

    context 'when valid' do
      context 'when ipv4' do
        let(:incoming_value) { '134.201.250.255' }

        it 'return ip search key' do
          expect(perform_method).to eq(:ip)
        end
      end

      context 'when ipv6' do
        let(:incoming_value) { '2001:0db8:85a3:0000:0000:8a2e:0370:7334' }

        it 'return ip search key' do
          expect(perform_method).to eq(:ip)
        end
      end

      context 'when host' do
        let(:incoming_value) { 'test.com' }

        it 'return host search key' do
          expect(perform_method).to eq(:search_value)
        end
      end
    end

    context 'when invalid' do
      context 'when ipv4' do
        let(:incoming_value) { '134.201.250.455' }

        it_behaves_like 'should raise invalid input error'
      end

      context 'when ipv6' do
        let(:incoming_value) { '2001:0db8:85a3:0000:4' }

        it_behaves_like 'should raise invalid input error'
      end

      context 'when host' do
        let(:incoming_value) { 'http://test.com/' }

        it_behaves_like 'should raise invalid input error'
      end
    end
  end

  describe '#validate!' do
    subject(:perform_method) { described_class.validate!(incoming_value) }

    shared_examples 'should return true' do
      it do
        expect(perform_method).to be(true)
      end
    end

    context 'when valid' do
      context 'when ipv4' do
        let(:incoming_value) { '134.201.250.255' }

        it_behaves_like 'should return true'
      end

      context 'when ipv6' do
        let(:incoming_value) { '2001:0db8:85a3:0000:0000:8a2e:0370:7334' }

        it_behaves_like 'should return true'
      end

      context 'when host' do
        let(:incoming_value) { 'test.com' }

        it_behaves_like 'should return true'
      end
    end

    context 'when invalid' do
      context 'when ipv4' do
        let(:incoming_value) { '134.201.250.455' }

        it_behaves_like 'should raise invalid input error'
      end

      context 'when ipv6' do
        let(:incoming_value) { '2001:0db8:85a3:0000:4' }

        it_behaves_like 'should raise invalid input error'
      end

      context 'when host' do
        let(:incoming_value) { 'http://test.com/' }

        it_behaves_like 'should raise invalid input error'
      end
    end
  end

  describe '#search' do
    subject(:perform_method) { service.search(incoming_value) }

    let(:incoming_value) { '134.201.250.255' }

    context 'when provider defined' do
      let(:service) do
        klass = described_class
        klass.provider = :ipstack
        klass.new
      end

      let(:instance) { instance_double(GeolocationProviders::IpStackService) }

      before do
        allow(GeolocationProviders::IpStackService).to receive(:new).and_return(instance)
        allow(instance).to receive(:find_location!)
      end

      it 'runs proper provider' do
        perform_method
        expect(instance).to have_received(:find_location!).once
      end
    end
  end
end
