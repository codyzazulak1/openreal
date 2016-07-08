class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :rememberable, :recoverable :confirmable, :lockable, :timeoutable and :omniauthable

  validates :first_name, presence: true
  validates :last_name, presence: true

  devise :database_authenticatable, :registerable, :validatable, :trackable 

  def full_name
    self.first_name << " " << self.last_name
  end

  private

end
