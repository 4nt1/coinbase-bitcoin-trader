class Mail

  class << self

    def send(message)
      msg = {
       subject:  "Message from coinbase trader",
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