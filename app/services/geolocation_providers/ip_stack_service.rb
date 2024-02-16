# frozen_string_literal: true

module GeolocationProviders
  class IpStackService < ::BaseService
    include HTTParty
    base_uri ENV.fetch('IPSTACK_URL')

    REQUIRED_VALUES = %w[
      ip
      type
      continent_code
      continent_name
      country_code
      country_name
      region_code
      region_name
      city
      zip
      latitude
      longitude
    ].freeze

    attr_accessor :search_value
    attr_reader :remote_result

    def find_location!
      @remote_result = JSON.parse(fetch_data.body)
      Rails.logger.debug { "IpStack response: [#{fetch_data.code}] #{remote_result}" }

      validate_remote_result!

      build_result
    end

    private

    def fetch_data
      @fetch_data ||= self.class.get("/#{search_value}?access_key=#{ENV.fetch('IPSTACK_API_KEY')}&hostname=1", headers:)
    end

    def headers
      {
        'accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end

    def log_invalid_response
      Rails.logger.error("Invalid IpStack response: [#{fetch_data.code}] #{remote_result} for #{search_value}")
    end

    def validate_remote_result!
      if fetch_data.success?
        validate_remote_error!
        validate_remote_empty_values!
      else
        raise_provider_unavailable!
      end
    end

    def raise_provider_unavailable!
      log_invalid_response
      raise GeolocationService::ProviderUnavailable, I18n.t('errors.internal_error')
    end

    def validate_remote_empty_values!
      return unless REQUIRED_VALUES.any? { |i| remote_result[i].blank? }

      log_invalid_response
      raise GeolocationService::IncompleteResult, I18n.t('errors.incomplete_result')
    end

    def validate_remote_error!
      return if remote_result['error'].blank?

      if remote_result.dig('error', 'code') == 404
        raise GeolocationService::RemoteNotFound, I18n.t('errors.remote_resource_not_found')
      elsif remote_result.dig('error', 'code').in?([301, 106])
        raise GeolocationService::InvalidInput, I18n.t('errors.invalid_input')
      else
        raise_provider_unavailable!
      end
    end

    # build result which represents common interface of GeolocationService for mathing with Geolocation model
    def build_result
      {
        ip: remote_result['ip'],
        hostname: remote_result['hostname'],
        ip_type: remote_result['type'],
        continent_code: remote_result['continent_code'],
        continent_name: remote_result['continent_name'],
        country_code: remote_result['country_code'],
        country_name: remote_result['country_name'],
        region_code: remote_result['region_code'],
        region_name: remote_result['region_name'],
        city: remote_result['city'],
        zip: remote_result['zip'],
        latitude: remote_result['latitude'],
        longitude: remote_result['longitude']
      }
    end
  end
end
