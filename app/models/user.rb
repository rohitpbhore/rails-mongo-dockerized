class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  has_secure_password
  field :email, type: String
  field :password_digest, type: String

  # embeds_one :profile
  # accepts_nested_attributes_for :profile

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,length: { minimum: 6 },
                     if: -> { new_record? || !password.nil? }
end