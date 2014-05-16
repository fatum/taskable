require "taskable/version"
require 'active_support'
require 'active_record'
require 'state_machine'

module Taskable
  begin
    require "rails/observers/activerecord/active_record"
  rescue LoadError
  end

  if defined?(Rails)
    require 'taskable/railtie'
  else
    require_relative '../app/models/task'
  end

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
