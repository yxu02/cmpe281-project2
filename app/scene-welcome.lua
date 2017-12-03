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


    local lbWelcome = display.newText{parent=sceneGroup, text="Welcome", x=_G.CENTER_X, y=SCREEN_H*0.05, font=_G.FONTS.regular, fontSize=40 }
    lbWelcome:setTextColor(unpack(_G.COLORS.white))
    lbWelcome.anchorY = 0


    local lbMessage = display.newText{parent=sceneGroup, text="Thanks for trying Ketocarb tracker.\n\nYou just took the first step to a Healthier life!", x=_G.CENTER_X, y=lbWelcome.y + lbWelcome.contentHeight + 20, font=_G.FONTS.light, fontSize=24, width=_G.SCREEN_W*0.9, align="center" }
    lbMessage:setTextColor(unpack(_G.COLORS.white))
    lbMessage.anchorY = 0


    local imgHealth = display.newImageRect(sceneGroup, "images/icons/ic-heart.png", 120, 104)
    imgHealth.x = _G.CENTER_X
    imgHealth.y = lbMessage.y + lbMessage.contentHeight + imgHealth.contentHeight*.5 + 10
    imgHealth.xScale = 0.8
    imgHealth.yScale = 0.8


    sceneGroup.heartTransitionId = transition.to( imgHealth, {xScale = 1, yScale = 1, delay = 1000, time = 1300, transition=easing.continuousLoop, iterations=99})


    local btNextTop = math.max(imgHealth.y + imgHealth.contentHeight, SCREEN_H*0.8)
    local btNextHandler = function()
        composer.gotoScene( "scene-welcome2", {time=400, effect="slideLeft"})
    end

    local btNext = CW.newGreenButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = btNextTop,
        label = "next",
        onRelease = btNextHandler
    }


     local btLoginHandler = function()
        composer.gotoScene( "scene-login", {time=400, effect="slideLeft"})
    end

    local btLogin = CW.newTransparentButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = btNext.y + btNext.contentHeight*.5,
        label = "Already have an account",
        onRelease = btLoginHandler
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
        -- timer.performWithDelay( 1000, function()
        --     composer.gotoScene( "scene-welcome", { effect="fade", time=400} )
        -- end)


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

        if sceneGroup.heartTransitionId then
            transition.cancel(sceneGroup.heartTransitionId)
            sceneGroup.heartTransitionId = nil
        end

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