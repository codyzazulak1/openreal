class Subscriber < ActiveRecord::Base

	validates :full_name, presence: true;
	validates :email, presence: true;

end