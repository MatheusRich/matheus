# frozen_string_literal: true

module Matheus
  module Result
    Success = Data.define(:value) do
      def success? = true

      def failure? = false

      def on_success = yield(value)

      def on_failure = self

      def error = nil

      def inspect = "Success(#{value.inspect})"
    end

    Failure = Data.define(:error) do
      def success? = false

      def failure? = true

      def on_success = self

      def on_failure = yield(error)

      def value = raise "Can't call #value on a #{self.class} object. Object is #{inspect}"

      def inspect = "Failure(#{error.inspect})"
    end

    module Methods
      def Success(value) = Result::Success.new(value)

      def Failure(error) = Result::Failure.new(error)
    end

    def self.from(value)
      if value.is_a?(Success) || value.is_a?(Failure)
        value
      else
        Success.new(value)
      end
    end
  end
end
