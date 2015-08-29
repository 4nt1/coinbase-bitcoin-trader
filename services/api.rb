class Api
  class << self
    def method_missing(method_name, *args, &block)
      if $api.respond_to?(method_name)
        result = JSON.parse($api.send(method_name, *args, &block))
        if result.is_a?(Array)
          result.map { |r| RecursiveOpenStruct.new(r, recurse_over_arrays: true) }
        else
          RecursiveOpenStruct.new(result, recurse_over_arrays: true)
        end
      else
        super
      end
    end

    [:btc, :eur].each do |currency|
      define_method "#{currency}_account" do
        accounts.find { |a| a.currency == "#{currency.upcase}" }
      end
    end
  end
end