local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view


    local mealId = event.params and event.params.mealId
    local dateString = event.params and event.params.dateString
    local onClose = event.params and event.params.onClose

    local background = display.newRect(sceneGroup, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
    background.fill = _G.COLORS.darkBlue


    local closeScreen = function()
        composer.hideOverlay( "slideDown", 400 ); TABBAR.show(true)
        if onClose then
            onClose()
        end
    end

    ------------------------------------------------------------------
    -- top bar

    local topBar = require("module-topBar").new{
        title="Add Food/Drink",
        parent=sceneGroup,
        isHidden=false,
        rightButtonHandler = closeScreen,
        useCloseRightButton = true,
    }
    topBar:hideLeftButton()
    local bottom = topBar.contentBounds.yMax

    local sceneTop = topBar.contentBounds.yMax
    local cw = require("custom-widgets")

    ------------------------------------------------------------------
    -- search

    local inputSearch = _G.CW.newTextField({
        x = CENTER_X,
        top = sceneTop,
        placeholder = "Type product here",
        -- onRelease = function(e)
        --     print(e, e.target.text)
        --     sceneGroup.searchProduct(e.target.text)
        -- end,
        width=SCREEN_W*0.6,

    })
    sceneGroup:insert(inputSearch)
    bottom = inputSearch.y + inputSearch.contentHeight*.5


    local btSearch = RBW.newButton{
        left = inputSearch.x + inputSearch.contentWidth*.5 + 4,
        y = inputSearch.y,
        width = 60,
        height = inputSearch.contentHeight,
        label = "search",
        labelColor = { 1, 1, 1 },
        labelOverColor = { 0, 0, 0, 0.5 },
        labelAlign = "center",

        backgroundColor = _G.COLORS.green,
        backgroundOverColor = _G.COLORS.overlay("green"),
        backgroundDisabledColor = {.3,.3,.3},
        labelFont = _G.FONTS.light,
        labelFontSize = 14,
        scrollViewParent = scrollViewParentFunction,
        onRelease  = function(e)
            local searchText = inputSearch:getText()
            sceneGroup.searchProduct(searchText)
        end,
        onTap = function() print("tapped"); return true end
    }
    sceneGroup:insert(btSearch)





    local btCameraRelease = function()

        print("on btCameraRelease")

        local function onComplete( event )
           local photo = event.target

           if photo then
                local filename = "tempImage.jpg"
                display.save(photo, { filename=filename, baseDir=system.TemporaryDirectory, isFullResolution=true, backgroundColor={0,0,0,0} })
                display.remove(photo)
                sceneGroup.searchProductViaImage(filename)
            end

        end

        if media.hasSource( media.Camera ) then
            media.capturePhoto( { listener=onComplete } )
        else
            native.showAlert( "App", "This device does not have a camera.", { "OK" } )
        end

    end

    local btCamera = RBW.newButton{
        right = inputSearch.x - inputSearch.contentWidth*.5 - 4,
        y = inputSearch.y,
        width = 60,
        height = inputSearch.contentHeight,

        imageFilename = "images/icons/ic-camera.png",
        imageWidth = "40",
        imageHeight = "33",
        imageFillColor = {1,1,1},
        imageOverColor = {1,1,1,.5},
        -- backgroundColor = _G.COLORS.green,
        -- backgroundOverColor = _G.COLORS.overlay("green"),
        -- backgroundDisabledColor = {.3,.3,.3},

        scrollViewParent = scrollViewParentFunction,
        onRelease  = function(e)

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
                    rationaleDescription = "We need the Camera to take photo of a food",
                    listener = function()
                        callBack()
                    end,
                } )
            end


            requirePermissionCamera(btCameraRelease)

        end,
        onTap = function() print("tapped"); return true end
    }
    sceneGroup:insert(btCamera)

    ------------------------------------------------------------------
    -- search


    local listGroupContent = {}
    sceneGroup.listGroupContent = listGroupContent

    local groupContent = display.newGroup()
    sceneGroup:insert(groupContent)


    -- creating tableView to show list
    local widget = require( "widget" )

    local function onRowRender( event )

        -- Get reference to the row group
        local row = event.row
        local rowH = row.contentHeight

        local rowData = tableViewData[row.index]
        row._data = rowData

        local lb = display.newText{parent=row, text=rowData.name, x=_G.MARGIN_W, y=rowH*.5, font=_G.FONTS.regular, fontSize=20 }
        lb:setTextColor(unpack(_G.COLORS.black))
        lb.anchorX = 0

    end

    -- Create the widget
    local tvTop = bottom + 10
    local tvH = SCREEN_H - tvTop
    local tableView = widget.newTableView{
            left = 0,
            top = tvTop,
            height = tvH,
            width = SCREEN_W,
            hideBackground = false,
            backgroundColor = _G.COLORS.white,
            --noLines = true,
            hideScrollBar = true,
            onRowRender = onRowRender,
            onRowTouch = function(e)
                if e.phase == "tap" or e.phase == "release" then
                    --pt(e.row._data, "data=")
                    local rowData = e.row._data
                    --composer.removeScene( "scene-detail" )
                    --composer.gotoScene("scene-detail",{effect="slideLeft", time=400, params={fileObj=rowData}})
                    sceneGroup.showPopup(rowData)

                    return true
                end
            end,
            --listener = scrollListener,
            topPadding = 10,
            bottomPadding = 50,
        }
    sceneGroup:insert(tableView)
    sceneGroup.tableView = tableView

    local function updateTableViewData(data)

        display.remove( sceneGroup.lbNoData )

        tableViewData = data
        tableView:deleteAllRows()


        if #data==0 then
            sceneGroup.lbNoData = display.newText{parent=sceneGroup, text = "No products found.", x=CENTER_X, y=CENTER_Y, fontSize=24, width=SCREEN_W*.9, align="center" }
            sceneGroup.lbNoData.fill = _G.COLORS.black
        end


        -- inserting rows
        for i = 1, #data do
            -- Insert a row into the tableView
            tableView:insertRow{
                --rowHeight = 100,
                rowHeight = 40,
                rowColor =  { default={1,1,1,0}, over={1,0.5,0,0} },
            }
        end



    end

    sceneGroup.searchProduct = function(name)
        native.setActivityIndicator( true )

        _G.SERVER.searchFood(name,
            function(data)
                native.setActivityIndicator( false )
                updateTableViewData(data)
            end,
            function()
                native.setActivityIndicator( false )
                _G.AUX.showAlert("Failed to search product. Please try again later.")
         end)
    end


    sceneGroup.searchProductViaImage = function(filename)

       _G.SERVER.imageReko(filename,
            function(data)
                native.setActivityIndicator( false )
                updateTableViewData(data)
            end,
            function()
                native.setActivityIndicator( false )
                _G.AUX.showAlert("Failed to search product using AWS Rekognition. Please try again later.")
         end)
    end


    sceneGroup.showPopup = function(productObj)

        local group = display.newGroup()

        local overlay = display.newRect(group, CENTER_X, CENTER_Y, SCREEN_W, SCREEN_H)
        overlay.fill = _G.COLORS.overlay("black", 0.7)
        overlay:addEventListener( "tap",
            function()
                timer.performWithDelay(30, function()
                display.remove(group)
                return true
            end)
            return true
        end)
        overlay:addEventListener( "touch",
            function(e)
                if e.phase == "release" then
                    timer.performWithDelay(30, function()
                    display.remove(group)
                    return true
                end)
            end
            return true
        end)



        local groupPopup = display.newGroup()

        local background = display.newRect(groupPopup, CENTER_X, 0, SCREEN_W*.9, 10)
        background.fill = _G.COLORS.darkBlue
        background.anchorY = 0
        background:addEventListener( "tap", function() return true end)
        background:addEventListener( "touch", function() return true end)


        local lbTitle = display.newText{parent=groupPopup, text=productObj.name, x=background.x, y=20, font=_G.FONTS.regular, fontSize=24 }
        lbTitle:setTextColor(unpack(_G.COLORS.white))
        lbTitle.anchorY = 0



        local lbNumOfServing = display.newText{parent=groupPopup, text="Count", x=background.x, y=lbTitle.y + lbTitle.contentHeight + 20, font=_G.FONTS.regular, fontSize=20 }
        lbNumOfServing:setTextColor(unpack(_G.COLORS.white))
        lbNumOfServing.anchorY = 0
        local bottom = lbNumOfServing.y + lbNumOfServing.contentHeight


        local inputServingQty = _G.CW.newTextField({
            x = CENTER_X,
            top = bottom + 20,
            isHalfWidth = true,
            onRelease = function(e)
                print(e, e.target.text)
                --sceneGroup.searchProduct(e.target.text)
            end

        })
        groupPopup:insert(inputServingQty)
        bottom = inputServingQty.y + inputServingQty.contentHeight*.5


        local lbServingSize = display.newText{parent=groupPopup, text="Unit", x=background.x, y=bottom + 20, font=_G.FONTS.regular, fontSize=20 }
        lbServingSize:setTextColor(unpack(_G.COLORS.white))
        lbServingSize.anchorY = 0
        bottom = lbServingSize.y + lbServingSize.contentHeight

        local sliderButtonServingSize = _G.RBW.newSliderButton({
            top = bottom + 4,
            height = 40,
            width = background.contentWidth,
            buttons = { {name="grams"}, {name="oz"}, {name="ml"},  },
            onSelect =  function (e)
                print("onSliderButton=",e.target.name)
                --local catID = e.target.Id
            end,
            initialIndex = 1,
        })
        groupPopup:insert(sliderButtonServingSize)
        bottom = sliderButtonServingSize.y + sliderButtonServingSize.contentHeight


        local btAddHandler = function()
            native.setActivityIndicator( true )

            local servingQty = inputServingQty:getText()
            local servingSize = sliderButtonServingSize:getSelected()


            if servingSize == "oz" then
                servingQty = _G.CONVERTER.toMetric(servingQty, "oz")
                servingSize = "grams"
            end


            _G.SERVER.addFood(productObj.name, servingQty, servingSize, mealId, dateString,
                function(data)
                    native.setActivityIndicator( false )
                    timer.performWithDelay(100, function()
                        _G.AUX.showAlert("Product added!")
                        display.remove(group)
                        closeScreen()
                    end)
                end,
                function()
                    native.setActivityIndicator( false )
                    _G.AUX.showAlert("Failed to add product. Please try again later.")
             end)
        end

        local btAdd = CW.newGreenButton{
            parent = groupPopup,
            x = CENTER_X,
            top = bottom + 20,
            label = "add",
            onRelease = btAddHandler
        }


        background.height = btAdd.y + btAdd.contentHeight*.5 + 20

        groupPopup.y = CENTER_Y - groupPopup.contentHeight*.5

        group:insert(groupPopup)

        return group
    end







end



function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

     elseif ( phase == "did" ) then


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