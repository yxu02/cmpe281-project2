local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.


    local background = display.newRect(sceneGroup, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
    background.fill = _G.COLORS.darkBlue


    local spaceBetweenSections =10*(SCREEN_H/480)


    local lbTitle = display.newText{parent=sceneGroup, text="Let’s customize this app for you...", x=_G.CENTER_X, y=SCREEN_H*0.1, font=_G.FONTS.regular, fontSize=20 }
    lbTitle:setTextColor(unpack(_G.COLORS.white))
    lbTitle.anchorY = 0
    local bottom = lbTitle.y + lbTitle.contentHeight


    local lbCurrentWeight = display.newText{parent=sceneGroup, text="Current Weight:", x=_G.CENTER_X, y=bottom + spaceBetweenSections, font=_G.FONTS.regular, fontSize=20 }
    lbCurrentWeight:setTextColor(unpack(_G.COLORS.white))
    lbCurrentWeight.anchorY = 0
    bottom = lbCurrentWeight.y + lbCurrentWeight.contentHeight

    local minWeight = 66
    local maxWeight = 500
    local incrementalWeight = 0.1
    local dataWeightImperial = {}
    for i=minWeight,maxWeight,incrementalWeight do
        dataWeightImperial[#dataWeightImperial+1] = {name=AUX.formatDecimal(i,1)}
    end

    local sliderButtonWeight = _G.RBW.newSliderButton({
        top = bottom + 4,
        height = 40,
        buttons = dataWeightImperial,  --  [ {Name=, Id=, Services=},{Name=, Id=, Services=},... ]
        onSelect =  function (e)
            print("onSliderButton=",e.target.name)
            --local catID = e.target.Id
        end,
        initialIndex = 991,
    })
    sceneGroup:insert(sliderButtonWeight)
    bottom = sliderButtonWeight.y + sliderButtonWeight.contentHeight




    local lbAge = display.newText{parent=sceneGroup, text="Age:", x=_G.CENTER_X, y=bottom + spaceBetweenSections, font=_G.FONTS.regular, fontSize=20 }
    lbAge:setTextColor(unpack(_G.COLORS.white))
    lbAge.anchorY = 0
    bottom = lbAge.y + lbAge.contentHeight

    local dataAge = {}
    for i=18,100 do
        dataAge[#dataAge+1] = {Id=1, Name=i}
    end
    local sliderButtonAge = _G.RBW.newSliderButton({
        top = bottom + 4,
        height = 40,
        buttons = dataAge,  --  [ {Name=, Id=, Services=},{Name=, Id=, Services=},... ]
        onSelect =  function (e)
            print("onSliderButton=",e.target.name)
            --local catID = e.target.Id
        end,
        initialIndex = 13,
    })
    sceneGroup:insert(sliderButtonAge)
    bottom = sliderButtonAge.y + sliderButtonAge.contentHeight


    local lbGender = display.newText{parent=sceneGroup, text="Gender:", x=_G.CENTER_X, y=bottom + spaceBetweenSections, font=_G.FONTS.regular, fontSize=20 }
    lbGender:setTextColor(unpack(_G.COLORS.white))
    lbGender.anchorY = 0
    bottom = lbGender.y + lbGender.contentHeight


    local temp = display.newRect(sceneGroup, lbGender.x, lbGender.y + lbGender.contentHeight*.5 + 25 + 10, 60,30)
    bottom = temp.y + temp.contentHeight

    local switchGender = _G.RBW.newSwitch{
        parent = sceneGroup,
        x = lbGender.x,
        y = lbGender.y + lbGender.contentHeight*.5 + 25 + 10,
        width = 60,
        height = 30,
        id = id,
        initialValue = false,
        --right = _G.SCREEN_W - math.min(40 * _G.GROW_WITH_SCREEN,70),
        --y = label.y,
        onChange = onSwitchChange,
        disabledAlpha = 0.5,
        --backgroundOnFilename = "images/widgets/switch_bkg_yellow.png",
        --backgroundOffFilename = "images/widgets/switch_bkg_yellow.png"
    }
    bottom = switchGender.y + switchGender.contentHeight

    local lbSwitchGenderLeft = display.newText{parent=sceneGroup, text="Female", x=switchGender.x - switchGender.contentWidth*.5 - 10, y=switchGender.y, font=_G.FONTS.light, fontSize=16 }
    lbSwitchGenderLeft:setTextColor(unpack(_G.COLORS.white))
    lbSwitchGenderLeft.anchorX = 1

    local lbSwitchGenderRight = display.newText{parent=sceneGroup, text="Male", x=switchGender.x + switchGender.contentWidth*.5 + 10, y=switchGender.y, font=_G.FONTS.light, fontSize=16 }
    lbSwitchGenderRight:setTextColor(unpack(_G.COLORS.white))
    lbSwitchGenderRight.anchorX = 0



    local btNextTop = math.max(bottom + 10, SCREEN_H*0.8)
    local btNext = CW.newGreenButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = btNextTop,
        label = "next",
        onRelease = function()
            local age = sliderButtonAge:getSelected()
            local gender = switchGender.currentStatus
            local weight = sliderButtonWeight:getSelected()
            print("age=", age)
            print("gender=", gender)

            composer.gotoScene( "scene-welcome4-register", {time=400, effect="slideLeft", params={age=age, gender=gender, weight=weight}})
        end
    }



    local btBackHandler = CW.newBackButton{
        parent = sceneGroup,
    }


end



function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).


    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        _G.BACK.addPreviousScene()

    end

end



function scene:hide( event )
    print("on scene hide")
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.


    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.

    end
end



function scene:destroy( event )
    print("on scene destroy")
    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.


end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene