require "taskable/version"
require 'active_support'

module Taskable
  require 'taskable/railtie' if defined?(Rails)
  require 'taskable/task_runner'


  # Usage
  #   Taskable.populate = proc { |task|
  #     Taskable::Sidekiq.perform_async task.id
  #   }
  mattr_accessor :populate
  self.populate ||= proc {|task|
    if !defined?(SidekiqWorker)
      raise <<-ERROR
For default usage you should require sidekiq:
  require 'sidekiq'
  require 'taskable/sidekiq_worker'
      ERROR
    end

    SidekiqWorker.perform_async(task.id)
  }
end
