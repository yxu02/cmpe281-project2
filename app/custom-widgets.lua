local cw = {}

local rbW = require("rb-libs.rb-widget")

local COLORS = require("module-colors")



cw.newGreenButton = function(options)
	local parent = options.parent
	local x = options.x
	local y = options.y
	local left = options.left
	local top = options.top
    local width = options.width
	local label = options.label
	local onRelease = options.onRelease

	local button = rbW.newButton{
        x = x,
        y = y,
        left = left,
        top = top,
        width = width or 250,
        height = 44,
        label = label,
        labelColor = { 1, 1, 1 },
        labelOverColor = { 0, 0, 0, 0.5 },
        labelAlign = "center",
        backgroundColor = _G.COLORS.green,
        backgroundOverColor = _G.COLORS.overlay("green"),
        backgroundDisabledColor = {.3,.3,.3},
        labelFont = _G.FONTS.light,
        labelFontSize = 18,
        scrollViewParent = scrollViewParentFunction,
        onRelease = onRelease,
        onTap = function() print("tapped"); return true end
    }
    if parent then
        parent:insert(button)
    end

    return button
end


cw.newRedButton = function(options)
    local parent = options.parent
    local x = options.x
    local y = options.y
    local left = options.left
    local top = options.top
    local width = options.width
    local label = options.label
    local onRelease = options.onRelease

    local button = rbW.newButton{
        x = x,
        y = y,
        left = left,
        top = top,
        width = width or 250,
        height = 44,
        label = label,
        labelColor = { 1, 1, 1 },
        labelOverColor = { 0, 0, 0, 0.5 },
        labelAlign = "center",
        backgroundColor = _G.COLORS.darkRed,
        backgroundOverColor = _G.COLORS.overlay("darkRed"),
        backgroundDisabledColor = {.3,.3,.3},
        labelFont = _G.FONTS.light,
        labelFontSize = 18,
        scrollViewParent = scrollViewParentFunction,
        onRelease = onRelease,
        onTap = function() print("tapped"); return true end
    }
    if parent then
        parent:insert(button)
    end

    return button
end



cw.newTransparentButton = function(options)
    local parent = options.parent
    local x = options.x
    local y = options.y
    local left = options.left
    local top = options.top
    local width = options.width
    local label = options.label
    local onRelease = options.onRelease

    local button = rbW.newButton{
        x = x,
        y = y,
        left = left,
        top = top,
        width = width or 250,
        height = 44,
        label = label,
        labelColor = { 1, 1, 1 },
        labelOverColor = { 0, 0, 0, 0.5 },
        labelAlign = "center",
        backgroundColor = _G.COLORS.transparent,
        backgroundOverColor = _G.COLORS.dqtransparent,
        backgroundDisabledColor = {.3,.3,.3},
        labelFont = _G.FONTS.light,
        labelFontSize = 18,
        scrollViewParent = scrollViewParentFunction,
        onRelease = onRelease,
        onTap = function() print("tapped"); return true end
    }
    if parent then
        parent:insert(button)
    end

    return button
end



cw.newBlueRoundedButton = function(options)

    local parent = options.parent

    local left = options.left
    local x = options.x
    local top = options.top
    local y = options.y

    local width = options.width

    local id = options.id
    local text = options.text
    local onRelease = options.onRelease

    local fontSize = 16


    local group = display.newGroup()
    group.id = id
    group.anchorChildren = true

    local leftWidth = 34
    local rightWidth = 15

    local leftImage = display.newImageRect(group, "images/buttons/bt-blue-left.png", leftWidth, 30)
    leftImage.x = leftImage.contentWidth*.5
    leftImage.y = leftImage.contentHeight*.5

    local lb = display.newText{parent=group, text=text, x=0, y=0, font=_G.FONTS.light, fontSize=fontSize }
    lb:setTextColor(unpack(_G.COLORS.white))
    group.label = lb

    local midWidth = lb.contentWidth
    if width then
        midWidth = math.max(width - leftWidth - rightWidth, midWidth)
    end
    local midImage = display.newImageRect(group, "images/buttons/bt-blue-mid.png", midWidth, leftImage.contentHeight)
    midImage.x = leftImage.x + leftImage.contentWidth*.5 + midImage.contentWidth*.5
    midImage.y = leftImage.y

    lb.x = midImage.x
    lb.y = midImage.y
    lb:toFront()

    local rightImage = display.newImageRect(group, "images/buttons/bt-blue-right.png", rightWidth, 30)
    rightImage.x = midImage.x + midImage.contentWidth*.5 + rightImage.contentWidth*.5
    rightImage.y = midImage.y



    group:addEventListener("tap", function(e)
        group.alpha = 0.7

        timer.performWithDelay(30, function()
            group.alpha = 1
            if onRelease then
                onRelease(e)
            end
        end)

    end)

    -- positioning the button
    group.x = x or (left and (left + group.contentWidth*.5)) or (right and (right - group.contentWidth*.5))
    group.y = y or (top and (top + group.contentHeight*.5)) or (bottom and (bottom - group.contentHeight*.5))

    if parent then
        parent:insert(group)
    end

    return group
end



