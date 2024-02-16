# frozen_string_literal: true

class GeolocationService
  RemoteNotFound = Class.new(StandardError)
  InvalidInput = Class.new(StandardError)
  ProviderUnavailable = Class.new(StandardError)
  IncompleteResult = Class.new(StandardError)

  class_attribute :provider

  class << self
    def search_key(input)
      if ipv4?(input) || ipv6?(input)
        :ip
      elsif url?(input)
        :search_value
      else
        raise InvalidInput, I18n.t('errors.invalid_input')
      end
    end

    def validate!(input)
      ipv4?(input) || ipv6?(input) || url?(input) || (raise InvalidInput, I18n.t('errors.invalid_input'))
    end

    private

    def ipv4?(input)
      !!(input =~ Resolv::IPv4::Regex)
    end

    def ipv6?(input)
      !!(input =~ Resolv::IPv6::Regex)
    end

    def url?(input)
      input.match(/\A[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,25}\z/).present?
    end
  end

  def search(input)
    provider = case self.class.provider&.to_sym
               when :ipstack
                 GeolocationProviders::IpStackService.new(search_value: input)
               else
                 raise 'Invalid provider'
               end

    provider.find_location!
  end
end
