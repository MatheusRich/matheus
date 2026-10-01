require "ruby_llm"
require "tty-markdown"
require "tty-prompt"
require "json"

module Matheus
  # Usage:
  #    $ q "What is the capital of France?"
  #    The capital of France is Paris.
  class Q < Command
    BASE_PROMPT = "Answer this question in a short and concise way. You can use markdown in the response: "

    def call(*question, skip_cache: false)
      question = question.join(" ")
      existing_entry = search_question_in_history(question)

      if existing_entry && use_existing_answer?(skip_cache)
        answer = existing_entry["answer"]
      else
        answer = ask_llm(question)
        save_qa(question, answer)
      end

      answer.tap { |text| print_markdown(text) }
    rescue => e
      Failure(e.message)
    end

    private

    def ask_llm(question)
      raise "Question can't be blank." if question.blank?

      chat.ask("#{BASE_PROMPT}#{question}").content
    end

    def print_markdown(text)
      puts TTY::Markdown.parse(text)
    end

    def chat
      RubyLLM.configure { |config| config.openai_api_key = ENV.fetch("OPENAI_API_KEY") }
      RubyLLM.chat(model: "gpt-5.4-nano")
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

    def use_existing_answer?(skip_cache)
      return false if skip_cache

      prompt = TTY::Prompt.new
      prompt.yes?("An existing answer was found. Do you want to use it?") do |q|
        q.default true
      end
    end
  end
end
