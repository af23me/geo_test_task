# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      BAD_REQUEST_ERRORS_CLASS_LIST = [
        GeolocationService::InvalidInput,
        GeolocationService::ProviderUnavailable,
        GeolocationService::IncompleteResult,
        BaseForm::RecordInvalid
      ].freeze

      rescue_from(*BAD_REQUEST_ERRORS_CLASS_LIST, with: :handle_bad_request)
      rescue_from ::Api::ClientNotPassedError, with: :handle_unauthorized
      rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
      rescue_from ActionController::ParameterMissing do |_|
        render_error(I18n.t('errors.invalid_input'), { status: :bad_request })
      end
      rescue_from ::Api::DuplicatedRecordError do |e|
        render_error(e.message, { status: :conflict })
      end

      CLIENT_API_KEY_HEADER = 'X-Client-Api-Key'

      around_action :switch_locale
      before_action :current_client

      # Prepare locale for show errors in proper language
      def switch_locale(&)
        locale = defined?(@current_client) ? current_client.language : I18n.default_locale

        if I18n.available_locales.include?(locale.to_sym)
          I18n.with_locale(locale, &)
        else
          I18n.with_locale(I18n.default_locale, &)
        end
      end

      private

      def handle_bad_request(exception)
        Rails.logger.error(exception)
        render_error(exception.message, { status: :bad_request })
      end

      def handle_not_found
        render_error(I18n.t('errors.not_found'), { status: :not_found })
      end

      def handle_unauthorized
        render_error(I18n.t('errors.client_not_passed'), { status: :unauthorized })
      end

      def current_client
        return @current_client if defined?(@current_client)

        begin
          @current_client ||= Client.find_by!(api_key: request.headers[CLIENT_API_KEY_HEADER])
        rescue ActiveRecord::RecordNotFound
          raise(::Api::ClientNotPassedError)
        end
      end

      def render_response(resource, custom_options = {})
        serializer_options = { json: resource, include: [], status: :ok }
        serializer_options.merge!(custom_options) if custom_options.any?
        render(serializer_options)
      end

      def render_error(error_message, options = { status: :unprocessable_entity })
        render({ json: { error: error_message } }.merge(options))
      end
    end
  end
end
