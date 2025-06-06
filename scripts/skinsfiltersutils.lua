require("skinsutils")

-- Utility functions to be used by any widget or screen that
-- requires filtered subsets of a skins list.
-- The widget must pass itself in as the owner parameter.
-- The widget must contain owner.full_skins_list, which will be filtered into owner.skins_list.
-- (In most cases, the skins list should be generated by GetInventorySkinsList() which is in skinsutils.lua)
-- The widget must also contain a BuildInventoryList function that takes a skins_list

-- Call this function to initialize required tables
--[[function InitFilters(owner, skins_list)
	owner.applied_filters = {}
	owner.full_skins_list = skins_list
	owner.skins_list = nil

	--print("Set filters data", owner.applied_filters, owner.full_skins_list, owner.skins_list)
end]]

--[[function ClearFilters(owner)
	--print("Clearing filters")
	--owner.filters:ClearAllSelections() -- This is to reset the dropdown widget
	owner.applied_filters = {}
end]]

local typeList = {}
typeList["base"] = true
typeList["body"] = true
typeList["hand"] = true
typeList["legs"] = true
typeList["feet"] = true
typeList["item"] = true


local rarityList = {}
rarityList["Complimentary"] = true
rarityList["Common"] = true
rarityList["Classy"] = true
rarityList["Spiffy"] = true
rarityList["Distinguished"] = true
rarityList["Elegant"] = true
rarityList["Timeless"] = true
rarityList["Reward"] = true
rarityList["Loyal"] = true
rarityList["Resurrected"] = true
rarityList["ProofOfPurchase"] = true
rarityList["Event"] = true

local coloursList = {}
coloursList["black"] = true
coloursList["blue"] = true
coloursList["brown"] = true
coloursList["green"] = true
coloursList["grey"] = true
coloursList["navy"] = true
coloursList["orange"] = true
coloursList["pink"] = true
coloursList["purple"] = true
coloursList["red"] = true
coloursList["tan"] = true
coloursList["teal"] = true
coloursList["white"] = true
coloursList["yellow"] = true


-- Apply a list of filters
-- Each filter is a list containing a group of filter values that must ALL apply to the item in order to add it.
-- eg filters = { {"Classy", "legs"}, {"Common"} }
function ApplyFilters(full_skins_list, filters)
	--print( "~~~~~~~~~~~~~ApplyFilters~~~~~~~~~~~~~~" )
	--dumptable(filters)
	local filtered_list = {}

	for _,skin_item in ipairs(full_skins_list) do
		for _, filters_list in pairs(filters) do

			local matches_filters = true

			for _,filter_name in pairs( filters_list) do
				if string.lower(filter_name) == "none" then
					filtered_list = CopySkinsList(full_skins_list)
					return filtered_list
				else
					local filter_type = ""
					local filter_value = ""
					if typeList[filter_name] then
						filter_type = "type"
						filter_value = filter_name
					elseif rarityList[filter_name] then
						filter_type = "rarity"
						filter_value = filter_name
					elseif IsItemId(filter_name) then
						filter_type = "item"
						filter_value = filter_name
					elseif coloursList[filter_name] then
						filter_type = "colour"
						filter_value = filter_name
					end

					-- Each item must match all the values in this filter
					if filter_type == "type" and skin_item.type ~= filter_value then
						matches_filters = false
						break
					elseif filter_type == "rarity" and GetRarityForItem(skin_item.item) ~= filter_value then
						matches_filters = false
						break
					elseif filter_type == "item" and skin_item.item ~= filter_value then
						matches_filters = false
						break
					elseif filter_type == "colour" and ITEM_COLOURS[skin_item.item] ~= filter_value then
						matches_filters = false
						break
					end
				end
			end

			if matches_filters and IsItemMarketable(skin_item.item) and skin_item.item_id ~= TEMP_ITEM_ID then
				table.insert(filtered_list, skin_item)
				break -- stop checking filters if we matched one
			end
		end
	end

	return filtered_list
end


--[[function RemoveFilter(owner, filter)
	--print("Removing filter ", filter)
	if filter and typeList[filter] then
		filter = typeList[filter]
	elseif filter and rarityList[filter] then
		filter = rarityList[filter]
	end


	local applied_filters = {}
	for k,v in ipairs(owner.applied_filters) do
		if v ~= filter then
			table.insert(applied_filters, v)
		end
	end

	owner.applied_filters = applied_filters
	if not owner.applied_filters then
		owner.applied_filters = {}
	end

	--print("Dumping applied_filters table:")
	--dumptable(owner.applied_filters)
	ApplyFilter(nil)
end]]
