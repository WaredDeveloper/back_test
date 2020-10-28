class ShopsController < ApplicationController

  def show
    supplies = Stocks.for_pub(params[:publisher_id])
    result = supplies.inject({}) do |map, stock|
      shop = stock.shop
      shop_info = map[shop] ||= { id: shop.id, name: shop.name, books_sold_count: 0, books_in_stock: []}
      shop_info[:books_sold_count] += stock.books_sold
      shop_info[:books_in_stock] << {id: stock.book_id, title: stock.book_title, copies_stock: stock.books_in_stock}
      map
    end.values.sort_by{ |data| -data[:books_sold_count]}
    render json: {shops: result}
  end

  def sell
    supply = Stocks.find_book(params[:book_id], params[:shop_id])
    if !supply
      render json: 'not_found'
    else
      count = params[:count].to_i
      if count == 0
        render json: 'wrong'
      elsif supply.books_in_stock < count
        render json: 'not_in_stock'
      else
        supply.books_sold += count
        supply.save
        render json: 'ok'
      end
    end
  end
end
