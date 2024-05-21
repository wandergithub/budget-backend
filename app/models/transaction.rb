class Transaction < ApplicationRecord
    validates :name, presence: true
    validates :value, presence: true
    validates :id, presence: true
end
