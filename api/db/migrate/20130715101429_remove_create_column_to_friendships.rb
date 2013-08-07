class RemoveCreateColumnToFriendships < ActiveRecord::Migration
  def up
    remove_column :friendships, :create
  end

  def down
    add_column :friendships, :create, :string
  end
end
