class Taskable::TaskRunner
  attr_reader :task

  def initialize(task)
    @task = task
  end

  # Usage:
  #   TaskRunner.new(task: task).run { |t| t.call }
  def run(&block)
    task.attempt!

    yield task
    task.succeed!
  rescue StandardError => e
    task.crash!
    raise e
  end
end
