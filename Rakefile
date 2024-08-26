# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "active_support"
require "active_support/core_ext"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Generate executables for command classes"
task :generate_executables do
  require "fileutils"

  # Load the gem's library files
  $LOAD_PATH.unshift("#{__dir__}/lib")

  require "matheus"

  Zeitwerk::Loader.eager_load_all

  exe_dir = File.expand_path("#{__dir__}/exe")

  Matheus::Command.descendants.each do |command_class|
    script_path = File.join(exe_dir, command_class.name.demodulize.underscore.dasherize)
    next if File.exist?(script_path)

    script_content = <<~SCRIPT
      #!/usr/bin/env ruby

      $LOAD_PATH.unshift("\#{__dir__}/../lib")

      require "matheus"

      Matheus::#{command_class.name.demodulize}.call ARGV
    SCRIPT

    File.write(script_path, script_content)
    FileUtils.chmod("+x", script_path)

    puts "Generated executable: #{script_path}"
  end
end

# Ensure the generate_executables task runs before the build task
task build: :generate_executables
