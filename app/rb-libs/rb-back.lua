------------------------------------------
-- Red Beach Library
-- Library: BackLib
-- v 0.43
--
--
-- Dependencies:
--  . rb-queue
--
------------------------------------------
--
--    How to use:
--
--    1) Require the rb-back in the main file (e.g _G.BACK = require "rb-back")
--    2) Optional: Creates the default back button by calling the setBackButton(params). Params are the normal widget button params
--    3) Call the addPreviousScene() function in the enterScene of each scene that should have a backButton or handle the android Hardware Key  (e.g. _G.BACK.addPreviousScene())





-------------------------------------------------------
-- back key handling functionality
-------------------------------------------------------

local rb = {}


local queue = require "rb-libs.rb-queue"        -- creates a LIFO queue to store the scenes and it params
rb.lastGoToSceneArgs = {}               -- will temporarily store the last scenes params used
rb.lastSceneThatAddBackWasCalled = nil  -- will temporarily store the last scene when addBack was called
rb.lastGoToSceneIsBack = nil            -- flag that indicates if the goToScene is a back movement or not
rb.externalBackFuction = nil            -- external function defined by the user to serve as the "normal" back behavior


-- list of opposite effect to be used when going to back scene

local oppositeEffects = {}

oppositeEffects.zoomOutIn = "zoomInOut"
oppositeEffects.zoomInOut = "zoomOutIn"
oppositeEffects.zoomOutInFade = "zoomInOutFade"
oppositeEffects.zoomInOutFade = "zoomOutInFade"
oppositeEffects.zoomOutInRotate = "zoomInOutRotate"
oppositeEffects.zoomInOutRotate = "zoomOutInRotate"
oppositeEffects.zoomOutInFadeRotate = "zoomInOutFadeRotate"
oppositeEffects.zoomInOutFadeRotate = "zoomOutInFadeRotate"
oppositeEffects.fromRight = "slideRight"
oppositeEffects.fromLeft = "slideLeft"
oppositeEffects.fromTop = "slideUp"
oppositeEffects.fromBottom = "slideDown"
oppositeEffects.slideLeft = "slideRight"
oppositeEffects.slideRight = "slideLeft"
oppositeEffects.slideUp = "slideDown"
oppositeEffects.slideDown = "slideUp"


local composer = require("composer")


local backHandlerList = {}
local standardBack
local backButton



local goToBackScene = function()

    native.setKeyboardFocus( nil ) -- hiding keyboard

    -- if the user defined a external function to server as back, call it. This will not impact the queue scenes
    if rb.externalBackFuction then
        print("lets call user custom back function")
        rb.externalBackFuction()
        return true
    end

    if rb.backButton then
        rb.backButton.isVisible = false
    end


    local lastVisitedScene = queue.pop() -- gets the last scene visited (that had the addBack function called)

    if lastVisitedScene == nil then print("no previous scene was added - please double check flow"); return end

    if lastVisitedScene.options == nil then
        lastVisitedScene.options = {}
    end
    lastVisitedScene.options.isBack = true


    -- will call our intercept function below
    composer.gotoScene(lastVisitedScene.name, lastVisitedScene.options, true)

    return true
    -- local tabBarButtonIndex = _G.tabBar and _G.tabBar.getButtonIndexFromSceneName(lastVisitedScene.name)
    -- _G.tabBar.highlightIndex(tabBarButtonIndex)

end


local function getOppositeEffect(effect)
    if effect == nil then
        return nil
    end

    local oppositeEffect = oppositeEffects[effect]

    return oppositeEffect or effect

end



-----
-- onKeyEvent: handles the hardware button on android devices
-- @param event
-- @return

local onKeyEvent = function( event )
    --print("running: aux, onKeyEvent - keyName:", event.keyName, " - keyPhase: ", event.phase)

    if event.keyName == "back" then
        local returnValue = false       -- use default key operation

        local currentSceneName = composer.getSceneName( "current" ) -- or composer.getSceneName( "overlay" )

        if rb.lastSceneThatAddBackWasCalled ~= currentSceneName then
            return returnValue

        end

        if event.phase == "up" then
            returnValue = goToBackScene()
        end
        --print("returnValue=", returnValue)
        return returnValue
    end
end


