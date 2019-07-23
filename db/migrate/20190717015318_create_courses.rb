class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :key_link
      t.string :title
      t.integer :total_count
      t.string :created_date

      t.timestamps
    end
  end
end
