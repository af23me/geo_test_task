# frozen_string_literal: true

class Client < ApplicationRecord
  enum language: {
    en: 0,
    fr: 1
  }, _prefix: true

  validates :api_key, presence: true
end
