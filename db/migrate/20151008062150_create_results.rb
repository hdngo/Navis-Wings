class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :ig_username
      t.integer :tag_time
      t.string :content_type
      t.string :ig_link
      t.string :image_url
      t.string :video_url
      t.text :description
      t.references :search, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
