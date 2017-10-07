#Upgrades table for property

namespace :upgrade do
	desc "Seeds features for the Upgrades table"
	task :populate => :environment do
	
	section						  = ['pool', 'other', 'kitchen', 'bathroom', 'home_yard']

	feature_kitchen 	  = ['condition', 'countertops', 'appliances', 'extra_features']

	feature_bath 				= ['condition', 'extra_features']

	feature_home_yard 	= ['flooring condition', 'living area flooring kind', 'paint condition', 'back yard condition']

	pool_name 					= ['Yes, You have an in-ground private pool', 'Yes, an above-ground private pool', 'Community pool', 'No pool']

	other_name					= ['Permitted addition', 'Unpermitted addition', 'Leased solar panels', 'Owned solar panels', 'Known foundation issues', 'Gated community', 'Known history of chemical contamination']

	kitchen_condition 	= ['Kitchen needs repairs', 'Some scuffs, stains, or chips', 'Near perfect condition']
	kitchen_countertops = ['Granite slab', 'Granite tile', 'Other tile', 'Quartz', "Other/Don't know"]
	kitchen_appliances 	= ['All stainless steel', 'All black', 'All white', 'Mixed', "Other/Don't know"]
	kitchen_extra_feat 	= ['Kitchen Island', "New cabinets", "Tile backsplash", "None of the above"]

	bath_condition			 = ['Master bathroom needs repairs', 'Some chips, stains, cracks, or loose pieces', 'Near perfect condition']
	bath_extra_features  = ['Double sink', 'Granite/tile counters', 'Separate tub & shower', 'Custom tub / shower', 'Tile shower walls', 'Updated tile floors', 'None of the above']

	hy_floor_condition	 = ['Flooring needs repairs', 'Some chips, stains, cracks, or loose pieces', 'Near perfect condition']
	hy_living_floor_kind = ['Tile', 'Laminate', 'Hardwood', 'Carpet', "Other/Don't know"]
	hy_paint_cond				 = ['Needs work', 'Typical use', 'Great condition']
	hy_backyard					 = ['No yard', 'Needs work', 'Partially landscaped', 'Fully landscaped']

	section.each do |u|

		case u
		when 'pool'
			pool_name.each {|name|
		  	Upgrade.create(name: name, section: u, feature: 'pool')
			}	
		when 'other'
			other_name.each {|name|
				Upgrade.create(name: name, section: u, feature: 'other')
			}
		when 'kitchen'
			feature_kitchen.each {|feature|
				case feature
				when 'condition'
					kitchen_condition.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}
				when 'countertops'
					kitchen_countertops.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}	
				when 'appliances'
					kitchen_appliances.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}
				when 'extra_features'
					kitchen_extra_feat.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}
				end
			}
		when 'bathroom'
			feature_bath.each {|feature|
				case feature
				when 'condition'
					bath_condition.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}
				when 'extra_features'
					bath_extra_features.each {|name|
						Upgrade.create(name: name, section: u, feature: feature)
					}
				end
			}
		when 'home_yard'
		feature_home_yard.each {|feature|
			case feature
			when 'flooring condition'
				hy_floor_condition.each {|name|
					Upgrade.create(name: name, section: u, feature: feature)
				}
			when 'living area flooring kind'
				hy_living_floor_kind.each {|name|
					Upgrade.create(name: name, section: u, feature: feature)
				}
			when 'paint condition'
				hy_paint_cond.each {|name|
					Upgrade.create(name: name, section: u, feature: feature)
				}
			when 'back yard condition'
				hy_backyard.each {|name|
					Upgrade.create(name: name, section: u, feature: feature)
				}
			end
		}
		end #case 
	end #section
	
	end #task
end #namespace	
