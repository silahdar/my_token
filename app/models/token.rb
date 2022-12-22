class Token < ApplicationRecord
  validates :secret, presence: true, length: { maximum: 64 }, uniqueness: true
end
