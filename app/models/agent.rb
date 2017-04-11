class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :trackable
         #:recoverable, :rememberable, :trackable,
   validates :first_name, presence: true
   validates :last_name, presence: true
   validates :company_name, presence: true

  def full_name
    self.first_name << " " << self.last_name
  end
end
