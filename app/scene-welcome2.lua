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


    local lbTitle = display.newText{parent=sceneGroup, text="This app allows you to track:", x=_G.CENTER_X, y=SCREEN_H*0.1, font=_G.FONTS.regular, fontSize=20 }
    lbTitle:setTextColor(unpack(_G.COLORS.white))
    lbTitle.anchorY = 0
    local bottom = lbTitle.y + lbTitle.contentHeight


    local dataFeatures = {
        {iconFilename="images/icons/ic-food.png", iconW=39, iconH=27, message="Food/drink intake"},
        {iconFilename="images/icons/ic-measurement-vertical.png", iconW=29, iconH=56, message="Weight and other measurements"},
        {iconFilename="images/icons/ic-summary.png", iconW=28, iconH=26, message="Macronutritients intake, perfect for low car / keto followers"}
    }

    local newFeatureGroup = function(iconFilename, iconW, iconH, text)

        local group = display.newGroup()

        local imgIcon = display.newImageRect(group, iconFilename, iconW, iconH)
        imgIcon.anchorX, imgIcon.anchorY = 0, 0
        imgIcon.x = 0
        imgIcon.y = 0

        local lbFeature = display.newText{parent=group, text=text, x=imgIcon.x + imgIcon.contentWidth + 20, y=imgIcon.y , font=_G.FONTS.light, fontSize=24, width=(240/375)*_G.SCREEN_W, align="left" }
        lbFeature:setTextColor(unpack(_G.COLORS.white))
        lbFeature.anchorX = 0
        lbFeature.anchorY = 0
        --lbFeature.y = imgIcon.y + imgIcon.contentHeight*.5 - lbFeature.contentHeight*.5

        return group
    end
    bottom = bottom + 20
    for _, o in ipairs(dataFeatures) do
        local groupFeatureRow = newFeatureGroup(o.iconFilename, o.iconW, o.iconH, o.message)
        sceneGroup:insert(groupFeatureRow)
        groupFeatureRow.x = CENTER_X - groupFeatureRow.contentWidth*.5
        groupFeatureRow.y = bottom + 10
        bottom = groupFeatureRow.y + groupFeatureRow.contentHeight + 20
    end






    local btNext = CW.newGreenButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = bottom,
        label = "next",
        onRelease = function()
            composer.gotoScene( "scene-welcome3", {time=400, effect="slideLeft"})
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