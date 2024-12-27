require 'net/http'
require 'json'
require 'date'

module Matheus
  # Usage:
  #    $ convert-currency usd eur
  #    $ convert-currency usd eur 2024-03-06
  class ConvertCurrency < Command
    def call(args)
      source = args.fetch(0) { raise "Missing source currency" }
      target = args.fetch(1) { raise "Missing target currency" }
      date = args.fetch(2, Date.today)

      api_url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/#{source}.min.json"

      data = JSON.parse(Net::HTTP.get(URI(api_url)))
      rate = data.dig(source.downcase, target.downcase)

      if rate
        puts "1 #{source.upcase} = #{ActiveSupport::NumberHelper.number_to_currency(rate, unit: "")} #{target.upcase}"
      else
        Failure("Conversion rate from #{source.upcase} to #{target.upcase} not found")
      end
    rescue => e
      Failure(e.message)
    end
  end
end
