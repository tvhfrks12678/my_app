class RenameCotentColumnToMicroposts < ActiveRecord::Migration[6.1]
  def change
    rename_column :microposts, :cotent, :content
  end
end
