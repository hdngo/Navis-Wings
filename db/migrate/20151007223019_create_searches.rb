class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :hashtag
      t.integer :start_date
      t.integer :end_date

      t.timestamps null: false
    end
  end
end
