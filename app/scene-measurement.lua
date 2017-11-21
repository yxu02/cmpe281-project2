local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view



    ------------------------------------------------------------------
    -- top bar

    local topBar = require("module-topBar").new{
        title="[12 Nov 17]",
        parent=sceneGroup,
        isHidden=false
    }
    local bottom = topBar.contentBounds.yMax

    local sceneTop = topBar.contentBounds.yMax
    local cw = require("custom-widgets")

    local tabBar = require("module-tabBar").tabBar




    local g = CW.newBlueRoundedButton({parent=sceneGroup, text="Blood Pressure", x=CENTER_X, y=CENTER_Y})


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