class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :rememberable, :trackable :recoverable :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  private


end
