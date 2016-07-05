class Address < ActiveRecord::Base

  belongs_to :property, dependent: :destroy

end
