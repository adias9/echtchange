class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def adminpanel
    @orders = Order.all
  end

  #def sendnotify
  #  @order = Order.find(params[:id])
  #  @buyer = User.find(@order.buyer_id)
  #  
  #  respond_to do |format|
  #    OrderSoldNotifier.send_bookready_email(@buyer, @order).deliver
  #    format.html { redirect_to adminpanel_url, notice: 'Email succesfully sent.' }
  #  end
  #end

  def delivered
    @order = Order.find(params[:id])
    Listing.update(@order.listing_id, delivered: true)

    @listing = Listing.find(@order.listing_id)
    @seller = User.find(@order.seller_id)

    Stripe.api_key = ENV["stripe_api_key"]

    transfer = Stripe::Transfer.create(
      :amount => (@listing.price * 97).floor,
      :currency => "usd",
      :recipient => @seller.recipient
      )
    flash[:notice] = "Transfer completed!"

    respond_to do |format|
      format.html { redirect_to adminpanel_url, notice: 'Listing marked delivered.' }
    end
  end

  def undeliver
    @order = Order.find(params[:id])
    Listing.update(@order.listing_id, delivered: false)

    respond_to do |format|
      format.html { redirect_to adminpanel_url, notice: 'Listing marked undelivered.' }
    end
  end

  def unsold
    @order = Order.find(params[:id])
    Listing.update(@order.listing_id, sold: false)

    respond_to do |format|
      format.html { redirect_to adminpanel_url, notice: 'Listing placed back for sale.' }
    end
  end

##############################################################################

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
    respond_with(@order)
  end

  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id
    @buyer = User.find(@order.buyer_id)

    Stripe.api_key = ENV["stripe_api_key"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@listing.price * 103).floor,
        :currency => "usd",
        :source => token
        )
      flash[:notice] = "Thanks for ordering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

    respond_to do |format|
      if @order.save
        OrderSoldNotifier.send_bookready_email(@buyer, @order).deliver
        OrderSoldNotifier.send_ordersold_email(@seller, @order).deliver
        Listing.update(params[:listing_id], sold: true)
        format.html { redirect_to root_url }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :city, :state, :zipcode)
    end
end
