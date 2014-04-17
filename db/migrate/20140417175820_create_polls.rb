class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, presence: true, null: false
      t.integer :author_id, presence: true, null: false

      t.timestamps
    end
  end
end
