class Transaction < ActiveRecord::Base
  # :id,                        string
  # :time,                      integer
  # :rate,                      decimal
  # :side, [buy, sell],         string
  # :status, [done, pending]    string

  class << self

    def pending
      where.not(status: 'done')
    end

    def make_from_order(order)
      create( id:     order.id,
              time:   order.created_at,
              price:  order.price ,
              side:   order.side,
              status: 'pending')
    end
  end
end
