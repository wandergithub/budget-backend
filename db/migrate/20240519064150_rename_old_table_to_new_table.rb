class RenameOldTableToNewTable < ActiveRecord::Migration[7.1]
  def change
    rename_table :expenses, :transactions
  end
end
