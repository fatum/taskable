class Task < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :taskable_id, null: false
      t.string :taskable_type, null: false

      t.string :status, null: false
      t.string :type, null: false
      t.text :payload
      t.integer :attempts, default: 0, null: false

      t.timestamps
    end
  end
end
