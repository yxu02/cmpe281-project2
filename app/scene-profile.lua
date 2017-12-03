local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view



    ------------------------------------------------------------------
    -- top bar

    local topBar = require("module-topBar").new{
        title="Customize your app",
        parent=sceneGroup,
        isHidden=false
    }

    topBar.hideRightButton()
    topBar.hideLeftButton()


    local sceneTop = topBar.contentBounds.yMax
    local cw = require("custom-widgets")

    local tabBar = require("module-tabBar").tabBar

    local bottom = topBar.contentBounds.yMax


    local lbName = display.newText{parent=sceneGroup, text=_G.USER.name or "[Full name]", x=_G.CENTER_X, y=bottom + 20, font=_G.FONTS.regular, fontSize=24 }
    lbName:setTextColor(unpack(_G.COLORS.black))
    lbName.anchorY = 0
    bottom = lbName.y + lbName.contentHeight


    local groupPref = display.newGroup()
    sceneGroup:insert(groupPref)
    groupPref.y = bottom + 20

    local groupPreferencesHeader = FRAMES.newSection{parent=groupPref, top = 0, labelLeft="Preferences", isHeader=true}
    bottom = groupPreferencesHeader.y + groupPreferencesHeader.contentHeight


    local groupUnits = FRAMES.newSection{parent=groupPref, top = nil, labelLeft="Units", labelRight="Lbs / inch", labelFontRight=_G.FONTS.light}

    local groupLanguage = FRAMES.newSection{parent=groupPref, top = nil, labelLeft="Language", labelRight="English", labelFontRight=_G.FONTS.light}
    bottom = groupPref.y + groupPref.contentHeight

    local groupAccount = display.newGroup()
    sceneGroup:insert(groupAccount)
    groupAccount.y = bottom

    local groupAccountHeader = FRAMES.newSection{parent=groupAccount, top = 0, labelLeft="Account", isHeader=true}
    bottom = groupAccountHeader.y + groupAccountHeader.contentHeight

    local btLogout = CW.newRedButton{
        parent = groupAccount,
        x = CENTER_X,
        top = bottom + 10,
        label = "Logout",
        onRelease = _G.USER.logout
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