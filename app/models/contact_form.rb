class ContactForm < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :property

  def eval_timeframe(val)
    return "ASAP" if val == 0
    return "2-4 weeks" if val == 1
    return "4-6 weeks" if val == 2
    return "6+ weeks" if val == 3
    return "Don't Care" if val == 4
  end

end
