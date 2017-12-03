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

    local age = event.params and event.params.age
    local gender = event.params and event.params.gender
    local weight = event.params and event.params.weight


    local background = display.newRect(sceneGroup, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
    background.fill = _G.COLORS.darkBlue

    local spaceBetweenSections =10*(SCREEN_H/480)


    local lbTitle = display.newText{parent=sceneGroup, text="Enter your login information:", x=_G.CENTER_X, y=SCREEN_H*0.06, font=_G.FONTS.regular, fontSize=20, width=_G.SCREEN_W*.94, align="center" }
    lbTitle:setTextColor(unpack(_G.COLORS.white))
    lbTitle.anchorY = 0
    local bottom = lbTitle.y + lbTitle.contentHeight


    ------------------------------------------------------------------
    -- inputs
    local cw = require "custom-widgets"
    local inputsData = {
        {label="E-mail"},
        {label="Password", isSecure=true},
    }


    local inputs = {}
    for k, v in ipairs(inputsData) do
        inputs[v.label] = cw.newLabelWithTextField{
            parent = sceneGroup,
            x = CENTER_X,
            top = bottom + 20,
            label = v.label,
            placeholder = v.placeholder,
            isSecure = v.isSecure,
            formatType = v.formatType,
        }
        sceneGroup:insert(inputs[v.label])
        bottom = inputs[v.label].y + inputs[v.label].contentHeight
    end



    local checkRequiredFields = function(email, password)
        local result, errorCode = _G.AUX.validateString(email, "email", 4)
        if result == false then
            local msg = "Please enter your email"
            if errorCode > 1 then
                msg = "Email used is invalid"
            end
            _G.AUX.showAlert(msg)
            return false
        end

        local result, errorCode = _G.AUX.validateString(password, "password", 1)
        if result == false then
            local msg = "Please enter a password"
            if errorCode > 1 then
                msg = "Password used is invalid"
            end
            _G.AUX.showAlert(msg)
            return false
        end

        return true
    end


    local btLoginHandler = function()

        -- checking inputs
        local email = inputs["E-mail"]:getText()
        local password = inputs["Password"]:getText()
        print(email, name, password)

        if checkRequiredFields(email, password) == false then
            return
        end
        native.setActivityIndicator( true )
        SERVER.login(email, password,
            function()

                SERVER.getHistoricalData(
                    function()
                        native.setActivityIndicator( false )
                        TABBAR.show(true)
                        composer.gotoScene( "scene-summary", {effect="slideLeft", time=400})
                    end,
                    function(errorMsg)
                        native.setActivityIndicator( false )
                        _G.AUX.showAlert(errorMsg)
                    end)
            end,
            function(errorMsg)
                native.setActivityIndicator( false )
                _G.AUX.showAlert(errorMsg)
            end)

    end


    local btLoginTop = math.max(bottom + 10, SCREEN_H*0.8)
    local btLogin = CW.newGreenButton{
        parent = sceneGroup,
        x = CENTER_X,
        top = btLoginTop,
        label = "login",
        onRelease = btLoginHandler
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