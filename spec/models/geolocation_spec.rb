# frozen_string_literal: true

RSpec.describe Geolocation do
  describe 'validations' do
    subject(:geolocation) { create(:geolocation) }

    it 'is valid with valid attributes' do
      expect(geolocation).to be_valid
    end

    it 'is not valid without a ip_type' do
      geolocation.ip_type = nil
      expect(geolocation).not_to be_valid
    end
  end
end
