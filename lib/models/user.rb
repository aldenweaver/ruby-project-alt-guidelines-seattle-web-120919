class User < ActiveRecord::Base
    # belongs_to :
    has_many :shifts
    has_many :stores, through: :shifts
    # has_many :subscriptions
    # has_many :stores, through: :subscriptions
end