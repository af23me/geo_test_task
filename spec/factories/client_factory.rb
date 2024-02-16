# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    api_key { 'test_api_key_string' }
    language { :en }
  end
end
