module Matheus
  class AlertMe < Command
    # Usage:
    #    $ alert-me sleep 1 && echo 'Done!'
    #    Runs the command and plays a sound based on its success or failure after it finishes.
    def call(*args)
      command = args.join(" ")
      if system(command)
        system("afplay /System/Library/Sounds/Glass.aiff")
      else
        system("afplay /System/Library/Sounds/Sosumi.aiff")
      end
    rescue => e
      Failure(e.message)
    end
  end
end
