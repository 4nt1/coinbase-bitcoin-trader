class CreateTransactionsTable < ActiveRecord::Migration

  def up
    create_table :transactions do |t|
      t.integer :time
      t.decimal :rate
      t.string  :type
    end
  end

  def down
    drop_table :transactions
  end

end