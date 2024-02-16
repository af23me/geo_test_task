# frozen_string_literal: true

# Abstract model to itteract with models or abstract data
class BaseForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  RecordInvalid = Class.new(StandardError)

  define_model_callbacks :save
  define_model_callbacks :validation, only: [:before]

  def initialize(params = {})
    assign_params(params)
  end

  def assign_params(params)
    params.each do |field, value|
      public_send("#{field}=", value)
    end
  end

  def _save
    false
  end

  def valid?(*args)
    run_callbacks :validation do
      super(*args)
    end
  end

  def save
    if valid?
      run_callbacks :save do
        _save
      end
    else
      false
    end
  end
end
