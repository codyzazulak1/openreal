class Property < ActiveRecord::Base
  attr_accessor :current_step

  validates :list_price_cents, presence: true

  has_one :address, dependent: :destroy
  has_one :contact_form, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :favorites, dependent: :destroy

  accepts_nested_attributes_for :address
  validates_associated :address
  accepts_nested_attributes_for :contact_form
  validates_associated :contact_form
  accepts_nested_attributes_for :photos

  monetize :list_price_cents, as: :list_price

  def self.just_listed(num = 3)
    Property.where("CREATED_AT >= ?", 3.days.ago).order("CREATED_AT DESC").limit(num)
  end

  def is_new?
    self.created_at >= 3.days.ago
  end

  def self.within(city_name)
    Property.joins(:address).where(:addresses => {:city => city_name})
  end

  def price
    self.list_price.format(:drop_trailing_zeros => true, :symbol => '')
  end

  def city_province
    # province = "British Columbia"
    province = "BC"
    "#{self.address.city}, #{province}"
  end

  def has_photos?
    return true if self.photos.count > 0
    return false
  end

  def lot_area
    return 'N/A' if self.lot_length.nil? || self.lot_width.nil?
    return (self.lot_length * self.lot_width).round
  end

  def address_name
    return "#{self.address.address_first}, #{self.address.city}"
  end

  def current_step
    @current_step || steps.first
  end

  def current_progress
    (steps.index(self.current_step) + 1) * 100.00 / steps.length
  end

  def steps
    %w[basic upgrades features contact closing]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

end
