-- setting default background to white
display.setDefault( "background", 1,1,1 )

-- defyning the status bar type
display.setStatusBar( display.DefaultStatusBar )

-- definying globals
_G.STATUS_BAR_H = display.topStatusBarContentHeight + 2
_G.TOP_Y_AFTER_STATUS_BAR = display.topStatusBarContentHeight + 2

_G.CENTER_X = display.contentCenterX
_G.CENTER_Y = display.contentCenterY
_G.SCREEN_W = display.contentWidth
_G.SCREEN_H = display.contentHeight



_G.MARGIN_W = 20

_G.COLORS = require("module-colors")
_G.FONTS = require("module-fonts")
-- _G.AUX = require("module-aux")
_G.BACK = require("rb-libs.rb-back")
_G.DEVICE = require("rb-libs.rb-device")
--_G.SERVER = require("server")

_G.CW = require "custom-widgets"

_G.USER = require "class-user"
_G.TABBAR = require("module-tabBar").createTabBar()
-- _G.TABBAR.hide()

_G.RBW = require("rb-libs.rb-widget")



require "custom-display"

local background = display.newRect(CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
background.fill = _G.COLORS.transparent
background.isHitTestable = true
_G.BACKGROUND = background
background:addEventListener( "tap", function() native.setKeyboardFocus( nil ) end)



-- giving a small delay to main to allow it close, avoiding possible black screens when lauching Corona
timer.performWithDelay(10, function()

    local composer = require("composer");
    --composer.recycleOnSceneChange = true

    -- if _G.USER.token then
    --   composer.gotoScene("scene-foodDrink")
    --    _G.TABBAR.show(true)
    -- else
       --composer.gotoScene("scene-welcome")
    ---end


    --composer.gotoScene("scene-welcome2")
    --composer.gotoScene("scene-welcome3")
    --composer.gotoScene("scene-welcome4-register")

    --composer.gotoScene("scene-summary")
    composer.gotoScene("scene-foodDrink")

    --composer.gotoScene("scene-register")
    --composer.gotoScene("scene-login")
    --composer.gotoScene("scene-list")
    --composer.gotoScene("scene-detail")
    --composer.gotoScene("scene-upload")
    --composer.gotoScene("scene-upload2")



end)
