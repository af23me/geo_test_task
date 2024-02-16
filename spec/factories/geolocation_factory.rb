# frozen_string_literal: true

FactoryBot.define do
  factory :geolocation do
    ip { '134.201.250.155' }
    search_value { 'test-site.com' }
    hostname { 'server-test.com' }
    ip_type { :ipv4 }
    continent_code { 'NA' }
    continent_name { 'North America' }
    country_code { 'US' }
    country_name { 'United States' }
    region_code { 'CA' }
    region_name { 'California' }
    city { 'Los Angeles' }
    zip { '90013' }
    latitude { 34.0453 }
    longitude { -118.2413 }
  end
end
