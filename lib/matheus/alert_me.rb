require 'net/http'
require 'json'
require 'date'

module Matheus
  class AlertMe < Command
    # Usage:
    #    $ alert-me "sleep 1 && echo 'Done!'"
    #    Runs the command and plays a sound based on its success or failure after it finishes.
    def call(*args)
      if system(args.join(" "))
        system("afplay /System/Library/Sounds/Glass.aiff")
      else
        system("afplay /System/Library/Sounds/Sosumi.aiff")
      end
    rescue => e
      Failure(e.message)
    end
  end
end