# frozen_string_literal: true

module Api
  module V1
    class GeolocationForm < ::BaseForm
      attr_accessor :search_value

      # validate input
      validate do
        GeolocationService.validate!(search_value)
      end

      # Check if record with same as icoming data already present
      validate :validate_presence

      # get data from service provider and apply to model
      def _save
        model.assign_attributes(model_data)
        model.search_value = search_value
        return true if validate_model && model.save!

        false
      rescue GeolocationService::RemoteNotFound => e
        errors.add(:base, e.message)
        false
      end

      def model
        @model ||= Geolocation.find_or_initialize_by(ip: model_data[:ip])
      end

      private

      # check
      def validate_model
        return true if model.valid?

        Rails.logger.error(
          "GEOLOCATION_FORM: failed to save model #{model.errors.full_messages.to_sentence} for #{search_value}"
        )
        raise ::BaseForm::RecordInvalid, I18n.t('errors.internal_error')
      end

      # service returns data suitable for apply to model
      def model_data
        @model_data ||= geolocation_service.search(search_value)
      end

      def validate_presence
        return if Geolocation.find_by(GeolocationService.search_key(search_value) => search_value).blank?

        raise ::Api::DuplicatedRecordError, I18n.t('errors.duplicated_record')
      end

      # Service allow to configure Geolocation Provider
      def geolocation_service
        @geolocation_service ||= GeolocationService.new(
          provider: GeolocationProviders::IpStackService
        )
      end
    end
  end
end
