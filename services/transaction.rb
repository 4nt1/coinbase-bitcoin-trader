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
      create( id:     o.id,
              time:   o.created_at,
              rate:   o.price ,
              side:   o.side,
              status: 'pending')
    end
  end
end
