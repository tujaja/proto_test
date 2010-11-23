class StoreController < ApplicationController
  before_filter :prepare_cart

  def index
  end

  def info
  end

  def about
  end

  def term
  end

  def help
  end

  def company
  end

  def privacy
  end

  private

  # Cartリソースは自動的にsessionに生成される
  # 明示的にPOST /cart する必要はない

    def prepare_cart
      p '[prepare cart]'
      if session[:cart]
        @cart = session[:cart]
      else
        @cart = Cart.new
        session[:cart] = @cart
      end
    end

end
