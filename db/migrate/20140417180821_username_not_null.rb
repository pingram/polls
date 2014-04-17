class UsernameNotNull < ActiveRecord::Migration
  def change
    change_column :users, :user_name, :string, null: false
  end
end
