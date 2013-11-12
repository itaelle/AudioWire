class ChangeDataTypeForTrackTime < ActiveRecord::Migration
  def up
  	change_table :tracks do |t|
      t.change :time, :integer
    end
  end

  def down
  	change_table :tracks do |t|
      t.change :time, :date
    end
  end
end
