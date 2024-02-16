# frozen_string_literal: true

module Api
  module V1
    class GeolocationsController < BaseController
      before_action :validate_resource, only: %i[show destroy]

      def show
        render_response(resource, root: 'geolocation')
      end

      def create
        form = GeolocationForm.new(create_params)

        if form.save
          render_response(form.model, root: 'geolocation')
        else
          render_error(form.errors.full_messages.to_sentence)
        end
      end

      def destroy
        resource.delete

        head :no_content
      end

      private

      def resource
        @resource ||= Geolocation.find_by!(search_key => params[:search_value])
      end

      def validate_resource
        handle_not_found if resource.nil?
      end

      def search_key
        GeolocationService.search_key(params[:search_value])
      end

      def create_params
        params
          .require(:geolocation)
          .permit(:search_value)
      end
    end
  end
end
