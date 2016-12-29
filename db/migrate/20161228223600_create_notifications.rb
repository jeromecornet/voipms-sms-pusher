class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :did
      t.text :token
      t.last_registered_at :datetime
      t.string :platform

      t.timestamps
      t.index [:did, :last_registered_at]
    end

  end
end
