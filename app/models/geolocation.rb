# frozen_string_literal: true

class Geolocation < ApplicationRecord
  enum ip_type: {
    ipv4: 0,
    ipv6: 1
  }, _prefix: true

  validates :ip,
            :ip_type,
            :continent_code,
            :continent_name,
            :country_code,
            :country_name,
            :region_code,
            :region_name,
            :city,
            :zip,
            :latitude,
            :longitude,
            presence: true
end
