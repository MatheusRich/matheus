# frozen_string_literal: true

require "date"

module Matheus
  class DateOfLast < Command
    def call(day_name)
      day_name = day_name.to_s

      target_wday = wday_for(day_name) or return Failure("invalid day name: #{day_name}")
      date = Date.today
      one_day_ago = (date - 1)
      one_week_ago = date - 7
      date = one_day_ago.downto(one_week_ago).find { _1.wday == target_wday }

      puts date
    end

    private

    def wday_for(day_name)
      Date::DAYNAMES.index(day_name.capitalize) || Date::ABBR_DAYNAMES.index(day_name.capitalize)
    end
  end
end
