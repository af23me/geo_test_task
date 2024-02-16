# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'GeoTestTask API',
        version: 'v1'
      },
      paths: {},
      components: {
        Geolocation: {
          type: :object,
          properties: {
            ip: { type: :string },
            hostname: { type: :string },
            ip_type: { type: :string },
            continent_code: { type: :string },
            continent_name: { type: :string },
            country_code: { type: :string },
            country_name: { type: :string },
            region_code: { type: :string },
            region_name: { type: :string },
            city: { type: :string },
            zip: { type: :string },
            latitude: { type: :number },
            longitude: { type: :number }
          }
        }
      },
      servers: [
        {
          url: ENV.fetch('APP_URL')
        }
      ]
    }
  }
  config.openapi_format = :yaml
end
