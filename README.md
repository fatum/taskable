# Taskable

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'taskable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install taskable

## Usage

For processing important tasks and reliably persist task state and history we should use mature storage (MySql, PostgreSQL) instead using Redis or removing task after processing.

That task example could be started sequentialy by TaskRunner using `rake task:all` and safely handle errors and retry.

```ruby
class Task::MutateCampaign < Task
  def call
    # Business Logic
  end
end

```

If you want process tasks parallel using Message Queue, you should setup Taskable.populator, by default, populator add Sidekiq jobs

```ruby
Taskable.populate = proc { |task|
  Taskable::Sidekiq.perform_async task.id
}
```

It update status to :enqueued and produce each task to callable object (Taskable.populate).
Each task should be runned by TaskRunner (for error handling and state transitions).

```ruby
def perform(task_id)
  task = Task.find(task_id)
  TaskRunner.new(task).run { |t| t.call }
end
```

Rake tasks

```
rake task:all       # Sequentialy execute tasks.
rake task:timeout   # Find timeouted tasks and retry it.
rake task:clear     # Delete old and processed tasks.

rake task:schedule  # Add available tasks to populator and set status to :enqueued
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/taskable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
