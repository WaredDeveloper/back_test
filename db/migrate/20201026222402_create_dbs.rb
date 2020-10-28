class CreateDbs < ActiveRecord::Migration[6.0]
  def change
    add_index :supplies, [:book_id, :shop_id], unique: true
  end
end
