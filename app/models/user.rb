class User < ApplicationRecord
  validates :email, presence: true, format: /\A[a-zA-Z0-9_\-\.]+@(([a-zA-Z]+\.[a-zA-Z]+)|(([0-9]\.){3}[0-9]))\z/, uniqueness: true
  validates :password, presence: true, format: /\A[^ ]{6,}\z/
  validates :phone_number, presence: true, uniqueness: true
  validates :username, presence: true, format: /\A[0-9a-zA-Z_\-\.]{6,}\z/
  validates :full_name, presence: true, format: /\A[^!@#\$%\^&\*\(\)\+\{\}]{4,}\z/
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }

  enum gender: %i[male female]
end
