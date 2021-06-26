class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :imgae_id, :string, null: true
    change_column :users, :self_introduction, :text, null: true
    rename_column :users, :imgae_id, :image_id
  end

  def down
    change_column :users, :imgae_id, :string, null: false
    change_column :users, :self_introduction, :text, null: false
    rename_column :users, :imgae_id
  end
end
