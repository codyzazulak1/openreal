class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :favorites

  validates :first_name, presence: true
  validates :last_name, presence: true
  devise :database_authenticatable,
    :registerable,
    :validatable,
    :trackable,
    :rememberable
         #:recoverable, :rememberable, ,
         

  def full_name
    self.first_name << " " << self.last_name
  end

end
