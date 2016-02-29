class AddConfirmCodeAndTokenColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirm_code, :string
    add_column :users, :token, :string
  end
end
