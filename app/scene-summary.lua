local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view


    local background = display.newRect(sceneGroup, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
    background.fill = _G.COLORS.gray


    ------------------------------------------------------------------
    -- top bar

    local topBar = require("module-topBar").new{
        title="Summary",
        parent=sceneGroup,
        isHidden=false
    }
    topBar.hideRightButton()
    topBar.hideLeftButton()

    local bottom = topBar.contentBounds.yMax

    local sceneTop = topBar.contentBounds.yMax
    local cw = require("custom-widgets")

    local tabBar = require("module-tabBar").tabBar



    local weightHistoricalData = _G.STORAGE.getWeightData()

    local chartWeightData = {}

    local maxValue = 0
    for dateString, v in pairs(weightHistoricalData) do

         local entry = {}
         entry.key = _G.CALENDAR.getMonthDayFromDateString(dateString)
         entry.values = {v.weight/1000}  -- we divide by 1000 to convert the Grams to Kg and don't end up with a huge bar
         entry.valuesColors = {_G.COLORS.blue}
         entry.totalLabel = _G.CONVERTER.toImperial(v.weight,"grams")
         entry.dateString = dateString
         maxValue = math.max(maxValue, v.weight)
         chartWeightData[#chartWeightData+1] = entry
    end


    local function compare( a, b )
        return a.dateString < b.dateString  -- lower comes first
    end
    table.sort( chartWeightData, compare )


    local chartWeight = RBW.newBarChart{
        parent = sceneGroup,
        width = 300,
        top = bottom + 10,
        x = CENTER_X,
        data = chartWeightData,
        axisXDataKey = "key",
        axisXFontSize = 12,
        title = "Weight History",
        titleFont = _G.FONTS.regular,
        backgroundColor = _G.COLORS.white,
        columnWidth = 36,
        hideValuesLabel = true,

    }
    bottom = chartWeight.y + chartWeight.contentHeight*.5






    local foodHistoricalData = _G.STORAGE.getHistoricalDailyConsumption()

    local chartFoodData = {}

    for dateString, v in pairs(foodHistoricalData) do
        local _, _, totalCaloriesByNutrient, percentCaloriesByNutrient = require("module-calories").getNutrientsBreakdown(v)


        local entry = {}
         entry.key = _G.CALENDAR.getMonthDayFromDateString(dateString)
         entry.values = {percentCaloriesByNutrient.protein, percentCaloriesByNutrient.fat, percentCaloriesByNutrient.netCarb }
         entry.valuesColors = {_G.COLORS.protein, _G.COLORS.fat, _G.COLORS.carb}
         --entry.totalLabel = AUX.formatDecimal(math.round(totalCaloriesByNutrient.total))
         entry.totalLabel = AUX.formatDecimal(_G.CONVERTER.toImperial(totalCaloriesByNutrient.total,"grams"))
         entry.valuesLabelSuffix = "%"
         entry.dateString = dateString

         chartFoodData[#chartFoodData+1] = entry
    end

    table.sort( chartFoodData, compare )

    local chartFood = RBW.newBarChart{
        parent = sceneGroup,
        width = 300,
        top = bottom + 10,
        x = CENTER_X,
        data = chartFoodData,
        axisXDataKey = "key",
        axisXFontSize = 12,
        title = "Calories per Nutrients",
        titleFont = _G.FONTS.regular,
        backgroundColor = _G.COLORS.white,
        columnWidth = 36,
    }

end



function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

     elseif ( phase == "did" ) then
        if composer.getSceneName( "previous" ) ~= "scene-splash" then
            _G.BACK.addPreviousScene()
        end

        _G.TABBAR.show()



    end
end



function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then

    end
end



function scene:destroy( event )

    local sceneGroup = self.view

end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene