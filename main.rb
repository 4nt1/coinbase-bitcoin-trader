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
  p "Place order for selling #{bitcoins} BTC at #{@euro_price} EUR"
  order = Api.sell(BigDecimal(bitcoins), @euro_price)

  order   = Api.order(order.id)
  @euro_price  = BigDecimal(order.funds.to_f / order.filled_size.to_f)
  p "Sold #{bitcoins} BTC at #{@euro_price} EUR"

elsif euros > 0
  euros = BigDecimal(Api.eur_account.balance).round(3)
  bitcoins = (euros / @euro_price * 0.9975).round(8)
  p "Place order for buying #{bitcoins} bitcoins at #{@euro_price} EUR"
  order = Api.buy(bitcoins, @euro_price)
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
            o = Api.sell(bitcoins/10, transaction.rate * growth)
            Transaction.make_from_order(o)
          end
        when 'sell'
          obtained_euros = bitcoins * transaction.rate
          (1..10).each do |nb|
            rate = transaction.rate * drop
            btc_to_buy  = (obtained_euros / 10 / rate * 0.9975).round(8)
            o = Api.buy(btc_to_buy, rate)
            Transaction.make_from_order(o)
          end
        end

      end

    end
  rescue => e
    @error_count += 1

    message = {
     subject:  "Oups, something went wrong",
     from_name:  "Coinbase Trader",
     text: "#{e.message}",
     to: [
       { email:  "mail@antoinemary.me",
         name:  "antoine" }
     ],
     html: "<html><p>#{e.message}</p><p>#{@error_count} errors</p></html>",
     from_email: "coinbase@antoinemary.me"
    }
    sending = $mandrill.messages.send message

    raise if @error_count > 9

  end

end
