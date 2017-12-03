
-- Slider button
-- v1


---------------------------
-- dependencies:
--
-- none
--
--
--
---------------------------

local rb = {}

rb.new = function(options)
print("options=", options)

    local height = options.height or options.h
    local width = options.width or options.w or display.contentWidth
    local buttons = options.buttons
    local onSelect = options.onSelect
    local initialIndex = options.initialIndex or 1

    local group = display.newGroup()

    group._selectedButton = nil

    --slide selector

    local colorNotSelected = _G.COLORS.black
    local colorSelected = _G.COLORS.white


    local groupButtons = {}

    local function createTextButton(buttonObj)

        local text = buttonObj.Name or buttonObj.name or buttonObj.title or buttonObj.label
        local onSelect = buttonObj.onSelect

        local group = display.newGroup()

        local title = display.newText{text=text, font=_G.FONTS.regular, fontSize=16}
        --title:setTextColor(1,0,0) -- title color is set on the function onScrollComplete below

        local backgroundW = title.contentWidth + 20
        local background = display.newRect(backgroundW*0.5, height *0.5,backgroundW, height)
        background.alpha = 0
        background.isHitTestable = true
        group:insert(background)
        group:insert(title)
        group.title = title
        group.background = background

        title.x = background.x
        title.y = background.y

        group._target = buttonObj

        return group

    end


    -- creating the buttons
    local scrollContentGroup = display.newGroup()
    for i=1, #buttons do
        local b = createTextButton(buttons[i])
        if groupButtons[#groupButtons] == nil then
            b.x = 0
        else
            b.x = groupButtons[#groupButtons].x + groupButtons[#groupButtons].contentWidth
        end
        groupButtons[#groupButtons+1] = b
        scrollContentGroup:insert(b)
    end



    local sv


    local function findClosestButtonToPositionX(screenXpos)

        -- loops looking for the first button after the centerX of the screen. If found, returns the button immediately before
        for i=1, #groupButtons do
            local bt =  groupButtons[i].background
            local btCenterX = bt:localToContent(0,0)

            if (btCenterX - bt.contentWidth*0.5) > screenXpos then
                if i==1 then
                    return groupButtons[i]
                else
                    return groupButtons[i-1]
                end
            end
        end

        return groupButtons[#groupButtons]
    end



    local function findClosestButtonToCenter()
        return findClosestButtonToPositionX(width*.5)
    end



    local menuSelectedHighlight

    -- selects the button
    local selectButton = function (buttonObj, disableAnimation)

        local btCenterX = buttonObj.background:localToContent(0,0)
        local deltaX = width*.5 - btCenterX


        local bt1LeftPos = groupButtons[1]:localToContent(0,0)

        local duration = 800

        if disableAnimation then
            duration = 0
            onSelect({target=buttonObj._target})
        end

        transition.to(menuSelectedHighlight, {width = buttonObj.background.contentWidth, time=duration})

        local function onScrollComplete()

            for i=1, #groupButtons do
                groupButtons[i].title:setFillColor(unpack(colorNotSelected))
            end
            buttonObj.title:setFillColor(unpack(colorSelected))

            group._selectedButton = buttonObj

            if onSelect and disableAnimation ~= true then
                onSelect({target=buttonObj._target})
            end

        end
        sv:scrollToPosition{
            x = bt1LeftPos + deltaX,
            time = duration,
            onComplete = onScrollComplete
        }

    end


    -- ScrollView listener
    local function scrollListener( event )

        local phase = event.phase

        if ( phase == "began" ) then ----print( "Scroll view was touched" )
        elseif ( phase == "moved" ) then ----print( "Scroll view was moved" )
        elseif ( phase == "ended" ) then
        --elseif ( phase == "stopped" ) then
            --print(phase)
            --print(phase, require("json").encode(event))
            --print(" ")
            if math.abs(event.x - event.xStart) <= 5 then -- user did a tap (not scrolled) on a specific button
                ----print("user tapped")
                local destButton  = findClosestButtonToPositionX(event.x)
                selectButton(destButton)
            end
            -- else

            --     local destButton  = findClosestButtonToCenter()
            --     selectButton(destButton)
            -- end

            ----print( "Scroll view was released" )

        elseif ( phase == "stopped" ) then
            -- print(phase, require("json").encode(event))
            -- print(" ")
            -- print("- - ")

            -- print("getPos=", event.target:getContentPosition())
            -- print("- - ")
                local destButton  = findClosestButtonToCenter()
                selectButton(destButton)
        end

    --    -- In the event a scroll limit is reached...
    --    if ( event.limitReached ) then
    --        if ( event.direction == "up" ) then --print( "Reached top limit" )
    --        elseif ( event.direction == "down" ) then --print( "Reached bottom limit" )
    --        elseif ( event.direction == "left" ) then --print( "Reached left limit" )
    --        elseif ( event.direction == "right" ) then --print( "Reached right limit" )
    --        end
    --    end

        return true
    end

    -- creates the background
    local scrollViewBackground = display.newRect(0, 0, width, height)
    scrollViewBackground.x, scrollViewBackground.y = display.contentCenterX, scrollViewBackground.contentHeight*0.5
    scrollViewBackground:setFillColor(unpack(_G.COLORS.brown))
    group:insert(scrollViewBackground)

    -- creates the rectangle that highlights the button selected
    menuSelectedHighlight = display.newRect(display.contentCenterX,scrollViewBackground.y,groupButtons[1].background.contentWidth,height)
    menuSelectedHighlight:setFillColor(unpack(_G.COLORS.transparent))
    menuSelectedHighlight.strokeWidth = 2
    group:insert(menuSelectedHighlight)

    -- calculates the padding to allow all buttons to move to the center of the screen
    local leftPadding = math.abs(display.contentCenterX - groupButtons[1].background.contentWidth*0.5)
    local rightPadding = math.abs(display.contentCenterX - groupButtons[#groupButtons].background.contentWidth*0.5)

    -- creates the scrollview
    local scrollView = require("widget").newScrollView{
        x = scrollViewBackground.x,
        y = scrollViewBackground.y,
        width = width,
        height = height,
        listener = scrollListener,
        --backgroundColor = {228/255,217/255,184/255},
        hideBackground = true,
        verticalScrollDisabled  = true,
        leftPadding = leftPadding,
        rightPadding = rightPadding

    }
    sv = scrollView

    -- Create a image and insert it into the scroll view
    scrollView:insert( scrollContentGroup )
    group:insert(scrollView)
    group.scrollView = scrollView

    -- sets the position of the entire group
    group.x = options.left or 0
    group.y = options.top


    -- selects the first button
    --selectButton(groupButtons[1], true)
    selectButton(groupButtons[initialIndex], true)



       -- number is the same order as entered when creating the buggons
    function group:selectIndex(number)
        --print("eee =", number)
        if number == nil or groupButtons[number] == nil then return end

        selectButton(groupButtons[number], true)

    end


    function group:getSelected()
        return group._selectedButton.title.text, group._selectedButton
    end

    return group

end


return rb

