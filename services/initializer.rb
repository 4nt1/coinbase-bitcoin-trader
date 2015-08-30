class Initializer

  class << self

    def call
      settings
      client
      api
      mandrill
    end

    private

      def settings
        $settings = HashWithIndifferentAccess.new(YAML.load(File.read("#{$app_path}/config/settings.yml")))
      end

      def client
        $client = Coinbase::Wallet::Client.new($settings[:coinbase])
      end

      def mandrill
        $mandrill = Mandrill::API.new($settings[:mandrill][:api_key])
      end

      def api
        if ARGV[0] == 'exchange'
          $api = Coinbase::Exchange::Client.new(*$settings[:exchange].to_a.map(&:last), product_id: "BTC-EUR")
        else
          $api = Coinbase::Exchange::Client.new(*$settings[:sandbox].to_a.map(&:last),
                                                api_url: "https://api-public.sandbox.exchange.coinbase.com")
        end
      end
  end
end