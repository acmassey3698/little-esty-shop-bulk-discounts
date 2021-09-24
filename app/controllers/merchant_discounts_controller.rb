class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.create(discount_params)

    if discount.save
      redirect_to merchant_discounts_path(merchant)
    else
      redirect_to new_merchant_discount_path(merchant)
      flash[:notice] = "Discount not created. Invalid Input"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to merchant_discounts_path(merchant)
  end



  private
  def discount_params
    params.permit(:percentage, :threshold)
  end
end
