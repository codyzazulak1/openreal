class Property < ActiveRecord::Base

  before_save :default_values

  def default_values
    self.matterurl ||= ''
  end

  attr_accessor :current_step

  validates :list_price_cents, presence: true

  has_one :address, dependent: :destroy
  has_one :contact_form, dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :status
  has_many :property_upgrades, dependent: :destroy
  has_many :upgrades, through: :property_upgrades

  accepts_nested_attributes_for :property_upgrades
  accepts_nested_attributes_for :address
  validates_associated :address
  accepts_nested_attributes_for :contact_form
  validates_associated :contact_form
  accepts_nested_attributes_for :photos


  monetize :list_price_cents, as: :list_price

  # def to_param
  #   "#{id}-#{title.parameterize}"  
  # end

  def self.just_listed(num = 3)
    new_listing = where("CREATED_AT >= ?", 7.days.ago).order("CREATED_AT DESC").limit(num)
    if new_listing.size > 0
      return new_listing
    else
      return all.order("CREATED_AT DESC").limit(num)
    end
  end

  def is_new?
    self.created_at >= 3.days.ago

  end
  def self.similar_listings(property, num = 3)
    bed_range = (property.bedrooms - 2)..(property.bedrooms + 2)
    bath_range = (property.bathrooms - 2)..(property.bathrooms + 2)
    # price_range = (property.list_price_cents - 5000000)..(property.list_price_cents + 5000000)

    similar_listings = where(bedrooms: bed_range, bathrooms: bath_range).order("CREATED_AT DESC").limit(num)
    if similar_listings
      return similar_listings
    else
      return all.order("CREATED_AT DESC").limit(num)
    end
  end

  def self.within(city_name)
    Property.joins(:address).where(:addresses => {:city => city_name})
  end

  def price
    self.list_price.format(:no_cents => true, :symbol => '')
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
    puts self.id
    return "#{self.address.address_first}, #{self.address.city}"
  end

  def self.cities
    Address.select(:city).distinct.map { |address| address.city }
  end

  # for seller form
  def current_step
    @current_step || steps.first
  end

  def current_progress
    (steps.index(self.current_step) + 1) * 100.00 / steps.length
  end

  def steps
    [
      "basic",
      "features",
      #"upgrades",
      "contact"
      #"closing"
    ]
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

  scope :created_desc, -> {order("created_at DESC")}
  scope :price_desc, -> {order("list_price_cents DESC")}
  scope :price_asc, -> {order("list_price_cents ASC")}
  scope :for_sale, -> {where("properties.list_price_cents > 0")}
  scope :for_sale_and_sold, -> {where("properties.list_price_cents >= 0")}
end
