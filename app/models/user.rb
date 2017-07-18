class User < ApplicationRecord

  before_save { self.email = email.downcase if email.present? }
  before_save :format_name

  validates :name, presence: true, length: { minimum: 1, maximum: 100 }

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/
  validates :email, presence: true, length: { minimum: 3, maximum: 254 },
            uniqueness: { case_sensitive: false },
            format: { with: EMAIL_REGEX }

  has_secure_password


  def format_name
    self.name = self.name.split(' ').map{ |n| n.capitalize }.join(' ') if name.present?
  end

end
