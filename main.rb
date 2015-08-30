require_relative './config/app_config'

Initializer.call
error_count = 0
ORDER_COUNT = 16
dispatch = ORDER_COUNT.times.map { |i| (0.005 + 0.001 * i).round(3) }

debugger

loop do

  sleep 10

  begin

    bitcoins    = BigDecimal(Api.btc_account.available)
    euros       = BigDecimal(Api.eur_account.available)
    p "Balance : #{bitcoins} BTC"
    p "Balance : #{euros} EUR"

    euro_price = BigDecimal($client.spot_price['amount'])

    if bitcoins > 0

      bits  = bitcoins / ORDER_COUNT
      dispatch.each do |nb|
        price = (euro_price * (1 + nb)).round(2)
        order = Api.sell(BigDecimal(bits/ORDER_COUNT), price)
        Mail.send("Place order for selling #{bits} BTC at #{price} EUR", order)
      end

    elsif euros > (0.01 * euro_price).to_f * ORDER_COUNT

      euros = euros * 0.975 / ORDER_COUNT
      dispatch.each do |nb|
        price = (euro_price * (1 - nb)).round(2)
        bits  = (euros / euro_price).round(8)
        order = Api.buy(bits, price)
        Mail.send("Place order for buying #{bits} bitcoins at #{price} EUR", order)
      end

    end

  rescue => e
    Mail.send(e.message)
  end

end
