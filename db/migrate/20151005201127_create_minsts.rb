class CreateMinsts < ActiveRecord::Migration
  def change
    create_table :minsts do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
    add_index :minsts, :code
    add_index :minsts, :name
  end
end
