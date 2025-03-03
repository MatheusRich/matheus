# frozen_string_literal: true

module Matheus
  class Command
    include Result::Methods
    extend StringFormat

    def self.call(...)
      new
        .call(...)
        .then { Result.from(_1) } # ensure it's a Result object
        .on_failure { |error_msg| abort error(error_msg) }
    end
  end
end
