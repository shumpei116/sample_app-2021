class User < ApplicationRecord
before_save { self.email = self.email.downcase }
  validates(:name, {:presence => true})
    # 下記は（）なし、{}無しの省略記法である
  validates :name, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, presence:  true, length: {minimum: 6}
end
