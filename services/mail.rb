class Mail

  class << self

    def send(message, order=nil)
      subject = if order.nil?
        'Error in app'
      else
        "Order #{order.id} validated"
      end
      msg = {
       subject:  subject,
       from_name:  "Coinbase Trader",
       text: "#{message}",
       to: [
         { email:  "mail@antoinemary.me",
           name:  "antoine" }
       ],
       html: "<html>#{message}</html>",
       from_email: "coinbase@antoinemary.me"
      }
      sending = $mandrill.messages.send(msg)
    end

  end

end