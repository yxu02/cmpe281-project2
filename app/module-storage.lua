local storage = {}

local rbStorage = require("rb-libs.rb-storage")

local t = {}

t["2017-11-25"] = {
	{id=1, itemName="Bananas", qty="100g", carb = 50, fat = 70, protein = 90, fiber=10,  calories = 190, mealId=1},
	{id=2, itemName="Apple", qty="40g", carb = 30, fat = 20, protein = 20, fiber=1,  calories = 190, mealId=1},
	{id=2, itemName="Rice", qty="200g", carb = 60, fat = 20, protein = 70, fiber=2,  calories = 190, mealId=2},
	{id=3, itemName="Water", qty="1b", carb = 51, fat = 50, protein = 60, fiber=3,  calories = 0, mealId=2},
	{id=3, itemName="Lasagna", qty="300g", carb = 20, fat = 90, protein = 20, fiber=4,  calories = 190, mealId=3},
}
t["2017-11-27"] = {
	{id=1, itemName="Eggs", qty="2 units", carb = 30, fat = 60, protein = 30, fiber=5,  calories = 190, mealId=1},
	{id=2, itemName="Bacon", qty="10g", carb = 40, fat = 70, protein = 40, fiber=4,  calories = 190, mealId=1},
	{id=2, itemName="Spaguetti", qty="400g", carb = 20, fat = 60, protein = 22, fiber=3,  calories = 190, mealId=2},
	{id=3, itemName="Water", qty="1b", carb = 10, fat = 70, protein = 26, fiber=1,  calories = 190, mealId=2},
}



-- local fakeWeightData = {}
-- fakeWeightData["2017-11-25"] = {
-- 	{id=1, weight=87.3},
-- 	{id=2, weight=89.3},
-- 	{id=3, weight=91},
-- 	{id=4, weight=94},
-- 	{id=5, weight=97},
-- }



storage.getHistoricalDailyConsumption = function()
	--return t
	return rbStorage.get("food") or {}
end

storage.setFoodData = function(data)
	rbStorage.set("food", data)
end



storage.getMealType = function()
  	local mealsData = {
        {id=1, name="Breakfast"},
        {id=2, name="Lunch"},
        {id=3, name="Dinner"},
        {id=4, name="Snack"},
        {id=5, name="Drink"},
    }
    return mealsData
end

storage.getMealNameFromId = function(mealId)
	for k,v in ipairs(storage.getMealData()) do
		if v.id == mealId then
			return v.name
		end
	end
end


storage.getMeasurementData = function()
  	local data = {
        {id=1, name="Weight"},
        {id=2, name="% Body Fat"},
        {id=3, name="% Body Water"},
    }
    return data
end

storage.getMeasurementFromId = function(measurementId)
	for k,v in ipairs(storage.getMeasurementData()) do
		if v.id == measurementId then
			return v
		end
	end
end


storage.getUnitForMeasurementId = function(measurementId)
	if measurementId == 1 then
		return "lbs"
	elseif measurementId == 2 then
		return "%"
	elseif measurementId == 3 then
		return "%"
	end

	return "lbs"
end

storage.getLastWeightDate = function()
	print("on getLastWeightDate - ", storage._lastWeightDate)
	if storage._lastWeightDate then
		return storage._lastWeightDate
	end
	local lastWeightDate = nil
	local weightData = storage.getWeightData()
	for dateString, _ in pairs(weightData) do
		print("dateString=", dateString)
		if lastWeightDate == nil then
			lastWeightDate = dateString
		else
			if dateString > lastWeightDate then
				lastWeightDate = dateString
			end
		end
	end

	storage._lastWeightDate = lastWeightDate
	return storage._lastWeightDate, storage._lastWeightDate
end





storage.getWeightData = function()
	return rbStorage.get("weight") or {}
end
storage.setWeightData = function(data)
	rbStorage.set("weight", data)
end
storage.appendWeight = function(weight, dateString)
	local data = storage.getWeightData() or {}
	local newEntry = {}
	newEntry.weight = weight
	newEntry.measuredAt = dateString
	data[dateString] = newEntry

	storage.setWeightData(data)
end



return storage