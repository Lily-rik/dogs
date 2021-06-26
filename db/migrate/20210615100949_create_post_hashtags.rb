class CreatePostHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_hashtags do |t|
      t.integer :post_id, null: false
      t.integer :hashtag_id, null: false

      t.timestamps
    end

    add_index :post_hashtags, :post_id
    add_index :post_hashtags, :hashtag_id
  end
end
