require 'sidekiq'

module Taskable
  class SidekiqWorker
    include Sidekiq::Worker

    sidekiq_options queue_name: :tasks, unique: true

    def perform(task_id)
      task = Task.find(task_id)
      TaskRunner.new(task).run { |t| t.call }
    end
  end
end