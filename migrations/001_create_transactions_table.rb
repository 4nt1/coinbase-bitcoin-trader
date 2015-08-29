class CreateTransactionsTable < ActiveRecord::Migration

  def up
    create_table :transactions, { id: false } do |t|
      t.string  :id
      t.string  :time
      t.decimal :price
      t.string  :side
      t.string  :status
    end
  end

  def down
    drop_table :transactions
  end

end