# frozen_string_literal: true

module WebMockHelper
  def stub_response(body, status = 200)
    {
      status:,
      body:,
      headers: {
        'Content-Type' => 'application/json'
      }
    }
  end
end
