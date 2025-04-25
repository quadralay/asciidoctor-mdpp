#!/usr/bin/env ruby
# Session task logging for Codex CLI sessions
# Records tasks to .codex/SESSION_TASKS.md and provides lookup on restart.
require 'time'

module SessionTracker
  TASKS_FILE = File.expand_path('SESSION_TASKS.md', __dir__)

  # Append a new task description with UTC timestamp
  # description - String full task text
  def self.log_task(description)
    timestamp = Time.now.utc.iso8601
    File.open(TASKS_FILE, 'a') do |f|
      f.puts "#{timestamp}  #{description.strip}" 
    end
  rescue Errno::ENOENT
    Dir.mkdir(File.dirname(TASKS_FILE)) unless Dir.exist?(File.dirname(TASKS_FILE))
    retry
  end

  # Retrieve the last logged task entry, or nil if none
  # Returns the raw line from the tasks file
  def self.last_task
    return nil unless File.exist?(TASKS_FILE)
    File.readlines(TASKS_FILE, chomp: true).last
  end
end