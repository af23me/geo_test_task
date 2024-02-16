# frozen_string_literal: true

RSpec.describe Api::V1::GeolocationsController do
  let(:search_value) { '134.201.250.155' }
  let(:parsed_response) { response.parsed_body }

  shared_examples 'unauthorized access' do
    describe 'GET #show' do
      before { get :show, params: { search_value: } }

      it 'has http status unauthorized' do
        subject

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  shared_examples 'HTTP status no_content' do
    it 'has http status no content' do
      subject
      expect(response).to have_http_status(:no_content)
    end
  end

  shared_examples 'HTTP status not_found' do
    it 'has http status not_found' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end

  shared_examples 'HTTP status ok' do
    it 'has http status ok' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  shared_examples 'invalid search_value' do
    it 'has http status bad_request' do
      subject
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when client not included api key to headers' do
    before { create(:client) }

    include_examples 'unauthorized access'
  end

  context 'when client has no token in database' do
    before do
      request.headers['X-Client-Api-Key'] = 'any'
    end

    include_examples 'unauthorized access'
  end

  context 'when client is logged in' do
    before do
      request.headers['X-Client-Api-Key'] = client.api_key
    end

    let(:client) { create(:client) }

    describe 'POST #create' do
      subject(:perform_request) { post :create, params: { geolocation: geolocation_params } }

      let(:geolocation_params) do
        { search_value: }
      end

      context 'when valid search_value' do
        let(:expected_response) do
          item = Geolocation.last
          {
            'city' => item.city,
            'continent_code' => item.continent_code,
            'continent_name' => item.continent_name,
            'country_code' => item.country_code,
            'country_name' => item.country_name,
            'hostname' => item.hostname,
            'ip' => item.ip,
            'ip_type' => item.ip_type,
            'region_code' => item.region_code,
            'region_name' => item.region_name,
            'zip' => item.zip,
            'latitude' => item.latitude,
            'longitude' => item.longitude
          }
        end

        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'success_response'))
        end

        it_behaves_like 'HTTP status ok'

        it 'create geolocation record' do
          expect { perform_request }.to change(Geolocation, :count).from(0).to(1)
        end

        it 'respond with geolocation' do
          perform_request
          expect(parsed_response['geolocation']).to include(expected_response)
        end
      end

      context 'when record exist' do
        let(:geolocation) { create(:geolocation) }
        let(:search_value) { geolocation.search_value }

        before { geolocation }

        it 'has http status conflict' do
          perform_request

          expect(response).to have_http_status(:conflict)
        end

        it 'respond with error' do
          perform_request
          expect(parsed_response['error']).to eq(I18n.t('errors.duplicated_record', locale: client.language))
        end

        it 'does not create geolocation record' do
          expect { perform_request }.not_to change(Geolocation, :count)
        end
      end

      context 'when invalid search_value' do
        context 'when missing param' do
          let(:geolocation_params) { nil }

          it_behaves_like 'invalid search_value'
        end

        context 'when empty param' do
          let(:search_value) { '' }

          it_behaves_like 'invalid search_value'
        end

        context 'when invalid URL param' do
          let(:search_value) { 'https://test.com/test-url' }

          it_behaves_like 'invalid search_value'
        end

        context 'when invalid ipv4 param' do
          let(:search_value) { '134.201.250.455' }

          it_behaves_like 'invalid search_value'
        end

        context 'when invalid ipv6 param' do
          let(:search_value) { '2001:0db8:85a3:0000:0000:8a2e' }

          it_behaves_like 'invalid search_value'
        end
      end

      context 'when remote service not found' do
        let(:ipstack_response_body) do
          File.read('spec/fixtures/ipstack/not_found_response.txt')
        end

        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'not_found_response'))
        end

        it 'has http status unprocessable_entity' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'respond with error' do
          perform_request
          expect(parsed_response['error']).to eq(I18n.t('errors.remote_resource_not_found', locale: client.language))
        end
      end

      context 'when remote service raise invalid params' do
        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'invalid_fields_response'))
        end

        it 'has http status bad_request' do
          perform_request

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when remote service return partial response' do
        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'partial_response'))
        end

        it 'has http status bad_request' do
          perform_request

          expect(response).to have_http_status(:bad_request)
        end

        it 'respond with error' do
          perform_request
          expect(parsed_response['error']).to eq(I18n.t('errors.incomplete_result', locale: client.language))
        end
      end

      context 'when remote service raise another error' do
        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'missing_api_key_response'))
        end

        it 'has http status bad_request' do
          perform_request

          expect(response).to have_http_status(:bad_request)
        end

        it 'respond with error' do
          perform_request
          expect(parsed_response['error']).to eq(I18n.t('errors.internal_error', locale: client.language))
        end
      end
    end

    describe 'GET #show' do
      subject(:perform_request) { get :show, params: { search_value: } }

      let(:expected_response) do
        {
          'city' => geolocation.city,
          'continent_code' => geolocation.continent_code,
          'continent_name' => geolocation.continent_name,
          'country_code' => geolocation.country_code,
          'country_name' => geolocation.country_name,
          'hostname' => geolocation.hostname,
          'ip' => geolocation.ip,
          'ip_type' => geolocation.ip_type,
          'region_code' => geolocation.region_code,
          'region_name' => geolocation.region_name,
          'zip' => geolocation.zip,
          'latitude' => geolocation.latitude,
          'longitude' => geolocation.longitude
        }
      end

      context 'when geolocation exists by host' do
        let(:geolocation) { create(:geolocation) }
        let(:search_value) { geolocation.search_value }

        it_behaves_like 'HTTP status ok'

        it 'respond with geolocation' do
          perform_request
          expect(parsed_response['geolocation']).to include(expected_response)
        end
      end

      context 'when geolocation exists by ip' do
        let(:geolocation) { create(:geolocation) }
        let(:search_value) { geolocation.ip }

        it_behaves_like 'HTTP status ok'

        it 'respond with geolocation' do
          perform_request
          expect(parsed_response['geolocation']).to include(expected_response)
        end
      end

      context 'when geolocation does not exist' do
        let(:search_value) { 'host.com' }

        it_behaves_like 'HTTP status not_found'
      end

      context 'when empty param' do
        let(:search_value) { '' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid URL param' do
        let(:search_value) { 'https://test.com/test-url' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid ipv4 param' do
        let(:search_value) { '134.201.250.455' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid ipv6 param' do
        let(:search_value) { '2001:0db8:85a3:0000:0000:8a2e' }

        it_behaves_like 'invalid search_value'
      end
    end

    describe 'DELETE #delete' do
      subject(:perform_request) { delete :destroy, params: { search_value: } }

      context 'when geolocation exists by host' do
        let(:geolocation) { create(:geolocation) }
        let(:search_value) { geolocation.search_value }

        before do
          geolocation
        end

        it_behaves_like 'HTTP status no_content'

        it 'delete geolocation record' do
          expect { perform_request }.to change(Geolocation, :count).from(1).to(0)
        end
      end

      context 'when geolocation exists by ip' do
        let(:geolocation) { create(:geolocation) }
        let(:search_value) { geolocation.ip }

        before do
          geolocation
        end

        it_behaves_like 'HTTP status no_content'

        it 'delete geolocation record' do
          expect { perform_request }.to change(Geolocation, :count).from(1).to(0)
        end
      end

      context 'when geolocation does not exist' do
        let(:search_value) { 'host.com' }

        it_behaves_like 'HTTP status not_found'
      end

      context 'when empty param' do
        let(:search_value) { '' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid URL param' do
        let(:search_value) { 'https://test.com/test-url' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid ipv4 param' do
        let(:search_value) { '134.201.250.455' }

        it_behaves_like 'invalid search_value'
      end

      context 'when invalid ipv6 param' do
        let(:search_value) { '2001:0db8:85a3:0000:0000:8a2e' }

        it_behaves_like 'invalid search_value'
      end
    end
  end
end
