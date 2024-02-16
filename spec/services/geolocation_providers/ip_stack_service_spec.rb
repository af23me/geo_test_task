# frozen_string_literal: true

RSpec.describe GeolocationProviders::IpStackService do
  describe '#find_location!' do
    subject(:perform_method) { service.find_location! }

    let(:service) { described_class.new(search_value: incoming_value) }
    let(:incoming_value) { '134.201.250.255' }

    context 'when valid' do
      let(:ipstack_response_body) do
        File.read('spec/fixtures/ipstack/success_response.txt')
      end
      let(:expected_response) do
        {
          ip: '134.201.250.155',
          hostname: '134.201.250.155',
          ip_type: 'ipv4',
          continent_code: 'NA',
          continent_name: 'North America',
          country_code: 'US',
          country_name: 'United States',
          region_code: 'CA',
          region_name: 'California',
          city: 'Los Angeles',
          zip: '90013',
          latitude: 34.0453,
          longitude: -118.2413
        }
      end

      before do
        stub_request(:get, %r{#{ENV.fetch('IPSTACK_URL', nil)}/#{incoming_value}})
          .to_return(stub_response(ipstack_response_body))
      end

      it 'returns modified data' do
        expect(perform_method).to eq(expected_response)
      end
    end

    context 'when invalid' do
      shared_examples 'should raise provider unavailable error' do
        it 'raises an error' do
          expect { perform_method }.to raise_error(GeolocationService::ProviderUnavailable)
        end
      end

      before do
        stub_request(:get, %r{#{ENV.fetch('IPSTACK_URL', nil)}/#{incoming_value}})
          .to_return(stub_ipstack_response)
      end

      let(:stub_ipstack_response) do
        stub_response(ipstack_response_body)
      end

      context 'when missing API keys' do
        let(:ipstack_response_body) do
          File.read('spec/fixtures/ipstack/missing_api_key_response.txt')
        end

        it_behaves_like 'should raise provider unavailable error'
      end

      context 'when record not found' do
        let(:ipstack_response_body) do
          File.read('spec/fixtures/ipstack/not_found_response.txt')
        end

        it 'raises an error' do
          expect { perform_method }.to raise_error(GeolocationService::RemoteNotFound)
        end
      end

      context 'when invalid input' do
        let(:ipstack_response_body) do
          File.read('spec/fixtures/ipstack/invalid_fields_response.txt')
        end

        it_behaves_like 'should raise invalid input error'
      end

      context 'when endpoint answer 500' do
        let(:stub_ipstack_response) do
          stub_response({}.to_json, 500)
        end

        it_behaves_like 'should raise provider unavailable error'
      end

      context 'when endpoint answer 404' do
        let(:stub_ipstack_response) do
          stub_response({}.to_json, 404)
        end

        it_behaves_like 'should raise provider unavailable error'
      end
    end
  end
end
