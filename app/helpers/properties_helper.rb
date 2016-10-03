module PropertiesHelper

	# upgrades form_helper
	def setup_upgrade(upgrade)
		property.upgrade ||= Upgrade.new
		property.upgrades.each do |upgrade|
			upgrade.properties_upgrades.build(upgrade: upgrade)
		end

	end
end
