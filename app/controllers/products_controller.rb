class ProductsController < ApplicationController
    def index
    search_term = params[:search]
    sort_attribute = params[:sort]
    sort_order = params[:sort_order]

    @products = Product.all

    if search_term
      @products = @products.where(
                                  "title iLike ?",
                                  "%#{search_term}%", 
                                  )
    end

    if sort_attribute && sort_order
      @products = @products.order(sort_attribute => sort_order)
    elsif sort_attribute
      @products = @products.order(sort_attribute)   
    end
  render "index.json.jbuilder"
end

  def show
    @product = Product.find(params[:id])
    render "show.json.jbuilder"
  end

  def create
    @product = Product.new(
                          name: params[:name],
                          price: params[:price],
                          image_url: params[:image_url],
                          description: params[:description]
                          )
   if @product.save
    render 'show.json.jbuilder'
  else
    render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
  end
end

  def update
    @product = Product.find(params[:id])

    @product.name = params[:name] || @product.name
    @product.price = params[:price] || @product.price
    @product.image_url = params[:image_url] || @product.image_url
    @product.description = params[:description] || @product.description

  if @product.save
    render "show.json.jbuilder"
  else 
    render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
  end
end    

  def destroy
    @product = product.find(params[:id])
    @product.destroy
    render json: {message: "Destroyed"}
  end

end
