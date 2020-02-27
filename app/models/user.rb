class User < ActiveRecord::Base
  has_secure_password

  def withdraw(amount)
    amount =amount.to_i
    if self.balance > amount
      self.balance -= amount
      self.save
      return amount
    end
  end

  def deposit(amount)
    amount = amount.to_i
    if self.balance.nil?
      self.balance = 0
    end
    self.balance += amount
    self.save
    amount
  end

  def display_balance
    self.balance ? self.balance : 0
  end
end
