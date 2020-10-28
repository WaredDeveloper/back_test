class Stock < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  def self.for_pub(pub_id)
    Stock
      .includes(:book)
      .where('books.publisher_id = ?', pub_id)
      .where('books_supplied - books_sold > 0')
      .references(:book)
  end

  def books_stock
    books_supplied - books_sold
end
