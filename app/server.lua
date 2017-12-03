local server = {}

--------------------------------------------------------
-- customize your server info here
local serverURL = "http://cmpe281.site/"
local serverURL = "http://localhost:9000/"

local apiKey = "y7NmuLoBr34Vu-jGrz296Bgn3Dg2zpOpsTy21s8nH";

 -- converts a table from to a string format
local paramToString = function(paramsTable)
    local str = ""
    local i = 1

    for paramName,paramValue in pairs(paramsTable) do
        --print(paramName .. ": " .. paramValue)
        if i == 1 then
            str = paramName .. "=" .. paramValue
        else
            if type(paramValue) == "boolean" then
                if paramValue then
                    paramValue = 1
                else
                    paramValue = 0
                end
            end
            str = str .. "&" .. paramName .. "=" .. paramValue
        end
        i=i+1
    end

    return str
end
server._paramToString = paramToString

-- function that gets a JSON from a server
local function getJSON(endpoint, parameters, onCompleteDownload, method, onProgress, silentRequest )

    local method = method or "POST"

    local url = serverURL .. endpoint

    parameters = parameters or {}
    parameters.userid = _G.USER.id
    parameters.apiKey = apiKey
print("_G.USER.id=", _G.USER.id)

    local function showDownloadErroAlert()
        native.setActivityIndicator( false )
         -- Handler that gets notified when the alert closes
            local function onComplete( event )
               if event.action == "clicked" then
                    local i = event.index
                    if i == 1 then
                        -- Retrying....
                        getJSON(endpoint, params, onCompleteDownload)
                        return
                    elseif i == 2 then
                        local composer = require "composer"
                        if composer.getSceneName( "current" ) ~= "scene-login" then
                            composer.gotoScene( "scene-login", {effect="slideLeft", time=400} )
                        end

                        return --native.requestExit()
                    end
                end
            end
            if silentRequest ~= true then
                BUTTONS_DISABLED = false
                local alert = native.showAlert( "Oopps", "Something went wrong trying to communicate with the server." , { "Try again", "I will try again later" }, onComplete )
            end

    end

    local function networkListener( event )
        print( "on networkListener - ", event.isError, event.status, event.phase,event.response )
        local result, data, errorMessage = false, nil, nil
        if ( event.isError  or (event.phase == "ended" and event.status ~= 200)) then
            print( "Network error! - ", event.isError, event.status, event.phase,event.response )
            native.setActivityIndicator( false )
            errorMessage = "Something went wrong trying to communicate with the server."

            return showDownloadErroAlert()


        elseif ( event.phase == "began" ) then
            if ( event.bytesEstimated <= 0 ) then
                print( "Download starting, size unknown" )
            else
                print( "Download starting, estimated size: " .. event.bytesEstimated )
            end

        elseif ( event.phase == "progress" ) then
            if ( event.bytesEstimated <= 0 ) then
                print( "Download progress: " .. event.bytesTransferred )
            else
                print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
            end
            if onProgress then
                local percentComplete = nil
                if event.bytesTransferred and event.bytesEstimated and event.bytesEstimated > 0 then
                    percentComplete = event.bytesTransferred / event.bytesEstimated
                end
                onProgress(percentComplete)
            end

        elseif ( event.phase == "ended" ) then

            --print("Network ok. Now let's decode the JSON")
            local response = event.response  --:gsub("&#8211;", "-")  -- manually replacing a HTML code for its chair
            --print("response=", response)
            local data = require("json").decode(response)


            if data == nil or type(data) ~= "table" then
                print("Data is not a valid JSON")
                showDownloadErroAlert()
                return

            end


            if data["errorCode"] == 4 then
                -- token expired move user to login screen
                native.setActivityIndicator( false )
                _G.USER.logout(true)

                return
            end
            --print("data.success=", data.success)
            --print("data.success=", data[1].success)
            --print("result=", result)
            onCompleteDownload(data, event)
        end

    end


    local headers = {}
    local params = {}

    if method == "MULTIPART" then
        method = "POST"


        headers["Content-Type"] = "multipart/form-data; boundary=" .. parameters.boundary
        headers["Content-Length"] = #parameters.body

        params.body = parameters.body
        params.bodyType = "binary"
        params.progress = "upload"

    elseif method == "POST" then
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        params.body = paramToString(parameters)
    else
        headers["Content-Type"] = "application/json"
        url = url .. "?" .. paramToString(parameters)
    end

    params.headers = headers
    params.timeout = 30
    if onProgress then
        params.progress = "upload"
    end
print("body=")
print(params.body)
    print("url=", url)
    network.request( url, method, networkListener, params)


end





----------------------------------------



