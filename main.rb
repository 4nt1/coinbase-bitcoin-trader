require_relative './config/app_config'

Initializer.call
@error_count = 0

bitcoins    = BigDecimal(Api.btc_account.balance)
euros       = BigDecimal(Api.eur_account.balance)
p "Balance : #{bitcoins} BTC"
p "Balance : #{euros} EUR"
@euro_price = 200.0

if bitcoins > 0
  @euro_price = (@euro_price * 1.01).round(3)
  order = Api.sell(BigDecimal(bitcoins), @euro_price)
  Mail.send("Place order for selling #{bitcoins} BTC at #{@euro_price} EUR", order)
  Transaction.make_from_order(order)

elsif euros > 0
  euros = BigDecimal(Api.eur_account.balance).round(3)
  bitcoins = (euros / @euro_price * 0.975).round(8)
  order = Api.buy(bitcoins, @euro_price)
  Mail.send("Place order for buying #{bitcoins} bitcoins at #{@euro_price} EUR", order)
  Transaction.make_from_order(order)
end


loop do
  sleep 10
  bitcoins    = BigDecimal(Api.btc_account.balance)
  euros       = BigDecimal(Api.eur_account.balance)
  p "Balance : #{bitcoins} BTC"
  p "Balance : #{euros} EUR"

  begin

    Transaction.pending.each do |transaction|
      order = Api.order(transaction.id)

      if order.status == 'done'
        transaction.update(status: 'done')
        bitcoins = BigDecimal(order.filled_size)
        case transaction.side
        when 'buy'
          (1..10).each do |nb|
            growth = 1 + nb/100.to_f
            euro_price = transaction.rate * growth
            o = Api.sell(bitcoins/10, euro_price)
            Mail.send("Place order for selling #{bitcoins/10} BTC at #{euro_price} EUR", o)
            Transaction.make_from_order(o)
          end
        when 'sell'
          obtained_euros = bitcoins * transaction.rate
          (1..10).each do |nb|
            euro_price = transaction.rate * drop
            btc_to_buy  = (obtained_euros / 10 / euro_price * 0.975).round(8)
            o = Api.buy(btc_to_buy, euro_price)
            Mail.send("Place order for buying #{btc_to_buy} bitcoins at #{euro_price} EUR", o)
            Transaction.make_from_order(o)
          end
        end

      end

    end
  rescue => e
    @error_count += 1
    Mail.send("#{e.message} | #{@error_count} errors")
    raise if @error_count > 9

  end

end
