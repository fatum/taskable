namespace :task do
  desc 'Run task populator'
  task :schedule => :environment do
    Task.available.find_each do |task|
      task.enqueued!

      Taskable.populate.call(task)
    end
  end

  desc 'Handle timeouted tasks'
  task :timeout => :environment do
    # Todo implement timeout handling
  end

  desc 'Process all available tasks'
  task :all => :environment do
    Task.available.find_each do |task|
      Taskable::TaskRunner.new(task).run { |t| t.call }
    end
  end

  desc 'Delete all old failed tasks'
  task :clear => :environment do
    Task.outdated.delete_all
  end
end