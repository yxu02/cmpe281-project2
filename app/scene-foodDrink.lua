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


    ------------------------------------------------------------------
    -- daily total summary

    local colLeftX = (77/375)*_G.SCREEN_W
    local colRightX = ((375 - 77)/375)*_G.SCREEN_W


    local lbQuantity = display.newText{parent=sceneGroup, text="Quantity", x=colLeftX, y=bottom, font=_G.FONTS.light, fontSize=24 }
    lbQuantity:setTextColor(unpack(_G.COLORS.black))
    lbQuantity.anchorY = 0


    local lbCalories = display.newText{parent=sceneGroup, text="Calories", x=colRightX, y=bottom, font=_G.FONTS.light, fontSize=24 }
    lbCalories:setTextColor(unpack(_G.COLORS.black))
    lbCalories.anchorY = 0


    bottom = lbQuantity.y + lbQuantity.contentHeight


    local pieW = 100 --(110/375)*_G.SCREEN_W

    local pieData = {
            {value = 0.10, label = "A", color = _G.COLORS.fat},
            {value = 0.30, label = "B", color = _G.COLORS.protein},
            {value = 0.60, label = "C", color = _G.COLORS.carb},
    }

    local pieQuantity = _G.RBW.newPieChart({
        parent = sceneGroup,
        x = colLeftX,
        y = bottom + pieW*.5,
        data = pieData,
        radius = pieW*0.5,
        showLabel = true,
        labelFontSize = 12
    })


    local pieCalories = _G.RBW.newPieChart({
        parent = sceneGroup,
        x = colRightX,
        y = bottom + pieW*.5,
        data = pieData,
        radius = pieW*0.5,
        showLabel = true,
        labelFontSize = 12
    })




    local g = CW.newBlueRoundedButton({parent=sceneGroup, text="Breakfast", x=CENTER_X, y=CENTER_Y})






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