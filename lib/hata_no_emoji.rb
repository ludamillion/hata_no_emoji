# frozen_string_literal: true

require_relative "hata_no_emoji/version"
require_relative "hata_no_emoji/country_codes"

module HataNoEmoji
  class InvalidAlphaCode < StandardError; end

  ALPHA_2_REGEXP = /^[A-Za-z]{2}$/
  CODEPOINT_OFFSET = 127397

  def self.flag_for(input)
    locale = input.to_s

    raise ArgumentError.new("Expected a two character string or symbol. Received #{input}") unless ALPHA_2_REGEXP.match(locale)

    generate_emoji_for(locale)
  end

  private

  def self.validate_locale(locale)
    msg = "#{locale} is not a valid ISO 3166 alpha-2 country code"

    raise HataNoEmoji::InvalidAlphaCode.new(msg) unless HataNoEmoji::COUNTRY_CODES.include? locale
  end

  def self.generate_emoji_for(locale)
    code = locale.upcase
    validate_locale(code)

    code.codepoints.map { |codepoint| codepoint + CODEPOINT_OFFSET }.pack('U*')
  end
end

