-- v1.0


local t = {}

t.tabBar = {} -- pointer to the active tabBar

local colorBackground = _G.COLORS.tabBar
local colorSelected = _G.COLORS.white
local colorNotSelected = _G.COLORS.overlay("white", 0.3)

local hide = function(animated)
    --print("on hide")
    if t.tabBar.y == display.contentHeight then
        return
    end

    animated = animated or false

    local duration = 200
    if animated == false then
        duration = 0
    end
    transition.to(t.tabBar, {y=display.contentHeight, time=duration})
end

local show = function(animated)
    print("show tabbar")
    _G.TABBAR.update()

    if t.tabBar.y == (display.contentHeight - t.tabBar.contentHeight) then
        return
    end


    animated = animated or false

    local duration = 200
    if animated == false then
        duration = 0
    end
    transition.to(t.tabBar, {y=display.contentHeight - t.tabBar.contentHeight, time=duration})
end


local new = function(tabBarOptions)



    local buttons = tabBarOptions.buttons

    local tabBar = display.newGroup()


    tabBar.icon = {} -- pointer to the icons
    tabBar.label = {}

    -- background

    local background = display.newRect(0,0,SCREEN_W, 60)
    background.fill = colorBackground
    tabBar:insert(background)
    background.x = background.contentWidth*0.5
    background.y = background.contentHeight*0.5
    background:addEventListener( "tap", function() return true end )
    background:addEventListener( "touch", function() return true end )

    local function buttonHandler(e)

        if e.target.id == nil then
            --print("nil")
            return
        end

        -- sets default colors for all buttons
        for i=1, #buttons do
            if tabBar.icon[i] ~= nil then
                tabBar.icon[i]:setFillColor(unpack(colorNotSelected))
            end
            if tabBar.label[i] ~= nil then
                tabBar.label[i]:setTextColor(unpack(colorNotSelected))
            end
        end

        -- set the pressed color
        tabBar.icon[e.target.index]:setFillColor(unpack(colorSelected))
        tabBar.label[e.target.index]:setTextColor(unpack(colorSelected))

        if buttons[e.target.index].openScene then
            local composer = require "composer"
            composer.removeScene( buttons[e.target.index].openScene )
            composer.gotoScene(buttons[e.target.index].openScene, e.sceneParams)
        end

    end

    -- function that selects a bar
    tabBar.selectIndex = function(indexNumber, sceneParams)
        buttonHandler({target={index = indexNumber, id = indexNumber}, sceneParams=sceneParams})
    end

    -- funcion that only highlights the bar button (not does the change scene)
    tabBar.highlightIndex = function(indexNumber)
        if indexNumber == nil then print("warning - calling highlightIndex with nil param"); return end

        -- sets default colors for all buttons
        for i=1, #buttons do
            if tabBar.icon[i] ~= nil then
                tabBar.icon[i]:setFillColor(unpack(colorNotSelected))
            end
            if tabBar.label[i] ~= nil then
                tabBar.label[i]:setTextColor(unpack(colorNotSelected))
            end
        end

        -- set the pressed color
        tabBar.icon[indexNumber]:setFillColor(unpack(colorSelected))
        tabBar.label[indexNumber]:setTextColor(unpack(colorSelected))
    end

    -- buttons
    local buttonBackW = background.contentWidth / #buttons
    local buttonBackH = background.contentHeight

    for i=1, #buttons do

        if buttons[i].id == nil and buttons[i].imageFilename == nil then
            --print("leaving blank space in tabBar")
        else
            local buttonBack = display.newRect(0,0,buttonBackW,buttonBackH)
            tabBar:insert(buttonBack)
            buttonBack.x = buttonBack.contentWidth*0.5 + buttonBackW*(i-1)
            buttonBack.y = buttonBack.contentHeight*0.5
            buttonBack.alpha = 0
            buttonBack.isHitTestable = true
            buttonBack:addEventListener("tap", buttonHandler)
            buttonBack.id = buttons[i].id
            buttonBack.index = i

            local icon = display.newImageRect(buttons[i].imageFilename, buttons[i].imageWidth, buttons[i].imageHeight)
            tabBar:insert(icon)
            tabBar.icon[i] = icon
            icon.x = buttonBack.x
            icon.y = buttonBack.y - 4
            icon:setFillColor(unpack(colorNotSelected))


            local label = display.newText{parent=tabBar, text=buttons[i].label, x=icon.x, y=icon.y+icon.contentHeight*.5 + 4, fontSize=10}
            label.anchorY=0
            label:setTextColor(unpack(colorNotSelected))
            tabBar.label[i] = label
        end
    end



    local dicSceneNameToButtonIndex = {}
    for i=1, #buttons do
--        print("buttons[i].openScene=", buttons[i].openScene)
        if buttons[i].openScene then
            dicSceneNameToButtonIndex[buttons[i].openScene] = i
        end

    end
    tabBar.getButtonIndexFromSceneName = function(sceneName)

        return dicSceneNameToButtonIndex[sceneName]

    end

    tabBar.update = function()
        print("tabBar.update")
        local currentScene = require("composer").getSceneName("current")

        if currentScene then
            for i=1, #buttons do
                --print(buttons[i].openScene)
                if buttons[i].openScene == currentScene then
                    tabBar.highlightIndex(i)
                end
            end
        end

    end

    -- making the tabBar to be displayed above the composer scenes
    local stage = display.getCurrentStage()
    stage:insert( require( "composer" ).stage )
    stage:insert( tabBar )
    --stage:insert(_G.statusBarBackground)

    -- positionating the tab bar
    tabBar.x = 0
    tabBar.y = SCREEN_H - background.contentHeight


    tabBar.hide = hide
    tabBar.show = show

    return tabBar


end




-- PUBLIC FUNCTIONS

t.createTabBar = function()
    print("on create")
    local buttons = {
            {id=10, label="Summary", imageFilename = "images/icons/ic-summary.png", imageWidth=28, imageHeight=26, openScene="scene-summary"},
            {id=20, label="Food/Drink", imageFilename = "images/icons/ic-food.png", imageWidth=39, imageHeight=27, openScene="scene-foodDrink"},
            {id=30, label="Measurement", imageFilename = "images/icons/ic-measurement.png", imageWidth=50, imageHeight=26, openScene="scene-measurement" },
            {id=30, label="Profile", imageFilename = "images/icons/ic-profile.png", imageWidth=26, imageHeight=26, openScene="scene-profile" },
        }


    t.tabBar = new({buttons = buttons})

    return t.tabBar

end


t.removeTabBar = function()
    display.remove(t.tabBar)
end



return t