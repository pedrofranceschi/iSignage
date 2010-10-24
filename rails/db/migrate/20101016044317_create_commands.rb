class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.integer :session_id
      t.string :name
      t.string :value
      t.boolean :executed, {:default => false}
      t.timestamps
    end
  end

  def self.down
    drop_table :commands
  end
end
