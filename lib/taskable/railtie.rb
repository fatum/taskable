module Taskable
  class Engine < ::Rails::Engine
    rake_tasks do
      require 'taskable/tasks'
    end
  end
end