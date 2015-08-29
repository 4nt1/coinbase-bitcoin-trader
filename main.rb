require_relative './config/app_config'

Initializer.call

def wait_for_order(order)
  while Api.order(order.id).status != 'done'
    sleep 10
    yield
  end
end

bitcoins    = Api.btc_account.balance
p "Balance : #{bitcoins} BTC"
@euro_price = 202.02

loop do
  @euro_price = (@euro_price * 1.01).round(3)
  p "Place order for selling #{bitcoins} BTC at #{@euro_price} EUR"
  order = Api.sell(BigDecimal(bitcoins), @euro_price)

  wait_for_order(order) do
    p 'Waiting...'
  end

  order   = Api.order(order.id)
  @euro_price  = BigDecimal(order.funds.to_f / order.filled_size.to_f)
  p "Sold #{bitcoins} BTC at #{@euro_price} EUR"
  @euro_price = (@euro_price * 0.99).round(3)
  euros = BigDecimal(Api.eur_account.balance)
  bitcoins = euros / euro_price
  p "Place order for buying #{bitcoins} bitcoins at #{@euro_price} EUR"
  order = Api.buy(bitcoins, @euro_price)

  wait_for_order(order) do
    p 'Waiting...'
  end

end
