class Cart

  class CartItem
    attr_accessor :content_id, :quantity

    def initialize content_id, quantity=1
      @content_id = content_id
      @quantity = quantity
    end

    def content
      Content.find_by_id @content_id
    end

    def unit_price
      content = Content.find_by_id @content_id
      content.price * @quantity
    end

  end



  def initialize
    @cart_items = []
  end

  def cart_items
    @cart_items
  end

  def length
    @cart_items.length
  end

  def is_empty
    @cart_items.length == 0
  end

  def total_price
    total = 0
    @cart_items.each do |item|
      total = total + item.unit_price
    end
    return total
  end

  def add_cart_item content_id
    p "M===Cart#add_cart_item #{content_id}"
    content_id = content_id.to_i if content_id.class == String
    item = find_item_by_content_id content_id

    if item
      return
    else
      @cart_items.push Cart::CartItem.new(content_id)
    end
  end

  def delete_cart_item content_id
    p "M===Cart#delete_cart_item #{content_id}"
    content_id = content_id.to_i if content_id.class == String
    @cart_items.delete( find_item_by_content_id(content_id) )
  end

  def find_item_by_content_id id
    @cart_items.each do |item|
      if item.content_id == id
        return item
      end
    end
    return nil
  end

end
