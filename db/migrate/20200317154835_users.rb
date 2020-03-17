class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |d|
      d.string :username
      d.string :password_digest
    end
  end
end
