local mCalories = {}

-- receives a data
mCalories.getNutrientsBreakdown = function (data) --   data = { {carb=70, fiber=47, protein=35}, {}, {}}

	local caloriesPerFat = 9
	local caloriesPerNetCarb = 4  -- Net Carb = Carb - Fiber
	local caloriesPerProtein = 4



	local totalWeightCarbs = 0    -- the Carb (at USDA) is calculated by difference =>  Carb = total weight - protein - fat - ash - water  (http://www.encyclopedia.com/education/dictionaries-thesauruses-pictures-and-press-releases/carbohydrate-difference)
    local totalWeightFat = 0
    local totalWeightProtein = 0
    local totalWeightFiber = 0
    local totalWeightNetCarbs = 0

    local totalCaloriesNetCarbs = 0
    local totalCaloriesFat = 0
    local totalCaloriesProtein = 0




    for k, v in ipairs(data) do

    	-- calculates the total weight intake
        totalWeightCarbs = totalWeightCarbs + v.carb
        totalWeightFat = totalWeightFat + v.fat
        totalWeightProtein = totalWeightProtein + v.protein

        totalWeightFiber = totalWeightFiber + v.fiber -- fiber is a type of carb
        totalWeightNetCarbs = totalWeightNetCarbs + (v.carb - v.fiber) -- net carb = carb - fiber

        -- calculates the total calories intake
        totalCaloriesNetCarbs =  totalCaloriesNetCarbs + (v.carb - v.fiber)*caloriesPerNetCarb
        totalCaloriesFat = totalCaloriesFat + v.fat*caloriesPerFat
        totalCaloriesProtein = totalCaloriesProtein + v.protein*caloriesPerProtein
    end


    local totalWeight = totalWeightCarbs + totalWeightFat + totalWeightProtein
    local percentWeightCarbs, percentWeightFat, percentWeightProtein = 0, 0, 0

    local totalCalories = totalCaloriesNetCarbs + totalCaloriesFat + totalCaloriesProtein
    local percentCaloriesNetCarbs, percentCaloriesFat, percentCaloriesProtein = 0,0,0

    if totalWeight > 0 then

    	percentWeightNetCarbs = math.round(totalWeightNetCarbs*100 / totalWeight)
        percentWeightCarbs = math.round(totalWeightCarbs*100 / totalWeight)
        percentWeightFat = math.round(totalWeightFat*100 / totalWeight)
        percentWeightProtein = 100 - percentWeightCarbs - percentWeightFat
        percentWeightFiber = math.round(totalWeightFiber*100 / totalWeight)



        percentCaloriesNetCarbs = math.round(totalCaloriesNetCarbs*100 / totalCalories)
        percentCaloriesFat = math.round(totalCaloriesFat*100 / totalCalories)
        percentCaloriesProtein = 100 - percentCaloriesNetCarbs - percentCaloriesFat


    	local weightByNutrient = {
	    	carb = totalWeightCarbs,
	    	netCarb = totalWeightNetCarbs,
	    	fat = totalWeightFat,
	    	protein = totalWeightProtein,
	    	fiber = totalWeightFiber,
	    	total = totalWeight
	    }

	   	local weightPercentByNutrient = {
	    	carb = percentWeightCarbs,
	    	netCarb = percentWeightNetCarbs,
	    	fat = percentWeightFat,
	    	protein = percentWeightProtein,
	    	fiber = percentWeightFiber,
	    }

	    local caloriesByNutrient = {
	    	netCarb = totalCaloriesNetCarbs,
	    	fat = totalCaloriesFat,
	    	protein = totalCaloriesProtein,
	    	total = totalCalories,
	    }

	    local caloriesPercentByNutrient = {
	    	netCarb = percentCaloriesNetCarbs,
	    	fat = percentCaloriesFat,
	    	protein = percentCaloriesProtein,
	    }


	    return weightByNutrient, weightPercentByNutrient, caloriesByNutrient, caloriesPercentByNutrient

    end

end



return mCalories