local rb = {}

---------------------------
-- dependencies:
--
-- rb-widget.newButton
--
--
--
---------------------------


-- creates newSwitch - v1 ()
rb.new = function(options)

    -- creates off/on switch
    local parent = options.parent
    local onSwitchTap = options.onSwitchTap
    local w = options.width or options.w or 80 * math.min(40 * _G.GROW_WITH_SCREEN, 80) / 80
    local h = options.height or options.h or 40 * math.min(40 * _G.GROW_WITH_SCREEN, 80) / 80
    local top = options.top
    local left = options.left
    local x = options.x
    local y = options.y
    local right = options.right
    local left = options.left
    local onColor = options.onColor    or {195/255,99/255,70/255,1}
    local offColor = options.offColor  or {120/255,120/255,120/255,1}
    local initialSwitchState = options.initialSwitchState or options.initialValue
    local onBeforeChange = options.onBeforeChange
    local onChange = options.onChange
    local font = options.font or native.systemFont
    local id = options.id
    local disabledAlpha = options.disabledAlpha

    local backgroundOnFilename = options.backgroundOnFilename
    local backgroundOffFilename = options.backgroundOffFilename

    local blockFilename = options.blockFilename
    local blockFillColor = options.blockFillColor or _G.COLORS.brown

    local rotationImageFilename = options.rotationImageFilename or "images/icons/ic-leftArrow.png"
    local rotationImageWidth = options.rotationImageWidth
    local rotationImageHeight = options.rotationImageHeight



    local background
    local block
    local rotationImage


    local group = display.newGroup()

    group.currentStatus = initialSwitchState

    local isTransitioning = false

    local containerLeft
    local containerRight
    local block  -- the object (usually a circle or rectangle) that moves to the sides

    -- switch tap handler
    local function onTap(event, skipBeforeChange)
        if group.enabled == false then return end

        if isTransitioning then return end

        local newStatus = event.newStatus

        if newStatus == nil then
            newStatus = not group.currentStatus
        end
                --print("newStatus=", newStatus)
        -- sets position and color of origin and destination
        print("skipBeforeChange=", skipBeforeChange)
        print("onBeforeChange=", onBeforeChange)
        if not skipBeforeChange and onBeforeChange then
            onBeforeChange({newStatus=newStatus, id=id, target=group},
                function() -- callback function that should be called by the outside onBeforeChange to complete the change
                    onTap(event, true)
                end)
            return
        end



        local newContainerRightW = w
        local newBlockX = block.contentWidth*.5 - w*.5


        if newStatus then
            newContainerRightW = 0
            newBlockX = - block.contentWidth*.5 + w*.5
        end

        -- on finish transition
        local function onFinish(e)
            isTransitioning = false

            if newStatus then
                containerRight.isVisible = false
            end
            group.currentStatus = newStatus
            if onChange and event.ignoreCallBack ~= true then
                onChange({newStatus=newStatus, id=id, target=group})
            end

        end

        -- starts transition
        isTransitioning = true
        --transition.to(block,{x=newX, time=200, onComplete=onFinish})
        containerRight.isVisible = true

        local duration = 1000
        if event.disableAnimation then
            duration = 0
        end

        transition.to(containerRight, {time = duration*.25, width = newContainerRightW})
        transition.to(block, {delay=duration*0.25/3, time = duration*.25/2, x = newBlockX, onComplete=onFinish})
        if rotationImage then
            transition.to(rotationImage, {delay=duration*0.25/3, time = duration*.25/2, x = newBlockX, rotation = rotationImage.rotation + 180, onComplete=onFinish})
        end


    end

    -- public function to allow the user change the status manually
    group.setStatus = function(newStatus, disableAnimation)
        onTap({newStatus=newStatus, ignoreCallBack = true, disableAnimation = disableAnimation} )
    end

    local scaleF = 1
    if _G.GROW_WITH_SCREEN then
        scaleF = (math.min(40 * _G.GROW_WITH_SCREEN, 80) / 80)
    end
    if blockFilename then
        block = display.newImage(group, blockFilename)
        block:scale(scaleF,scaleF)
        block.x = block.contentWidth*.5 - w*.5
        block.y = 0
    else
        block = display.newRect(group, 0, 0, w*.5, h)
        block.x = block.contentWidth*.5 - w*.5
        block.y = 0
        block.fill = blockFillColor
    end



    if rotationImageFilename then
        rotationImage = display.newImage(group, rotationImageFilename)
        --rotationImage.fill = {1,0,0}
        --rotationImage:scale(scaleF,scaleF)
        rotationImage.x = block.x
        rotationImage.y = block.y
    end

    -- container behaves as regular newRect (by default it uses anchorX, anchorY = .5, .5.)
    containerLeft = display.newContainer(group, w, h)
    containerLeft.anchorX = 0
    containerLeft.anchorChildren = false -- this is to affect the container children, not the container itself
    containerLeft.x = - w*.5
    containerLeft.y = 0

    local backgroundOn
    if backgroundOnFilename then
        backgroundOn = display.newImage(containerLeft, backgroundOnFilename)
        backgroundOn:scale(scaleF,scaleF)
        backgroundOn.anchorX = 0
        backgroundOn.x = 0
    else
        backgroundOn = display.newRect(containerLeft, 0, 0, w, h)
        backgroundOn:scale(scaleF,scaleF)
        backgroundOn.anchorX = 0
        backgroundOn.x = 0
    end

    containerRight = display.newContainer(group, w, h)
    containerRight.anchorX = 1
    containerRight.anchorChildren = false -- this is to affect the container children, not the container itself
    containerRight.x = w*.5
    containerRight.y = 0

    local backgroundOff
    if backgroundOff then
        backgroundOff = display.newImage(containerRight, backgroundOffFilename)
        backgroundOff:scale(scaleF,scaleF)
        backgroundOff.anchorX = 1
    else
        backgroundOff = display.newRect(containerRight, 0, 0, w, h)
        backgroundOff:scale(scaleF,scaleF)
        backgroundOff.anchorX = 0
        backgroundOff.x = 0
    end

    group:insert(block)
    if rotationImage then
        group:insert(rotationImage)
    end


    --group.setStatus(true)
    --timer.performWithDelay( 5000, function() group.setStatus(false) end)



    backgroundOn:addEventListener( "tap", onTap )



    -- block that moves
    if initialSwitchState then
         containerRight.width = 0
         block.x = - block.contentWidth*.5 + w*.5
    end

    -- makes the group obey the anchor of the default system
    group.anchorChildren = true


    -- sets the position of the switch
    group.x = x or (right and (right - w*.5)) or (left and (left + w*.5))
    group.y = y

    if parent then
        parent:insert(group)
    end

    function group:setEnabled(isEnabled)
        group.enabled = isEnabled
        if disabledAlpha then
            if isEnabled then
                backgroundOff.alpha = 1
                backgroundOn.alpha = 1
            else
                if group.currentStatus then
                    backgroundOff.alpha = 0
                    backgroundOn.alpha = disabledAlpha
                else
                    backgroundOff.alpha = disabledAlpha
                    backgroundOn.alpha = 0
                end

            end
        end
    end


    return group


end

return rb


