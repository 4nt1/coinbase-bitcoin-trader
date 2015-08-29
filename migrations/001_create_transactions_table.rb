class CreateTransactionsTable < ActiveRecord::Migration

  def up
    create_table :transactions do |t|
      t.string  :coinbase_id
      t.integer :time
      t.decimal :price
      t.string  :side
      t.string  :status
    end
  end

  def down
    drop_table :transactions
  end

end