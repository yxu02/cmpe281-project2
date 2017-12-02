local nb = display.newGroup()

nb.new = function(options)

    -- receiving params
    local titleText = options.title or "Editar Dados"
    local leftButtonHandler = options.leftButtonHandler



    local rightButtonHandler = options.rightButtonHandler
    local rightButtonLabel = options.rightButtonLabel
    local useCloseRightButton = options.useCloseRightButton
    local useAddRightButton = options.useAddRightButton

    local parent = options.parent
    local isHidden = options.isHidden or false





    local isButtonsDisabled = false


    local navBar = display.newGroup()

    local background = display.newRect(navBar, SCREEN_W*.5, 44*.5,SCREEN_W, 44)
    background.fill = _G.COLORS.topBar

    local rbW = require("rb-libs.rb-widget")



    local btLeftImageFile = "images/icons/ic-left.png"
    local btLeftImageWidth = 12
    local btLeftImageHeight = 21


    local btLeftW = 40
    local btLeft = rbW.newButton{
        width = btLeftW,
        height = background.contentHeight,
        --backgroundColor = {1,0,1},
        y = background.y,
        --x = 0,
        left = 0,
        imageFile = btLeftImageFile,
        imageWidth = btLeftImageWidth,
        imageHeight = btLeftImageHeight,
        imagePadding = {left=0},
        imageColor = {1,1,1,1},
        imageOverColor = {1,1,1,.3},
        onRelease = function(e)
            if isButtonsDisabled then return end
            if leftButtonHandler then
                return leftButtonHandler(e)
            end
        end ,
    }

    navBar:insert(btLeft)
    -- if leftButtonHandler == nil then
    --     btLeft.isVisible = false
    -- end

    local btRightImageFile = btLeftImageFile
    local btRightImageWidth = btLeftImageWdith
    local btRightImageHeight = btLeftImageHeight
    local btRightImageRotation = 180
    if useCloseRightButton then
        btRightImageFile = "images/top-bar/ic-close.png"
        btRightImageWidth = 20
        btRightImageHeight = 21
        btRightImageRotation = 0
    end

    local btRight = rbW.newButton{
        width = btLeftW,
        height = background.contentHeight,
        --backgroundColor = {1,0,1},
        y = background.y,
        --x = 0,
        right = _G.SCREEN_W,
        imageFile = btRightImageFile,
        imageWidth = btRightImageWidth,
        imageHeight = btRightImageHeight,
        imagePadding = {left=0},
        imageColor = {1,1,1,1},
        imageOverColor = {1,1,1,.3},
        imageRotation = btRightImageRotation,
        onRelease = function(e)
            if isButtonsDisabled then return end
            if rightButtonHandler then
                return rightButtonHandler(e)
            end
        end ,
    }
    navBar:insert(btRight)








    local title = display.newText{parent=navBar, text=titleText, font=_G.FONTS.light,fontSize=20, width=titleW, align="center"}
    title.x,title.y = background.x, background.y





    -- hiding the bar
    if isHidden then
        navBar.y = -navBar.contentHeight
    else
        navBar.y = _G.TOP_Y_AFTER_STATUS_BAR
    end


    if parent then
        parent:insert(navBar)
    end


    ------------------------------------------------
    --- public functions

    navBar.hide = function(animated)

        if navBar.y == (-navBar.contentHeight) then
            return
        end

        animated = animated or false

        local duration = 200
        if animated == false then
            duration = 0
        end
        transition.to(navBar, {y=-navBar.contentHeight, time=duration})
    end

    navBar.show = function(animated)

        if navBar.y == _G.TOP_Y_AFTER_STATUS_BAR then
            return
        end

        animated = animated or false

        local duration = 200
        if animated == false then
            duration = 0
        end
        transition.to(navBar, {y=_G.TOP_Y_AFTER_STATUS_BAR, time=duration})
    end

    navBar.setTitle = function(obj, newTitle)
        newTitle = newTitle or obj
        title.text = newTitle
    end

    navBar.hideRightButton = function()
        btRight.isVisible = false
    end

    navBar.showRightButton = function()
        btRight.isVisible = true
    end


    navBar.hideLeftButton = function()
        btLeft.isVisible = false
    end

    navBar.showLeftButton = function()
        btLeft.isVisible = true
    end

    navBar.setLeftButtonHandler = function(handler)
        leftButtonHandler = handler
        if handler then
            navBar.showLeftButton()
        else
            navBar.hideLeftButton()
        end
    end

    navBar.enableButtons = function()
        isButtonsDisabled = false
    end

    navBar.disableButtons = function()
        isButtonsDisabled = true
    end


    return navBar

end



return nb