class AccountUser < ActiveRecord::Base

  belongs_to :account
  belongs_to :user

  attr_accessible :user_id, :account_id, :permissions

end
