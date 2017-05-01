class Agent < ActiveRecord::Base

  mount_uploader :profile_picture, PictureUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :trackable
         #:recoverable, :rememberable, :trackable,
   validates :first_name, presence: true
   validates :last_name, presence: true
   validates :company_name, presence: true
   

   has_many :properties
   has_one :picture, dependent: :destroy

  def full_name
    self.first_name << " " << self.last_name
  end
end
