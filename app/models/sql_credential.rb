class SqlCredential < ApplicationRecord
  belongs_to :user
  validates :host, :username, :password, :database, :port, presence: true
  validates :user_id, uniqueness: true
end
