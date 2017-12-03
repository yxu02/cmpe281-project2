local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view



    ------------------------------------------------------------------
    -- top bar

    local topBar = require("module-topBar").new{
        title= _G.CALENDAR.getDateForTopBarFromDateString(_G.CALENDAR.currDateString),
        parent=sceneGroup,
        isHidden=false,
        leftButtonHandler = function()
            sceneGroup.changeDateBy(-1)
        end,
        rightButtonHandler = function()
            sceneGroup.changeDateBy(1)
        end

    }
    local bottom = topBar.contentBounds.yMax

    local sceneTop = topBar.contentBounds.yMax
    local cw = require("custom-widgets")

    local tabBar = require("module-tabBar").tabBar


    local getDataForMealId = function(data, mealId)
        print("Data=")
        jp(data)
        print("mealId=", mealId)
        local d = {}
        for k,v in ipairs(data) do
            if tonumber(v.mealId) == tonumber(mealId) then
                d[#d+1] = v
            end
        end
        return d, (#d==0)
    end

    sceneGroup.showDailyContent = function(dateString, data)
        data = data or {}

        topBar:setTitle(CALENDAR.getDateForTopBarFromDateString(dateString))

        display.remove(sceneGroup.scrollView)
        display.remove(sceneGroup.groupContent)

        local groupContent = display.newGroup()
        sceneGroup:insert(groupContent)
        groupContent.y = sceneTop
        sceneGroup.groupContent = groupContent



        --TODO: Replace the calculation below to use the module-calories.lua
        ------------------------------------------------------------------
        -- calculation data
        local caloriesPerFat = 9
        local caloriesPerNetCarb = 4 --- Net Carb = Carb - Fiber
        local caloriesPerProtein = 4


        local totalCarbs = 0    -- the Carb (at USDA) is calculated by difference =>  Carb = total weight - protein - fat - ash - water  (http://www.encyclopedia.com/education/dictionaries-thesauruses-pictures-and-press-releases/carbohydrate-difference)
        local totalFat = 0
        local totalProtein = 0
        local totalFiber = 0


        local totalCaloriesNetCarbs = 0
        local totalCaloriesFat = 0
        local totalCaloriesProtein = 0

        for k, v in ipairs(data) do
            totalCarbs = totalCarbs + v.carb
            totalFat = totalFat + v.fat
            totalProtein = totalProtein + v.protein
            totalFiber = totalFiber + v.fiber

            totalCaloriesNetCarbs =  totalCaloriesNetCarbs + (v.carb - v.fiber)*caloriesPerNetCarb
            totalCaloriesFat = totalCaloriesFat + v.fat*caloriesPerFat
            totalCaloriesProtein = totalCaloriesProtein + v.protein*caloriesPerProtein
        end

        local totalQuantity = totalCarbs + totalFat + totalProtein
        local percentCarbs, percentFat, percentProtein = 0, 0, 0

        local totalCalories = totalCaloriesNetCarbs + totalCaloriesFat + totalCaloriesProtein
        local percentCalNetCarbs, percentCalFat, percentCalProtein = 0,0,0
        if totalQuantity > 0 then
            percentCarbs = math.round(totalCarbs*100 / totalQuantity)
            percentFat = math.round(totalFat*100 / totalQuantity)
            percentProtein = 100 - percentCarbs - percentFat


            percentCalNetCarbs = math.round(totalCaloriesNetCarbs*100 / totalCalories)
            percentCalFat = math.round(totalCaloriesFat*100 / totalCalories)
            percentCalProtein = 100 - percentCalNetCarbs - percentCalFat
        end

        ------------------------------------------------------------------
        -- daily total summary

        local colLeftX = (77/375)*_G.SCREEN_W
        local colRightX = ((375 - 77)/375)*_G.SCREEN_W


        local lbQuantity = display.newText{parent=groupContent, text="Quantity", x=colLeftX, y=0, font=_G.FONTS.light, fontSize=24 }
        lbQuantity:setTextColor(unpack(_G.COLORS.black))
        lbQuantity.anchorY = 0


        local lbCalories = display.newText{parent=groupContent, text="Calories", x=colRightX, y=0, font=_G.FONTS.light, fontSize=24 }
        lbCalories:setTextColor(unpack(_G.COLORS.black))
        lbCalories.anchorY = 0


        bottom = lbQuantity.y + lbQuantity.contentHeight


        local pieW = 100 --(110/375)*_G.SCREEN_W

        local pieData = {
                {value = percentFat/100, label = percentFat .. "%", color = _G.COLORS.fat},
                {value = percentProtein/100, label = percentProtein .. "%", color = _G.COLORS.protein},
                {value = percentCarbs/100, label = percentCarbs .. "%", color = _G.COLORS.carb},
        }

        if totalQuantity == 0 then
            pieData = { {value=1, label="", color = _G.COLORS.gray} }
        end

        local pieQuantity = _G.RBW.newPieChart({
            parent = groupContent,
            x = colLeftX,
            y = bottom + pieW*.5,
            data = pieData,
            radius = pieW*0.5,
            showLabel = true,
            labelFontSize = 12
        })

        _G.FRAMES.newPieLegend{parent=groupContent,x=CENTER_X, y=pieQuantity.y}

        local pieData = {
                {value = percentCalFat/100, label = percentCalFat .. "%", color = _G.COLORS.fat},
                {value = percentCalProtein/100, label = percentCalProtein .. "%", color = _G.COLORS.protein},
                {value = percentCalNetCarbs/100, label = percentCalNetCarbs .. "%", color = _G.COLORS.carb},
        }

        if totalCalories == 0 then
            pieData = { {value=1, label="", color = _G.COLORS.gray} }
        end

        local pieCalories = _G.RBW.newPieChart({
            parent = groupContent,
            x = colRightX,
            y = bottom + pieW*.5,
            data = pieData,
            radius = pieW*0.5,
            showLabel = true,
            labelFontSize = 12
        })
        bottom = pieCalories.y + pieW*.5 + 20


        -----------------------------
        -- Blue Buttons

        local mealsType = STORAGE.getMealType()


        local buttonOnRelease = function(e)
            local id = e.target.id
            print("id=", id)

            -- Options table for the overlay scene "pause.lua"
            local options = {
                isModal = true,
                effect = "slideUp",
                time = 400,
                params = {
                    mealId = id,
                    dateString=sceneGroup.currDateString,
                }
            }
            composer.showOverlay( "scene-foodDrink-add", options )
            TABBAR.hide(true)


                return true;
        end

        local marginW = _G.MARGIN_W / 2
        local buttonLeft = marginW
        for _, m in ipairs(mealsType) do
            local g = CW.newBlueRoundedButton({parent=groupContent, text=m.name, left=buttonLeft, top=bottom + 10, id=m.id, onRelease=buttonOnRelease})
            if SCREEN_W - g.contentBounds.xMax < marginW then
                 buttonLeft = marginW
                 g.x = buttonLeft + g.contentWidth*.5
                 bottom = g.y + g.contentHeight*.5
                 g.y =  bottom + g.contentHeight*.5 + 10
            end

            buttonLeft = g.x + g.contentWidth*.5 + 10
        end
        bottom = groupContent.contentHeight + 10





        for _, m in ipairs(mealsType) do


            local groupMeal = FRAMES.newSection{parent=groupContent, top = bottom, labelLeft=m.name, labelMid="Carbs", labelRight="Calories", isHeader=true}
            local dataBreakFast, isEmpty = getDataForMealId(data, m.id)
            if isEmpty then
                FRAMES.newSection{parent=groupMeal, top = nil, labelLeft="No data"}
            else
                for k,v in ipairs(dataBreakFast) do
                    print("V=")
                    jp(v)
                    FRAMES.newSection{parent=groupMeal, top = nil, labelLeft=v.foodName, labelMid=v.carb, labelRight=v.calories}
                end
            end
            bottom = groupMeal.y + groupMeal.contentHeight
        end



        local svH = tabBar.y - sceneTop

        if svH < groupContent.contentHeight then

            local scrollView = require("widget").newScrollView{
                left = 0,
                top = groupContent.y,
                width = _G.SCREEN_W,
                height = svH,
                hasBackground = false,
                horizontalScrollDisabled = true,
                bottomPadding = 20,
            }
            groupContent.y = 0
            scrollView:insert(groupContent)
            sceneGroup:insert(scrollView)
            sceneGroup.scrollView = scrollView

        end

    end



    local data = _G.STORAGE.getHistoricalDailyConsumption()

    sceneGroup.changeDateBy = function(delta)
        local newDateString = CALENDAR.increaseDateStringByDays(sceneGroup.currDateString, delta)
        sceneGroup.showDailyContent(newDateString, data[newDateString])
        sceneGroup.currDateString = newDateString
    end


    sceneGroup.currDateString = CALENDAR.getTodayDateString()
    sceneGroup.showDailyContent(sceneGroup.currDateString , data[sceneGroup.currDateString ])

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