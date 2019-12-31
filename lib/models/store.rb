class Store < ActiveRecord::Base
    has_many :shifts
    has_many :users, through: :shifts
    # has_many :subscriptions
    # has_many :users, through: :subscriptions
end