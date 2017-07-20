class User < ApplicationRecord
  has_many :posts, dependent: :destroy 

  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { minimum: 1, maximum: 100 }

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email, presence: true, length: { minimum: 3, maximum: 254 },
            uniqueness: { case_sensitive: false }

  has_secure_password

end
