require "openai"
require "tty-markdown"

module Matheus
  # Usage:
  #    $ q "What is the capital of France?"
  #    The capital of France is Paris.
  class Q < Command
    BASE_PROMPT = "Answer this question in a short and concise way. You can use markdown in the response: "

    def call(question)
      ask_llm(question).then { print_markdown _1 }
    rescue => e
      Failure(e.message)
    end

    private

    def ask_llm(question)
      raise "Question can't be blank." if question.blank?

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini", # using gpt-4o model
          messages: [{role: "user", content: "#{BASE_PROMPT}#{question}"}]
        }
      )

      raise response["error"]["message"] if response.has_key?("error")

      response.dig("choices", 0, "message", "content")
    end

    def print_markdown(text)
      puts TTY::Markdown.parse(text)
    end

    def client
      OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
    end
  end
end