cw.newBackButton = function(options)
    local parent = options.parent
    --local left = options.left
    --local top = options.top
    --local width = options.width
    --local label = options.label
    --local onRelease = options.onRelease

    local button = rbW.newButton{
        left = 0,
        bottom = _G.SCREEN_H,
        width = 70,
        height = 40,
        label = label,
        labelColor = { 1, 1, 1 },
        labelOverColor = { 0, 0, 0, 0.5 },
        labelAlign = "center",
        backgroundColor = _G.COLORS.transparent,
        backgroundOverColor = _G.COLORS.dqtransparent,
        backgroundDisabledColor = {.3,.3,.3},

        imageFilename = "images/buttons/bt-back.png",
        imageWidth = 60,
        imageHeight = 22,

        labelFont = _G.FONTS.light,
        labelFontSize = 18,
        scrollViewParent = scrollViewParentFunction,
        onRelease = onRelease,
        onTap = function()
            _G.BACK.goBack()
        end
    }
    if parent then
        parent:insert(button)
    end

    return button
end



cw.newLabelWithTextField = function(options)
    local x = options.x
    local y = options.y
    local top = options.top
    local left = options.left
    local label = options.label
    local parent = options.parent
    local isSecure = options.isSecure
    local formatType = options.formatType
    local placeholder = options.placeholder


    local inputType
    if label == "E-mail" then
        inputType = "email"
    elseif label == "Birthday" then
        inputType = "number"
    end

    local autocapitalizationType
    if label == "Name" then
        autocapitalizationType = "words"
    end


    local group = display.newGroup()


    local lb = display.newText{ parent=group, text=label, x=0, y=0, font=FONTS.regular, fontSize=18 }
    lb:setTextColor(unpack(COLORS.white))
    lb.anchorX, lb.anchorY = 0,0


    local input = cw.newTextField{
        left = 0,
        top = lb.y + lb.contentHeight + 10,
        placeholder = placeholder,
        isSecure = isSecure,
        formatType = formatType,
        inputType = inputType,
        autocapitalizationType = autocapitalizationType
    }
    group:insert(input)

    lb.x = input.x - lb.contentWidth*.5


    group.getText = input.getText
    group.setText = input.setText



    group.x = left or (x - group.contentWidth*.5)
    group.y = top or (y - group.contentHeight*.5)

    return group
end

cw.newTextField = function(options)
    local fullW = 250
    local halfW = 122
    local halHalffW = 60

    local width = options.isHalfWidth and halfW or fullW
    width = options.isHalfHalfWidth and halHalffW or width
    if options.width then
        width = options.width
    end

    local input = rbW.newTextField{
        x = options.x,
        y = options.y,
        top = options.top,
        left = options.left,
        width = width,
        height = 40,
        font = FONTS.regular,
        fontSize = 18,
        textColor = COLORS.black,
        placeholder = options.placeholder,
        placeholderColor = COLORS.placeholder,
        backgroundColor = COLORS.white,
        --bottomLineWidth = 1,
        --bottomLineColor = COLORS.gray,
        isSecure = options.isSecure,
        formatType = options.formatType,
        inputType = options.inputType,
        autocapitalizationType = options.autocapitalizationType,

        onRelease = options.onRelease,
        useFakeLabel = options.useFakeLabel,

        align = "left",

        --hasBackground = true,

    }

    return input
end

-- cw.new2LabelsTransparentButton = function(options)

--         local parent = options.parent
--         local label1 = options.label1
--         local label2 = options.label2
--         local bottom = options.bottom
--         local onRelease = options.onRelease


--         local group = display.newGroup()

--         local groupLabels = display.newGroup()

--         group:insert(groupLabels)
--         local lbRegular = display.newText{parent=groupLabels, text=label1, x=0, y=0, font=FONTS.regular, fontSize=14 }
--         lbRegular:setTextColor(unpack(COLORS.black))
--         lbRegular.anchorX, lbRegular.anchorY = 0,0
--         local lbBold = display.newText{parent=groupLabels, text=label2, x=lbRegular.contentWidth, y=lbRegular.contentHeight, font=FONTS.bold, fontSize=14 }
--         lbBold:setTextColor(unpack(COLORS.black))
--         lbBold.anchorX, lbBold.anchorY = 0,1

--         local backgroundH = 10 + math.max(lbRegular.contentHeight, lbBold.contentHeight)
--         local background = display.newRect( group, SCREEN_W*.5, backgroundH*.5, SCREEN_W, backgroundH)
--         background.fill = {1,0,0,0}
--         background.isHitTestable = true


--         background:addEventListener("tap", function()
--             if group._hasTapped then return end
--             group._hasTapped = true

--             group.alpha = 0.3
--             timer.performWithDelay(50, function()
--                 group.alpha = 1
--                 group._hasTapped = false
--                 if onRelease then
--                     onRelease()
--                 end
--             end)
--         end)


--         groupLabels.x = background.x - groupLabels.contentWidth*.5
--         groupLabels.y = background.y  + background.contentHeight*.5 - groupLabels.contentHeight



--         group.x = 0
--         group.y = SCREEN_H - group.contentHeight - 10

--         if parent then
--             parent:insert(group)
--         end

--         return group
-- end


return cw