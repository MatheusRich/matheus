require "spec_helper"
require "webmock/rspec"

RSpec.describe Matheus::ConvertCurrency do
  describe "#call" do
    context "with amount, source and target currencies" do
      it "converts the amount using current date" do
        command = described_class.new
        today = Date.new(2024, 3, 7)
        allow(Date).to receive(:today).and_return(today)
        stub_currency_api("2024-03-07", "usd", { "eur" => 0.92 })

        expect { command.call(["100", "usd", "eur"]) }
          .to output("100.00 USD = 92.00 EUR\n").to_stdout
      end

      it "converts the amount using specific date" do
        command = described_class.new
        stub_currency_api("2024-03-01", "usd", { "eur" => 0.90 })

        expect { command.call(["100", "usd", "eur", "2024-03-01"]) }
          .to output("100.00 USD = 90.00 EUR\n").to_stdout
      end
    end

    context "without amount" do
      it "converts one unit of currency" do
        command = described_class.new
        today = Date.new(2024, 3, 7)
        allow(Date).to receive(:today).and_return(today)
        stub_currency_api("2024-03-07", "usd", { "eur" => 0.92 })

        expect { command.call(["usd", "eur"]) }
          .to output("1.00 USD = 0.92 EUR\n").to_stdout
      end
    end

    context "with invalid inputs" do
      it "handles missing amount or source" do
        command = described_class.new
        result = command.call([])

        expect(result.error).to eq("Missing amount or source currency")
      end

      it "handles missing source currency when amount provided" do
        command = described_class.new
        result = command.call(["100"])

        expect(result.error).to eq("Missing source currency")
      end

      it "handles missing target currency when amount provided" do
        command = described_class.new
        result = command.call(["100", "usd"])

        expect(result.error).to eq("Missing target currency")
      end

      it "handles missing target currency without amount" do
        command = described_class.new
        result = command.call(["usd"])

        expect(result.error).to eq("Missing target currency")
      end
    end

    context "with API errors" do
      it "handles invalid conversion rate" do
        command = described_class.new
        today = Date.new(2024, 3, 7)
        allow(Date).to receive(:today).and_return(today)
        stub_currency_api("2024-03-07", "usd", { "eur" => nil })

        result = command.call(["100", "usd", "eur"])
        expect(result.error).to eq("Conversion rate from USD to EUR not found")
      end

      it "handles unknown API error" do
        command = described_class.new
        stub_request(:get, /cdn.jsdelivr.net/).to_return(status: 500)

        result = command.call(["100", "usd", "eur"])

        expect(result.error).not_to be nil
      end
    end

    private

    def stub_currency_api(date, currency, rates)
      stub_request(:get, "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@#{date}/v1/currencies/#{currency}.min.json")
        .to_return(
          status: 200,
          body: { currency => rates }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end
  end
end
