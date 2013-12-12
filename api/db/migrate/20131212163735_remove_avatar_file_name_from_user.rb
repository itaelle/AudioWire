class RemoveAvatarFileNameFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :avatar_file_name
  end

  def down
    add_column :users, :avatar_file_name, :string
  end
end
