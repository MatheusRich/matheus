require "json"
require "tty-prompt"
require "tty-markdown"

module Matheus
  # Usage:
  #    $ qs
  #    Lists the questions asked and their answers.
  class Qs < Command
    def call(_)
      return puts "No questions found in history." if history.empty?

      answer = prompt.select("Question:", choices, per_page: 10)
      print_markdown(answer)
    rescue => e
      Failure(e.message)
    end

    private
    def choices
      history.map do |entry|
        {entry['question'] => entry['answer'] }
      end
    end


    def history
      @history ||= File.exist?(QUESTION_HISTORY_FILE) ? JSON.parse(File.read(QUESTION_HISTORY_FILE)) : []
    end

    def prompt
      @prompt ||= TTY::Prompt.new(interrupt: :exit)
    end

    def print_markdown(answer)
      puts
      puts TTY::Markdown.parse(answer)
    end
  end
end
