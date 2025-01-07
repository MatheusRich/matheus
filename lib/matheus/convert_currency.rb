require "net/http"
require "json"
require "date"

module Matheus
  # Usage:
  #    $ convert-currency 100 usd eur
  #    $ convert-currency 100 usd eur 2024-03-06
  #    $ convert-currency usd eur  # defaults to 1
  class ConvertCurrency < Command
    def call(args)
      amount, source, target, date = parse_args(args)

      api_url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@#{date}/v1/currencies/#{source}.min.json"
      data = JSON.parse(Net::HTTP.get(URI(api_url)))
      rate = data.dig(source.downcase, target.downcase)

      if rate
        converted = amount * rate
        puts "#{amount} #{source.upcase} = #{ActiveSupport::NumberHelper.number_to_currency(converted, unit: "")} #{target.upcase}"
      else
        Failure("Conversion rate from #{source.upcase} to #{target.upcase} not found")
      end
    rescue => e
      Failure(e.message)
    end

    private

    def parse_args(args)
      first_arg = args.fetch(0) { raise "Missing amount or source currency" }

      if (amount = Float(first_arg) rescue nil) # standard:disable Style/RescueModifier
        source = args.fetch(1) { raise "Missing source currency" }
        target = args.fetch(2) { raise "Missing target currency" }
        date = args.fetch(3, Date.today)
      else
        amount = 1.0
        source = first_arg
        target = args.fetch(1) { raise "Missing target currency" }
        date = args.fetch(2, Date.today)
      end

      [amount, source, target, date]
    end
  end
end
