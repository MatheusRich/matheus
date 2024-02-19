# frozen_string_literal: true

require "date"
require "active_support"
require "active_support/core_ext"

module Matheus
  class Puts < Command
    def call(argv)
      puts eval(argv.join(" ")) # standard:disable Security/Eval
    rescue Exception => e # standard:disable Lint/RescueException
      Failure(e.message)
    end
  end
end
