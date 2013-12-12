class RemoveAvatarFileSizeFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :avatar_file_size
  end

  def down
    add_column :users, :avatar_file_size, :integer
  end
end
