class CreateSalesRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_records do |t|
      t.integer :course_id
      t.integer :price
      t.integer :daily_sales
      t.integer :revenue
      t.string :created_date

      t.timestamps
    end
  end
end
