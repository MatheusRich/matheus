# frozen_string_literal: true

require "dotenv"
require "active_support"
require "active_support/core_ext"
require "zeitwerk"

Dotenv.load("~/.env")
Zeitwerk::Loader.for_gem.setup

module Matheus
  QUESTION_HISTORY_FILE = File.expand_path("~/.qa_history.json")
end
