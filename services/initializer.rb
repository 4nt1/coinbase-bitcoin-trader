class Initializer

  class << self

    def call
      settings
      client
      api
      database
    end

    private

      def settings
        $settings = HashWithIndifferentAccess.new(YAML.load(File.read('./config/settings.yml')))
      end

      def client
        $client = Coinbase::Wallet::Client.new($settings[:coinbase])
      end

      def database
        ActiveRecord::Base.establish_connection($settings[:db])
        if !ActiveRecord::Base.connection.table_exists?(:transactions)
          CreateTransactionsTable.migrate(:up)
        end
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