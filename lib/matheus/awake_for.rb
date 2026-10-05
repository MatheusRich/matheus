# frozen_string_literal: true

module Matheus
  # Usage:
  #    $ awake-for 4h
  #    $ awake-for 30min
  #    $ awake-for 1h30m
  #    Keeps the Mac awake for the given duration, using `caffeinate`.
  class AwakeFor < Command
    class Duration < Data.define(:seconds)
      UNITS = {
        "h" => 3600, "hr" => 3600, "hrs" => 3600, "hour" => 3600, "hours" => 3600,
        "m" => 60, "min" => 60, "mins" => 60, "minute" => 60, "minutes" => 60,
        "s" => 1, "sec" => 1, "secs" => 1, "second" => 1, "seconds" => 1
      }.freeze
      PART = /(\d+(?:\.\d+)?)\s*(#{Regexp.union(UNITS.keys.sort_by { -_1.size })})/
      FORMAT = /\A(?:#{PART})+\z/

      def self.parse(input)
        input = input.downcase.delete(" ")
        return unless input.match?(FORMAT)

        seconds = input.scan(PART).sum { |amount, unit| UNITS.fetch(unit) * amount.to_f }
        new(seconds.round) if seconds.positive?
      end

      def from_now = Time.now + seconds
    end

    def call(args)
      input = args.join(" ")
      duration = Duration.parse(input) or return Failure("invalid duration: #{input.inspect}. Try something like 4h, 30min or 1h30m.")

      puts "Staying awake until #{duration.from_now.strftime("%H:%M")}. Press Ctrl-C to stop."
      exec("caffeinate", "-dims", "-t", duration.seconds.to_s)
    end
  end
end
