# frozen_string_literal: true

module Matheus
  module StringFormat
    def error(message)
      bold(red("Error: ") + message)
    end

    def red(text)
      "\e[31m#{text}\e[0m"
    end

    def bold(text)
      "\e[1m#{text}\e[22m"
    end
  end
end
