# frozen_string_literal: true

require "date"

module Matheus
  # Usage:
  #    $ puts "Date.today"
  #    2024-08-26
  class Puts < Command
    def call(argv)
      puts eval(argv.join(" ")) # standard:disable Security/Eval
    rescue Exception => e # standard:disable Lint/RescueException
      Failure(e.message)
    end
  end
end
