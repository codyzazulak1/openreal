class ContactForm < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :property
end
