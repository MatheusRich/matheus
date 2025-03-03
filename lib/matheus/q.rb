require "openai"
require "tty-markdown"
require "tty-prompt"
require "json"

module Matheus
  # Usage:
  #    $ q "What is the capital of France?"
  #    The capital of France is Paris.
  class Q < Command
    BASE_PROMPT = "Answer this question in a short and concise way. You can use markdown in the response: "

    def call(question)
      question = question.join(" ")
      existing_entry = search_question_in_history(question)

      if existing_entry && use_existing_answer?
        answer = existing_entry["answer"]
      else
        answer = ask_llm(question)
        save_qa(question, answer)
      end

      answer.tap { |it| print_markdown(it) }
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
      history << {question:, answer:, timestamp: Time.now.to_s}
      File.write(QUESTION_HISTORY_FILE, JSON.pretty_generate(history))
    end

    def load_history
      File.exist?(QUESTION_HISTORY_FILE) ? JSON.parse(File.read(QUESTION_HISTORY_FILE)) : []
    end

    def search_question_in_history(question)
      load_history.reverse.find { |entry| entry["question"].downcase.strip == question.downcase.strip }
    end

    def use_existing_answer?
      prompt = TTY::Prompt.new
      prompt.yes?("An existing answer was found. Do you want to use it?") do |q|
        q.default true
      end
    end
  end
end
