class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :rememberable, :recoverable :confirmable, :lockable, :timeoutable and :omniauthable

  validates :first_name, presence: true
  validates :last_name, presence: true

  devise :database_authenticatable, :registerable, :validatable, :trackable 

  private

end
