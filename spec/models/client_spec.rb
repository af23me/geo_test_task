# frozen_string_literal: true

RSpec.describe Client do
  describe 'validations' do
    subject(:client) { create(:client) }

    it 'is valid with valid attributes' do
      expect(client).to be_valid
    end

    it 'is not valid without a api_key' do
      client.api_key = nil
      expect(client).not_to be_valid
    end
  end
end
