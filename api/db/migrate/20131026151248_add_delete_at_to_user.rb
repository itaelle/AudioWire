class AddDeleteAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :delete_at, :datetime
  end
end
