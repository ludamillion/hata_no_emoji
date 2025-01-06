# frozen_string_literal: true

require_relative "hata_no_emoji/version"
require_relative "hata_no_emoji/country_codes"

# Top level class presenting the gem API
class HataNoEmoji
  # Error Indicating that the code passed is formatted correctly but does not correspond to
  # a known ISO 3166 alpha-2 country code
  class InvalidAlphaCode < StandardError; end

  ALPHA_2_REGEXP = /^[A-Za-z]{2}$/
  CODEPOINT_OFFSET = 127_397

  class << self
    # Given an ISO 3166 alpha-2 country code return the that country's flag as a unicode emoji
    #
    # @param input [String, Symbol] the ISO 3166 alpha-2 country code
    # @return [String] the country flag emoji corresponding to that country code
    def flag_for(input)
      locale = input.to_s

      unless ALPHA_2_REGEXP.match(locale)
        raise(ArgumentError, "Expected a two character string or symbol. Received #{input}")
      end

      generate_emoji_for(locale)
    end

    private

    def validate_locale(locale)
      msg = "#{locale} is not a valid ISO 3166 alpha-2 country code"

      raise(HataNoEmoji::InvalidAlphaCode, msg) unless HataNoEmoji::COUNTRY_CODES.include? locale
    end

    def generate_emoji_for(locale)
      code = locale.upcase
      validate_locale(code)

      code.codepoints.map { |codepoint| codepoint + CODEPOINT_OFFSET }.pack("U*")
    end
  end
end
