# frozen_string_literal: true

require "date"

module Matheus
  # Usage:
  #    $ date-of-last monday
  #    2022-01-24
  class DateOfLast < Command
    def call(args)
      day_name = args[0].to_s

      target_wday = wday_for(day_name) or return Failure("invalid day name: #{day_name.inspect}")
      date = Enumerator.produce(Date.today - 1, &:prev_day).find { _1.wday == target_wday }

      puts date
    end

    private

    def wday_for(day_name)
      Date::DAYNAMES.index(day_name.capitalize) || Date::ABBR_DAYNAMES.index(day_name.capitalize)
    end
  end
end
