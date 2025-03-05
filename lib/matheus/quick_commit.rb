module Matheus
  class QuickCommit < Command
    # Usage:
    #    $ quick-commit
    def call(*)
      diff = `git diff --cached`
      return Failure("No changes to commit.") if diff.blank?

      Q.call(["Please write a good one-line commit message for the following diff. Return only plain-text. Diff:\n#{diff}"], skip_cache: true)
        .on_success { |msg| confirm("Accept commit message?", return_value: msg) }
        .on_success { |commit_message| system(%(git commit -m "#{commit_message}"), out: :close) }
    end

    private

    def confirm(message, return_value:)
      response = TTY::Prompt.new.yes?(message) do |q|
        q.default true
      end

      response ? Success(return_value) : Failure("Cancelled by user.")
    end
  end
end
