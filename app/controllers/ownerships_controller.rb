class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    unless @item.persisted?
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first))
      @item.save
    end
 
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を Want しました。'
    end
    
    if params[:type] == 'Have'
      current_user.have(@item)
      flash[:success] = '商品を Have しました。'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    end
    
    if params[:type] == 'Have'
      current_user.unhave(@item) 
      flash[:success] = '商品の have を解除しました。'
    end

    redirect_back(fallback_location: root_path)
  end
end
