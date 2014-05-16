class Task < ActiveRecord::Base
  ATTEMPTS = 3

  serialize :payload, Hash

  scope :available, -> { with_statuses(:pending, :failed).where("attempts < ?", ATTEMPTS) }
  scope :outdated, -> { where("updated_at < ?", 1.week.ago) }

  belongs_to :taskable, polymorphic: true

  state_machine :status, :initial => :pending do
    state :pending
    state :enqueued
    state :working
    state :successful
    state :failed

    event :start do
      transition [:pending, :enqueud, :failed] => :working
    end

    event :enqueud do
      transition :pending => :enqueud
    end

    event :crash do
      transition :working => :failed
    end

    event :succeed do
      transition :working => :successful
    end
  end

  def attempt!
    update_attribute(:attempts, attempts + 1)
    start
  end
end
