local rb = {}

---------------------------
-- dependencies:
--
-- ragdogLib package (ragdobLib.lua + brush.png) - http://ragdogstudios.com/2014/02/07/dynamic-pie-charts-with-corona-sdk-graphics-2-0/
--
--
--
---------------------------


-- creates newPieChart - v1 ()
rb.new = function(options)

    local parent = options.parent

    local x = options.x
    --local left = options.left      -- positions other than (x,y) are not perfect due to the invisible mask. TOD: to put the whole group inside a Container, or adjust the group.x(.y) position to use the radius instead of the the group size
    --local right = options.right
    local y = options.y
    --local top = options.top
    --local bottom = options.bottom

    local radius = options.radius

    local data = options.data -- { {value=0.7, label="Abc", color={1,0,1}}, {value=0.3, label="Abc", color={1,0,0}} }



    local showLabel = options.showLabel
    local labelFont = options.labelFont or native.systemFont
    local labelFontSize = options.labelFontSize or 16
    local labelFontColor = options.labelFontColor or {1,1,1}

    local group = display.newGroup()

    local totalSum = 0
    local pieData = {}
    for i, d in ipairs(data) do
        totalSum = totalSum + d.value
        pieData[i] = {
            percentage = d.value * 100,
            color = d.color
        }
    end

    if totalSum ~= 1 then
        error("rb-widget: newPieChart data needs to sum 1")
    end

    ----------------------------------------
    -- creating the Pie chart

    local ragdogLib = require "rb-libs.rb-widget.newPieChart-ragdogLib";

    local pie = ragdogLib.createPieChart({
        radius = radius,
        values = pieData
    });
    group:insert(pie)





    ----------------------------------------
    -- Adding labels to the slices


    local getCenterPositionOfSlices = function(pieObj, pieRadius, pieData)

        local radius = pieRadius

        local pieCenterX, pieCenterY = pieObj.x, pieObj.y

        local r = {}
        local sumPercent = 0
        for i, d in ipairs(pieData) do

            local angle = (d.percentage*.5 + sumPercent) * (360/100) -- (100 == total percange)
            local sin = math.sin(angle*math.pi/180)
            local cos = math.cos(angle*math.pi/180)
            local x = radius*sin*.5
            local y = radius*cos*.5
            x = pieCenterX + x
            y = pieCenterY - y
            r[i] = {x = x, y = y }
            sumPercent = sumPercent + d.percentage
        end

        return r

    end



    local positions = getCenterPositionOfSlices(pie, radius, pieData)
    if showLabel then
        for i, p in ipairs(positions) do
            -- local z = display.newCircle(p.x, p.y, 2)
            -- z.fill = {1,0,1}
            print(i, data[i])
            local lb = display.newText{parent=group, text=data[i].label, x=p.x, y=p.y, font=labelFont, fontSize=labelFontSize }
            lb:setTextColor(unpack(labelFontColor))
        end
    end


    ----------------------------------------
    -- positioning

    group.x = x or (left and (left + group.contentWidth*.5)) or (right and (right - group.contentWidth*.5))
    group.y = y or (top and (top + group.contentHeight*.5)) or (bottom and (bottom - group.contentHeight*.5))


    if parent then
        parent:insert(group)
    end


    return group


end

return rb


