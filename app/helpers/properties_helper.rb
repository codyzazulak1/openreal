module PropertiesHelper

  def setup_property(property)
    property.address ||= Address.new
    property
  end

end
