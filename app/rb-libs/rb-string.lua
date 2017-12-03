function string:right(count)

    if count > 0 then
        local len = self:len()
        return string.sub( self, len - count+1, len )
    else -- count < 0 indicates to return the substring less 'count' chars from the left
        return string.sub( self, -count + 1 )
    end
end

function string:left(count)

    if count > 0 then
        return string.sub( self, 1, count )
    else -- count < 0 indicates to return the substring less count chars from the left
        local len = self:len()
        return string.sub( self, 1, len + count )
    end
end

-- this split is not working for pattern "."  (maybe becayse: 'Note that to find . you need to escape it.'')
function string:split( inSplitPattern, outResults )

   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end


function string:findLastOccurence(needle)

    local index = self:reverse():find(needle:reverse(), nil, true)  --Set last argument to 'false' to permit pattern matching
    if index then
        return self:len() - needle:len() - index + 2
    end
    return index

end




-- function: validates a string based on its chars  -  v2
-- retuns:  bool, errorCode (int)
--
--   1   text is empty
--   2   text not has minimum size
--   3   text has invalid char
--   4   email is in a invalid format


function string.validate(text, txtType, minSize, ignoreCharsCheck)
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