server.register = function(name, email, password, age, gender, onSuccess, onFail)

    local params = {}
    params["name"] = name
    params["email"] = email
    params["password"] = password
    params["age"] = age and tonumber(age)
    params["gender"] = gender

    getJSON("register.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    jp(data)
                    -- storing the user info
                    --USER.setToken(data.token)
                    USER.new(data.id, name, email, age, gender)

                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end

server.login = function(email, password, onSuccess, onFail)

    local params = {}
    params["email"] = email
    params["password"] = password

    getJSON("login.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    -- storing the user info
                    USER.new(data.id,data.name,data.email,data.age, data.gender)

                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end




server.getHistoricalData = function(onSuccess, onFail)
    local params = {}

    getJSON("historicalData.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then

                    local dataWeight = data.weight
                    _G.STORAGE.setWeightData(dataWeight)


                    local nutritionData = data.nutritionData
                    local userFoodData = data.food
                    for k, foodsInDay in pairs(userFoodData) do
                        for _, v in ipairs(foodsInDay) do
                            local nt = nutritionData[v.foodId]
                            if nt then
                                v.carb = (nt.carb / nt.measure) * v.count
                                v.fat = (nt.fat / nt.measure) * v.count
                                v.protein = (nt.protein / nt.measure) * v.count
                                v.fiber = (nt.fiber / nt.measure) * v.count
                                v.water = (nt.water / nt.measure) * v.count
                                v.calories = (nt.calories / nt.measure) * v.count

                            else
                                print("Not found Nutrition Data for Food id=", v.foodId)
                                v = nil
                            end
                        end
                    end
                    _G.STORAGE.setFoodData(userFoodData)


                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end


server.searchFood = function(searchText, onSuccess, onFail)
    local params = {}
    params.food_name = searchText

    -- onSuccess({
    --     {id=1, name="Bananas", imageURL = "http://www.google.com",  imageThumbnailURL= "http://dxvygm1r8ogog.cloudfront.net/z.png"},
    --     {id=2, name="Bananas Organic", imageURL = "http://www.google.com",  imageThumbnailURL= "http://dxvygm1r8ogog.cloudfront.net/z.png"},
    --     {id=3, name="Bananas Raw", imageURL = "http://www.google.com",  imageThumbnailURL= "http://dxvygm1r8ogog.cloudfront.net/z.png"},
    -- })
    -- if true then return end

    getJSON("searchFood.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    -- storing the user info
                    -- USER.id = data.id
                    -- USER.level = data.level
                    -- USER.balance = tonumber(data.balance)
                    -- USER.saveToken(data.token)
                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end


server.addFood = function(productName, servingQty, servingSize, mealId, dateString, onSuccess, onFail)
    local params = {}
    params.foodName = productName
    params.count = servingQty
    params.unit = servingSize
    params.mealId = mealId
    params.date = dateString

    -- onSuccess({
    -- })
    -- if true then return end

    getJSON("addFood.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    jp(data)
                    -- storing the user info
                    -- USER.id = data.id
                    -- USER.level = data.level
                    -- USER.balance = tonumber(data.balance)
                    -- USER.saveToken(data.token)
                    server.getHistoricalData()

                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end

server.addWeight = function(weight, dateString, onSuccess, onFail)
    local params = {}
    params.weight = weight
    params.dateMeasured = dateString or _G.CALENDAR.getTodayDateString()


    -- onSuccess({
    -- })
    -- if true then return end

    getJSON("addWeight.php",
            params,
            function(data)
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    -- storing the user info
                    -- USER.id = data.id
                    -- USER.level = data.level
                    -- USER.balance = tonumber(data.balance)
                    -- USER.saveToken(data.token)
                    _G.STORAGE.appendWeight(weight, dateString)
                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end,
            "POST",  -- method
            nil,     -- onProgress
            true)    -- silentRequest

end

-- server.uploadObject = function(filename, description, isUpdate, useTransferAcceleration, onSuccess, onFail)

--     local params = {}
--     params["filename"] = filename
--     params["description"] = description
--     params["isUpdate"] = isUpdate
--     params["useTransferAcceleration"] = useTransferAcceleration



--     getJSON("upload.php",
--             params,
--             function(data)
--                 local success = data.errorCode == nil
--                 print("sucess=", success)
--                 if success then
--                     if onSuccess then
--                         onSuccess(data)
--                     end
--                 else
--                     if onFail then
--                         onFail(data.errorMessage, data.errorCode)
--                     end
--                 end

--             end,
--             "POST",  -- method
--             nil,     -- onProgress
--             true)    -- silentRequest

-- end


server.upload = function(filename, description, isUpdate, useTransferAcceleration, onSuccess, onFail)


    --local filename = "large.jpg" --"large.jpg"

    if isUpdate then isUpdate = 1 else isUpdate = 0 end
    if useTransferAcceleration then useTransferAcceleration = 1 else useTransferAcceleration = 0 end

    local path = system.pathForFile( filename, system.DocumentsDirectory )
    local file = io.open(path, "r")
    local contents = file:read( "*a" )

    local boundary = "BOUNDARY_APP_"..os.time()  -- can be any random string

    local params = {}

    params["body"] = '--'..boundary..
            '\r\nContent-Disposition: form-data; name=fileObject; filename='..filename..
            '\r\nContent-type: image/jpg'..
            '\r\n\r\n'..contents..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=filename'..
            '\r\n\r\n'..filename..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=token'..
            '\r\n\r\n'.._G.USER.token..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=isUpdate'..
            '\r\n\r\n'..isUpdate..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=useTransferAcceleration'..
            '\r\n\r\n'..useTransferAcceleration..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=apiKey'..
            '\r\n\r\n'..apiKey..
            '\r\n--'..boundary..
            '\r\nContent-Disposition: form-data; name=description'..
            '\r\n\r\n'..description..
            '\r\n--'..boundary..'--\r\n';


    params["boundary"] = boundary


    native.setActivityIndicator( true )
    getJSON("upload.php", params, function(data)
                native.setActivityIndicator( false )
                local success = data.errorCode == nil
                print("sucess=", success)
                if success then
                    -- storing the user info
                    -- USER.id = data.id
                    -- USER.level = data.level
                    -- USER.balance = tonumber(data.balance)
                    -- USER.saveToken(data.token)
                    if onSuccess then
                        onSuccess(data)
                    end
                else
                    if onFail then
                        onFail(data.errorMessage, data.errorCode)
                    end
                end

            end, "MULTIPART")


end


return server