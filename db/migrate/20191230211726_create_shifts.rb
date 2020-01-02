class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.integer :user_id
      t.integer :store_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :taken_user_id, default: null, null: true
    end
  end
end
