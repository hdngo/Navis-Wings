class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :hashtag
      t.string :start_date
      t.string :end_date

      t.timestamps null: false
    end
  end
end
