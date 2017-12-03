local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view

    local background = display.newRect(sceneGroup, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
    background.fill = _G.COLORS.gray


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

    local groupMeasurements = display.newGroup()
    sceneGroup:insert(groupMeasurements)

    groupMeasurements.y = sceneTop + 50
    groupMeasurements.x = _G.MARGIN_W

    local dataInDisplay = {}


    local dataWeight = _G.STORAGE.getWeightData()

    sceneGroup.showMeasurementField = function(id)

        local obj = _G.STORAGE.getMeasurementFromId(id)

        local group = display.newGroup()


        local lb = display.newText{parent=group, text=obj.name, x=0, y=0, font=_G.FONTS.regular, fontSize=24 }
        lb:setTextColor(unpack(_G.COLORS.black))
        lb.anchorX = 0

        local inputLeft = math.max(lb.x + lb.contentWidth + 20, 170)
        local input = _G.CW.newTextField({
            left =  inputLeft,
            y = lb.y,
            isHalfHalfWidth = true,
            useFakeLabel = false,
        })
        group:insert(input)


        local txtUnit = _G.STORAGE.getUnitForMeasurementId(id)
        local lbUnit = display.newText{parent=group, text=txtUnit, x=input.x + input.contentWidth*.5 + 4, y=input.y, font=_G.FONTS.regular, fontSize=20 }
        lbUnit:setTextColor(unpack(_G.COLORS.black))
        lbUnit.anchorX = 0





        group.y = groupMeasurements.numChildren == 0 and 0 or groupMeasurements.contentHeight + 8

        groupMeasurements:insert(group)

        dataInDisplay[id] = input

        return group

    end





    sceneGroup.showMeasurementField(1)



    local btAddHandler = function()
        native.setActivityIndicator( true )

        local weight = dataInDisplay[1]:getText()
        print("weight=", weight)

        _G.SERVER.addWeight(weight, sceneGroup.currDateString,
            function(data)
                native.setActivityIndicator( false )
                timer.performWithDelay(100, function()
                    _G.AUX.showAlert("Measurement added!")
                end)
            end,
            function()
                native.setActivityIndicator( false )
                _G.AUX.showAlert("Failed to add measurement. Please try again later.")
         end)
    end

    local btAdd = CW.newGreenButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = groupMeasurements.y + groupMeasurements.contentHeight + 20,
        label = "add",
        onRelease = btAddHandler
    }


    -- local data = STORAGE.getMeasurementData()

    -- for i,v in ipairs(data) do
    --     if not dataInDisplay[v.id] then
    --         sceneGroup.showMeasurementField(v.id)
--            local g = CW.newBlueRoundedButton({parent=sceneGroup, text="Blood Pressure", x=CENTER_X, y=CENTER_Y})
    --     end
    -- end


    -- local g = CW.newBlueRoundedButton({parent=sceneGroup, text="Blood Pressure", x=CENTER_X, y=CENTER_Y})

    sceneGroup.changeDateBy = function(delta)
        local newDateString = CALENDAR.increaseDateStringByDays(sceneGroup.currDateString, delta)
        print("newDateString", newDateString)
        --sceneGroup.showDailyContent(newDateString, data[newDateString])
        sceneGroup.currDateString = newDateString

        topBar:setTitle(CALENDAR.getDateForTopBarFromDateString(newDateString))
        print("dataWeight[newDateString] =", dataWeight[newDateString] and dataWeight[newDateString].weight)
        if dataWeight[newDateString] then
            dataInDisplay[1]:setText(dataWeight[newDateString].weight)
            btAdd:setLabel("save")
        else
            btAdd:setLabel("add")
            dataInDisplay[1]:setText("")
        end

    end


    sceneGroup.currDateString = CALENDAR.getTodayDateString()

    if dataWeight[sceneGroup.currDateString] then
        dataInDisplay[1]:setText(dataWeight[sceneGroup.currDateString].weight)
        btAdd:setLabel("save")
    end

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