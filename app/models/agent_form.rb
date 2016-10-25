class AgentForm < ActiveRecord::Base
	validates :full_name, length: {minimum: 2}, presence: true
	validates :email, length: {minimum: 8}, presence: true
	validates :company_name, presence: true
end
