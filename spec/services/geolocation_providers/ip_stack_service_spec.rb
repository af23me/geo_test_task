# frozen_string_literal: true

RSpec.describe GeolocationProviders::IpStackService do
  describe '#find_location!' do
    subject(:perform_method) { service.find_location! }

    let(:service) { described_class.new(search_value: incoming_value) }
    let(:incoming_value) { '134.201.250.255' }

    context 'when valid' do
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
        stub_geolocation_service(:ipstack, :get, "/#{incoming_value}")
          .to_return(stub_geolocation_response(:ipstack, 'success_response'))
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
        stub_geolocation_service(:ipstack, :get, "/#{incoming_value}")
          .to_return(stub_ipstack_response)
      end

      context 'when missing API keys' do
        let(:stub_ipstack_response) do
          stub_geolocation_response(:ipstack, 'missing_api_key_response')
        end

        it_behaves_like 'should raise provider unavailable error'
      end

      context 'when record not found' do
        let(:stub_ipstack_response) do
          stub_geolocation_response(:ipstack, 'not_found_response')
        end

        it 'raises an error' do
          expect { perform_method }.to raise_error(GeolocationService::RemoteNotFound)
        end
      end

      context 'when invalid input' do
        let(:stub_ipstack_response) do
          stub_geolocation_response(:ipstack, 'invalid_fields_response')
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
