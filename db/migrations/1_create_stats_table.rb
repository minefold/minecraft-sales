class CreateStatsTable < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :registered
      t.integer :paid
      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
