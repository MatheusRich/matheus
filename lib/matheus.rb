# frozen_string_literal: true

require "dotenv"
require "active_support"
require "active_support/core_ext"
require "zeitwerk"

Dotenv.load("~/.env")
Zeitwerk::Loader.for_gem.setup

module Matheus
end
