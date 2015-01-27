class OrderSoldNotifier < ActionMailer::Base
  default from: "echtchange_noreply@echtchange.com"

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_ordersold_email(user, order)
    @user = user
    @order = order
	mail( to: @user.email, subject: 'Your Book has Sold!' )
  end

  def send_bookready_email(user)
    @user = user
    mail( to: @user.email, subject: 'Your Book is Ready for Pickup!' )
  end
end
