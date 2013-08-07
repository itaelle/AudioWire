class RemoveDestroyColumnToFriendships < ActiveRecord::Migration
  def up
    remove_column :friendships, :destroy
  end

  def down
    add_column :friendships, :destroy, :string
  end
end
