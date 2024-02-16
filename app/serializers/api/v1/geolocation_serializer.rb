# frozen_string_literal: true

module Api
  module V1
    class GeolocationSerializer < ActiveModel::Serializer
      attributes :hostname,
                 :ip,
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
                 :longitude

      def latitude
        object.latitude.to_f
      end

      def longitude
        object.longitude.to_f
      end
    end
  end
end
