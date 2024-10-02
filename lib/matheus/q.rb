require "openai"
require "tty-markdown"
require "json"

module Matheus
  # Usage:
  #    $ q "What is the capital of France?"
  #    The capital of France is Paris.
  class Q < Command
    BASE_PROMPT = "Answer this question in a short and concise way. You can use markdown in the response: "

    def call(question)
      question = question.join(" ")
      answer = ask_llm(question)
      print_markdown(answer)
      save_qa(question, answer)
    rescue => e
      Failure(e.message)
    end

    private

    def ask_llm(question)
      raise "Question can't be blank." if question.blank?

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{role: "user", content: "#{BASE_PROMPT}#{question}"}]
        }
      )

      raise response["error"]["message"] if response.has_key?("error")

      response.dig("choices", 0, "message", "content")
    rescue Faraday::ClientError => error
      raise error.response_body.dig("error", "message") || error
    end

    def print_markdown(text)
      puts TTY::Markdown.parse(text)
    end

    def client
      OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
    end

    def save_qa(question, answer)
      history = load_history
      history << { question:, answer:, timestamp: Time.now.to_s }
      File.write(QUESTION_HISTORY_FILE, JSON.pretty_generate(history))
    end

    def load_history
      File.exist?(QUESTION_HISTORY_FILE) ? JSON.parse(File.read(QUESTION_HISTORY_FILE)) : []
    end
  end
end