-- Intercepts the gotoScene so it can store what kind of transition effect is being used
rb.gotoScene = composer.gotoScene
composer.gotoScene = function(sceneName, options)
    --print("entrou na gotoScene custom")
    rb.lastGoToSceneArgs.sceneName = sceneName
    rb.lastGoToSceneArgs.options = options

    if options then
        rb.lastGoToSceneIsBack = options.isBack
    else
        rb.lastGoToSceneIsBack = false
    end


    -- continue going to next scene
    rb.gotoScene(sceneName, options)

end


---------------------------------
-- PUBLIC FUNCTIONS
---------------------------------


-- makes the goToBackScene function public if the user wants to call it (e.g, uses as a buttonHandler)
rb.goToBackScene = goToBackScene
rb.goBack = goToBackScene


---------------------
-- addBack: this fuction adds the current storyboard scene to queue. Just call this function at the enterScene function of the scene (not call it on the createScene!!)
-- @param backSceneParams:  Optional. Extra params to be passed to the back scene
-- @return
rb.addPreviousScene = function(showButton, backSceneParams)
--print("added Back")
    if showButton == nil then
        showButton = true
    end


    local previousScene = composer.getSceneName( "previous" ) --storyboard.getCurrentSceneName()

    local currentScene =  composer.getSceneName( "current" ) -- composer.getSceneName( "overlay" ) or
    print("scene being added to queue=", previousScene)
    if previousScene == nil then
        --print("addBack function being called by a scene that has no previous. Please check that")
    end
    --print("rb.lastGoToSceneIsBack=", rb.lastGoToSceneIsBack)
    if queue.getLastItem() ~= previousScene and  rb.lastGoToSceneIsBack ~= true then

        local backSceneOptions = {}
        if currentScene == rb.lastGoToSceneArgs.sceneName and rb.lastGoToSceneArgs.options then -- user called addBack in a scene that was the expected to be next
            backSceneOptions.effect = getOppositeEffect(rb.lastGoToSceneArgs.options.effect)
            backSceneOptions.time = rb.lastGoToSceneArgs.options.time
        end
        backSceneOptions.params = backSceneParams  -- any custom params that user wants to be sent to the "back" scene

        queue.push({ name = previousScene, options = backSceneOptions })
    elseif rb.lastGoToSceneIsBack then
        print("goToScene is Back. Not adding to back queue")

    else
        print("addBack - Tried to add the same scene to queue. Ignoring it")
    end

    if rb.backButton then
        rb.backButton.isVisible = showButton
    end

    if queue.getLastItem() == nil then
        --print("back queue is empty. Hiding Back button")
        if rb.backButton then
            rb.backButton.isVisible = false
        end

    end

    rb.lastSceneThatAddBackWasCalled = currentScene

    rb.externalBackFuction = nil -- cancel any external function that was used as the normal back behavior

end


---------------------------------------------------------------
-- setBackButton: create the backButton to be used in the scenes
-- @param params: normal widget newButton params PLUS: rotation = xx (makes the button rotates)
-- @return
rb.setBackButton = function(params)
    params = params or {}

    local widget = require "widget"

    -- setting some default params
    params.left = params.left or _G.LEFT_X or 10
    params.top = params.left or _G.TOP_Y or 10
    params.onRelease = function() goToBackScene() end
    params.defaultFile = params.defaultFile


    rb.backButton = widget.newButton(params)

    rb.backButton.isVisible = false

    -- rotates the button
    rb.backButton.rotation = params.rotation or 180
    if params.y then
    rb.backButton.y = params.y
    end

end


rb.hideBackButton = function()
    rb.backButton.isVisible = false
end



rb.showBackButton = function()
    rb.backButton.isVisible = true
end

--------------------
-- setBackFunction: overrides the back function of this lib. This should be used to hide a group pop or something like that. If you just want to link your backButton to this lib, do NOT use this function. Use instead the function rb.goToBackScene as your buttonHanlder
-- @param externalBackFunction: external function defined by the user to serve as the "normal" back behavior
-- @return
rb.setBackFunction = function(externalBackFunction)
    rb.externalBackFuction = externalBackFunction
end

------------------
-- cancelBackFunction: cancel the override back function to this lib
rb.cancelBackFunction = function()
    rb.externalBackFuction = nil
end



rb.clearData = function()

    queue.clear()

end



Runtime:addEventListener( "key", onKeyEvent )

return rb


