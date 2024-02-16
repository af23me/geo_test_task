# frozen_string_literal: true

module WebMockHelper
  def stub_geolocation_service(provider, method, path)
    base_url = case provider.to_sym
               when :ipstack
                 ENV.fetch('IPSTACK_URL')
               else
                 raise 'Invalid provider'
               end

    stub_request(method, /#{base_url}#{path}/)
  end

  def stub_geolocation_response(provider, file_name, status = 200)
    body = File.read("spec/fixtures/#{provider}/#{file_name}.txt")
    stub_response(body, status)
  end

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
