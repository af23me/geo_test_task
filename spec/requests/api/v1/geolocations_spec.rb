# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/geolocations' do
  let(:client) { create(:client) }
  let(:'X-Client-Api-Key') { client.api_key }

  path '/api/v1/geolocations' do
    let(:plan) { create(:plan) }

    post('create geolocation') do
      description 'Create geolocation'
      tags 'Geolocation'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'X-Client-Api-Key', in: :header, schema: {
        type: :string,
        example: '100'
      }, description: 'Client API key'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          geolocation: {
            type: :object,
            properties: {
              search_value: { type: :string }
            }
          }
        },
        required: %w[geolocation]
      }

      let(:params) do
        {
          geolocation: {
            search_value:
          }
        }
      end

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 geolocation: { '$ref' => '#/components/Geolocation' }
               },
               required: %w[geolocation]

        let(:search_value) { '134.201.250.155' }

        before do
          stub_geolocation_service(:ipstack, :get, "/#{search_value}")
            .to_return(stub_geolocation_response(:ipstack, 'success_response'))
        end

        run_test!
      end

      response(400, 'failure') do
        let(:search_value) { '134.201.250.555' }

        run_test!
      end
    end
  end

  path '/api/v1/geolocations/search' do
    let(:geolocation) { create(:geolocation) }

    get('show geolocation') do
      description 'Update geolocation'
      tags 'Geolocation'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'X-Client-Api-Key', in: :header, schema: {
        type: :string,
        example: '100'
      }, description: 'Client API key'
      parameter name: 'search_value', in: :query, type: :string, description: 'Host or IP'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 geolocation: { '$ref' => '#/components/Geolocation' }
               },
               required: %w[geolocation]

        let(:search_value) { geolocation.search_value }

        run_test!
      end

      response(400, 'failure') do
        let(:search_value) { '' }

        run_test!
      end

      response(404, 'not_found') do
        let(:search_value) { 'test.com' }

        run_test!
      end
    end
  end

  path '/api/v1/geolocations/destroy' do
    let(:geolocation) { create(:geolocation) }

    delete('destroy geolocation') do
      description 'Destroy'
      tags 'Geolocation'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'X-Client-Api-Key', in: :header, schema: {
        type: :string,
        example: '100'
      }, description: 'Client API key'
      parameter name: 'search_value', in: :query, type: :string, description: 'Host or IP'

      response(204, 'successful') do
        let(:search_value) { geolocation.search_value }

        run_test!
      end

      response(400, 'failure') do
        let(:search_value) { '' }

        run_test!
      end

      response(404, 'failure') do
        let(:search_value) { 'test.com' }

        run_test!
      end
    end
  end
end
