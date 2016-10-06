class ContactForm < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :property

  def eval_timeframe
    return "ASAP" if self.timeframe == 0
    return "2-4 weeks" if self.timeframe == 1
    return "4-6 weeks" if self.timeframe == 2
    return "6+ weeks" if self.timeframe == 3
    return "No preference" if self.timeframe == 4
  end

end
