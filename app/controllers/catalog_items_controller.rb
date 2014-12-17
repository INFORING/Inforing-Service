class CatalogItemsController < ApplicationController
  def new
		@item = CatalogItem.new
    @category_id = params[:category_id]
		respond_to do |format|
			format.js
		end
	end

	def create 
	 @item = CatalogItem.new(item_params) 
	 @items = CatalogCategory.find(item_params[:catalog_category_id]).catalog_items.paginate(page: params[:page], per_page: 10)
   if @item.save
      unless params[:images].blank?  
        params[:images].first(5).each do |image|
          @item.attached_images.create(image: image)
        end
      end  
   end
    respond_to do |format|               
      format.js
   	end 
	end

	def edit
		@item = CatalogItem.find(params[:id])
		respond_to do |format|
			format.js
		end
	end

	def update
		@item = CatalogItem.find(params[:id])
		@items = @item.catalog_category.catalog_items.paginate(page: params[:page], per_page: 10)
    @item.update_attributes(item_params)
    unless params[:images].blank?  
      params[:images].first(5).each do |image|
        @item.attached_images.create(image: image)
      end
    end  
    respond_to do |format|
			format.js
		end
	end

	def destroy
		@item = CatalogItem.find(params[:id])
		@items = @item.catalog_category.catalog_items.paginate(page: params[:page], per_page: 10)
		@item.destroy
		respond_to do |format|
			format.js
		end
	end

	def destroy_image
		@image = AttachedImage.find(params[:image_id])
		@item = @image.catalog_item
		@image.destroy
		respond_to do |format|
			format.js
		end
	end

	def show
    @item = CatalogItem.find(params[:id])
    @repairs = Repair.all
    @news = News.last(3)
	end

	def item_params
      params.require(:catalog_item).permit(:title, :description, :price, :catalog_category_id)
  end
end