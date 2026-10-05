require "spec_helper"

RSpec.describe Matheus::AwakeFor do
  describe "#call" do
    {
      "4h" => 14_400,
      "4H" => 14_400,
      "30min" => 1800,
      "30m" => 1800,
      "1h30m" => 5400,
      "1h 30m" => 5400,
      "1.5h" => 5400,
      "45s" => 45,
      "2 hours" => 7200
    }.each do |input, seconds|
      it "runs caffeinate for #{seconds} seconds when given #{input.inspect}" do
        command = described_class.new
        allow(command).to receive(:exec)

        expect { command.call(input.split) }.to output(/Staying awake until \d\d:\d\d/).to_stdout
        expect(command).to have_received(:exec).with("caffeinate", "-dims", "-t", seconds.to_s)
      end
    end

    it "prints when it stops" do
      command = described_class.new
      allow(command).to receive(:exec)
      allow(Time).to receive(:now).and_return(Time.new(2026, 10, 5, 14, 0))

      expect { command.call(["1h30m"]) }
        .to output("Staying awake until 15:30. Press Ctrl-C to stop.\n").to_stdout
    end

    it "shows the given input in the error" do
      command = described_class.new
      allow(command).to receive(:exec)

      result = command.call(["4h", "foo"])

      expect(result.error).to eq('invalid duration: "4h foo". Try something like 4h, 30min or 1h30m.')
    end

    ["", "4", "4x", "h", "0m", "4h foo"].each do |input|
      it "fails when given #{input.inspect}" do
        command = described_class.new
        allow(command).to receive(:exec)

        result = command.call(input.split)

        expect(result.error).to start_with("invalid duration")
        expect(command).not_to have_received(:exec)
      end
    end
  end
end
