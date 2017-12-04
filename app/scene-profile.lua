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


    local groupContent = display.newGroup()
    groupContent.y = bottom + 10
    sceneGroup:insert(groupContent)


    --local function showPhotoFromURL(url)
    local photo
    local photoW = 94
    local photoH = 100
    local photoTop = 0
    print("USER.avatarFilename=", USER.avatarFilename, USER.id)
    if _G.USER.avatarFilename then
        local url = "http://www.cmpe281.site/" .. USER.avatarFilename;
        photo = display.loadImageFromInternet{

            imageURL=url,
            imageWidth=photoW, --256/3,
            imageHeight=200, --256/3,
            showSpinner = photoH,
            keepAspectRatio = true,
            imageFilename = _G.USER.id .. ".jpg",
            imageBaseDir = system.DocumentsDirectory,
            onComplete=function()
                native.setActivityIndicator( false )
            end
        }
        groupContent:insert(photo)
        photo.x, photo.y = CENTER_X, photo.y + photoH*.5
        sceneGroup.photoObj = photo
        bottom = photo.y + photoH*.5
    else
        local btPhoto
        local btPhotoRelease = function()

            print("on btCameraRelease")

            local function onComplete( event )
               local photo = event.target

               if photo then
                    local filename = _G.USER.id .. ".jpg"
                    display.save(photo, { filename=filename, baseDir=system.DocumentsDirectory, isFullResolution=true, backgroundColor={0,0,0,0} })
                    --display.remove(photo)

                    local scaleFactor = photoH/photo.contentHeight
                    photo:scale(scaleFactor, scaleFactor)
                    photo.x = btPhoto.x
                    photo.y = btPhoto.y
                    groupContent:insert(photo)
                    SERVER.uploadAvatar(filename)
                end

            end

            if media.hasSource( media.Camera ) then
                media.capturePhoto( { listener=onComplete } )
            else
                native.showAlert( "App", "This device does not have a camera.", { "OK" } )
            end

        end

        btPhoto = RBW.newButton{
            x = CENTER_X,
            top = photoTop,
            imageFilename = "images/buttons/bt-avatar.png",
            imageWidth = 100,
            imageHeight = 94,
            onRelease = function()


                local function requirePermissionCamera(callBack)
                    print("on requirePermissionCamera")
                    local hasAccessToCamera, hasCamera = media.hasSource( media.Camera )
                    if hasAccessToCamera then
                        print( "Has camera permission!" )
                        return callBack()
                    end

                    -- Make the actual request from the user.
                    native.showPopup( "requestAppPermission", {
                        appPermission = "Camera",
                        urgency = "Critical",
                        rationaleTitle = "This app uses Camera",
                        rationaleDescription = "We need the Camera to take photo your photo",
                        listener = function()
                            callBack()
                        end,
                    } )
                end


                requirePermissionCamera(btPhotoRelease)

            end
        }
        groupContent:insert(btPhoto)
        bottom = btPhoto.y + btPhoto.contentHeight*.5
    end



    local lbName = display.newText{parent=groupContent, text=_G.USER.name or "[Full name]", x=_G.CENTER_X, y=bottom + 10, font=_G.FONTS.regular, fontSize=24 }
    lbName:setTextColor(unpack(_G.COLORS.black))
    lbName.anchorY = 0
    bottom = lbName.y + lbName.contentHeight


    local groupPref = display.newGroup()
    groupContent:insert(groupPref)
    groupPref.y = bottom + 20

    local groupPreferencesHeader = FRAMES.newSection{parent=groupPref, top = 0, labelLeft="Preferences", isHeader=true}
    bottom = groupPreferencesHeader.y + groupPreferencesHeader.contentHeight


    local groupUnits = FRAMES.newSection{parent=groupPref, top = nil, labelLeft="Units", labelRight="Lbs / inch", labelFontRight=_G.FONTS.light}

    local groupLanguage = FRAMES.newSection{parent=groupPref, top = nil, labelLeft="Language", labelRight="English", labelFontRight=_G.FONTS.light}
    bottom = groupPref.y + groupPref.contentHeight

    local groupAccount = display.newGroup()
    groupContent:insert(groupAccount)
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

    local svH = SCREEN_H - TABBAR.contentHeight - topBar.contentBounds.yMax
    print("svH=", svH, groupContent.contentHeight)
    --if groupContent.contentHeight > svH then

        local scrollView = require("widget").newScrollView{
            left = 0,
            top = topBar.contentBounds.yMax,
            width = _G.SCREEN_W,
            height = svH,
            hasBackground = false,
            horizontalScrollDisabled = true,
            bottomPadding = 20,
        }
        groupContent.y = 10
        scrollView:insert(groupContent)
        sceneGroup:insert(scrollView)
        sceneGroup.scrollView = scrollView
    --end



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