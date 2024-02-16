# frozen_string_literal: true

class BaseService
  def initialize(attrs = {})
    assign_params(attrs)
  end

  def assign_params(params = {})
    params.each do |k, v|
      public_send("#{k}=", v) if respond_to?("#{k}=")
    end
  end
end
