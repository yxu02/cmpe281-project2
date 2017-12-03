local aux = {}
function comma_value(amount) -- source: http://lua-users.org/wiki/FormattingNumbers
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

aux.formatDecimal = function(number)
    return comma_value(number)
end


aux.adjustTextSize = function(textObject, limit)
    local text = textObject.text
    local extraWidth = textObject.width - limit
    local safeGuard = 1  -- variable to safe guard against infinite loop
    if extraWidth > 1  then
        while extraWidth > 1 and safeGuard < 100 do
            local percentReduction = limit / textObject.width
            local totalChars = text:len()
            local charactersToRemove = math.ceil(totalChars * (1-percentReduction) + 3)
            text = text:sub(1,totalChars-charactersToRemove)
            textObject.text = text
            if textObject.width == 0 and text:len() > 0 then -- checking if new width is 0. This may happen if we removed 1 byte of a 2-byte unicode char (like "í"), so in that case, remove 1 byte more
                text = text:sub(1,text:len() - 1)
            end
            text = text .. "..."
            textObject.text = text
            extraWidth = textObject.width - limit
            safeGuard = safeGuard + 1
        end
    end
end


aux.showLoadingAnimation = function(x,y,size)

    local icon = display.newImageRect("images/aux/ic_loading.png", 80, 80)
    if size then
        icon:scale(size/icon.contentWidth, size/icon.contentHeight)
    end
    icon.x = x
    icon.y = y
    icon:setFillColor(1,1,1)

    local transitionId = transition.to( icon, {time=1300*10000, rotation=360*10000} )


    icon.stop = function()
        if transitionId then
            transition.cancel( transitionId )
        end
    end

    return icon

end


local popup = nil
aux.showActivity = function(options)

    if popup then print("a activity group is already on screen!") return end
    options = options or {}


    -- receiving params
    local text = options.text or "[TITLE]"


    -- creating group
    local group = display.newGroup()

    local background = display.newRect(group, display.contentCenterX, display.contentCenterY, SCREEN_W, SCREEN_H)
    background:setFillColor(0,0,0, .8)
    background:addEventListener("touch", function() return true end)
    background:addEventListener("tap", function() return true end)
    group.background = background


    local spinner = aux.showLoadingAnimation(CENTER_X, CENTER_Y, 80)
    group:insert(spinner)
    group.spinner = spinner

    local lb = display.newText{
        text=text,
        x=CENTER_X,
        y=spinner.y + spinner.contentHeight*.5 + 4,
        width=0.9* SCREEN_W,
        font= FONTS.bold,
        fontSize=18,
        align="center"
    }
    group:insert(lb)
    lb:setTextColor(1,1,1)
    lb.anchorY = 0


    -- local function onBtRemoveRelease()

    --     --print("cancelar")
    --     timer.performWithDelay( 30, aux.hideProgressPopup)

    --     if onCancel then
    --         onCancel()
    --     end
    --     return true

    -- end
    -- local btRemoveY = poupBackground.y + poupBackground.contentHeight*.5 - 20
    -- local btRemove = require("custom-widgets").newRemoveButton("cancelar",poupBackground.x, btRemoveY, 120, 30, onBtRemoveRelease)
    -- popupProgress:insert(btRemove)
    -- --btRemove.alpha = 0

    --groupPopupContent:insert(spinner)
    popup = group

    return group
end

aux.hideActivity = function()
    if popup then
        popup.spinner:stop()
        display.remove(popup)
        popup = nil
    end
end


aux.showAlert = function(message, onComplete)

    local listener = function(event)
        if ( event.action == "clicked" ) then
            local i = event.index
            if ( i == 1 ) then
                if onComplete then
                    onComplete()
                end
            end
        end

    end

    native.showAlert("App", message , {"Ok"}, listener)

end



-- function: validates a string based on its chars  -  v2
-- retuns:  bool, errorCode (int)
--
--   1   text is empty
--   2   text not has minimum size
--   3   text has invalid char
--   4   email is in a invalid format


function aux.validateString(text,txtType,minSize, ignoreCharsCheck)
    ----print("running: checkRestrictions for ", text,  " tyoe = ",txtType )
    local charSetList = {
            password = "abcdefghijklmnopqrswtuvxyz0123456789._-@!#$%()*+?",
            username = "abcdefghijklmnopqrswtuvxyz0123456789._-",
            email    = "abcdefghijklmnopqrswtuvxyz0123456789._-@",
            text     = "abcdefghijklmnopqrswtuvxyz 'áéíóúàèìòùãiõñêîôûäëïöü-.",
            firstName     = "abcdefghijklmnopqrswtuvxyz'áéíóúàèìòùãiõñêîôûäëïöüç",
            name     = "abcdefghijklmnopqrswtuvxyz 'áéíóúàèìòùãiõñêîôûäëïöüç-.123456789",
            phone     = "0123456789+ -()",
            birthday     = "0123456789/",
            currency     = "0123456789.,",
            all = "abcdefghijklmnopqrswtuvxyz 'áéíóúàèìòùãiõñêîôûäëïöü-.@!#$%()*+?",
    }

    charSetList.nome = charSetList.firstName
    charSetList.sobrenome = charSetList.name
    charSetList["e-mail"] = charSetList.email
    charSetList.senha = charSetList.password

    if text == nil or text == "" then
        return false, 1
    end

    if minSize then
        if not text or text:len() < minSize then
            return false, 2
        end
    end

    if ignoreCharsCheck == true then
        return true
    end

    local charset = charSetList[txtType or "username"]
    if charset == nil then
        charset = charSetList["username"]
    end

    local lowerText = string.lower(text)
    ----print("testing string ",lowerText)
    for i=1, #lowerText do
        local charNow = lowerText:sub(i,i)
        ----print("lookink for",charNow )

        if charset:find(charNow) == nil then
      --      --print("found invalid")
            return false, 3
        end
    end

    if txtType == "email" or txtType == "e-mail" then
        local textLen = text:len()
        if not text or textLen < 5 then
            return false, 2
        end

        local position
        position = lowerText:find("@",1)
        if not position then -- no "@" found in the string
            return false, 4
        end

        local nextChar = lowerText:sub(position+1, position+1)
        --print("nextChar=", nextChar)
        if nextChar == "." then -- "." right after "@" found
            return false, 4
        end

        position = lowerText:find("@",position+1)
        if position then -- Two "@" found in the string
            return false, 4
        end

        position = lowerText:find(".",1, true)
        if not position then -- no "." found in the string
            return false, 4
        end

        local firstChar = lowerText:sub(1,1)
        if firstChar == "." or firstChar == "@" then  -- starts with "@" or "."
            return false, 4
        end
        local lastChar = lowerText:sub(textLen,textLen)
        if lastChar == "." or lastChar == "@" then  -- finishes with "@" or "."
            return false, 4
        end
    end

    return true
end


return aux

