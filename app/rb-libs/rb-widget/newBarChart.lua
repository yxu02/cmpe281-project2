local rb = {}

---------------------------
-- dependencies:
--
-- none
--
--
--
---------------------------


-- creates newBarChar - v1 ()
rb.new = function(options)

    local parent = options.parent

    -- group position
    local top = options.top
    local y = options.y
    local bottom = options.bottom
    local left = options.left
    local x = options.x
    local right = options.right

    local width = options.width
    local height = options.height -- optional, if not set, it will fit the chart size
    local backgroundColor = options.backgroundColor or {0,1,1}

    local title = options.title
    local titleFont = options.titleFont or native.systemFont
    local titleFontSize = options.titleFontSize or 20
    local titleColor = options.titleColor or {0,0,0}

    local data = options.data --  { { key="12/11", values={14, 37, 45}, totalLabel=123 },  { key="12/12", values={14, 37, 45}, totalLabel=92 },
    local axisXDataKey = options.axisXDataKey or "key"
    local axisXFont = options.axisXFont
    local axisXFontSize = options.axisXFontSize or 12
    local valueColors = options.valueColors or { {.2,.2,.2}, {1,0,1}, {0,0,1} } -- in the the same order as passed in the data
    local hideValuesLabel = options.hideValuesLabel
    local columnWidth = options.columnWidth or width*.1


    local margin = 10


    local group = display.newGroup()
    group.anchorChildren = true


    local backgroundH = height or 2
    local background = display.newRect(group, width*.5, backgroundH*.5, width, backgroundH)
    background.fill = backgroundColor
    background.anchorY = 0





    local lbTitle = display.newText{parent=group, text=title, x=width*.5, y=margin, font=titleFont, fontSize=titleFontSize, width=width*0.98, align="center" }
    lbTitle:setTextColor(unpack(titleColor))
    lbTitle.anchorY = 0
    local bottom = lbTitle.y + lbTitle.contentHeight



    local newColumnGroup = function(columnData, axisXKey)

        local xLabel = columnData[axisXKey]
        local yValues = columnData.values
        local totalLabel = columnData.totalLabel
        local yValuesColor = columnData.valuesColors
        local yValuesFontSize = columnData.valuesFontSize or 8
        local valuesLabelSuffix = columnData.valuesLabelSuffix or ""


        local groupCol = display.newGroup()

        if type(yValues) ~= "table" then
            yValues = {yValues}
        end

        yValueMultiplier = yValueMultiplier or 1

        local valueTotal = 0
        if totalLabel == nil then
            for _, v in ipairs(yValues) do
                valueTotal = valueTotal + v
            end
        else
            valueTotal = totalLabel
        end

        local lbTotal = display.newText{parent=groupCol, text=valueTotal, x=columnWidth*.5, y=0, font=native.systemFont, fontSize=12, width=columnWidth, align="center" }
        lbTotal:setTextColor(0,0,0)
        lbTotal.anchorY = 0
        local bottom = lbTotal.y + lbTotal.contentHeight

        for i, v in ipairs(yValues) do
            local value = v*yValueMultiplier
            local bar = display.newRect(groupCol, columnWidth*.5, bottom, columnWidth, value)
            bar.anchorY = 0
            bar.fill = yValuesColor[i] or {0, 0, 0}
            bottom = bar.y + bar.contentHeight

            if not hideValuesLabel then
                local lbValue = display.newText{parent=groupCol, text= value .. valuesLabelSuffix, x=bar.x, y=bar.y + bar.contentHeight*.5, font=native.systemFont, fontSize=yValuesFontSize, width=columnWidth, align="center"  }
                lbValue:setTextColor(1,1,1)
            end
        end

        local lbXAxis = display.newText{parent=groupCol, text=xLabel, x=columnWidth*.5, y=bottom, font=axisXFont, fontSize=axisXFontSize, width=columnWidth, align="center" }
        lbXAxis:setTextColor(0,0,0)
        lbXAxis.anchorY = 0

        return groupCol

    end



    local groupChartContent = display.newGroup()
    group:insert(groupChartContent)
    groupChartContent.y = bottom

    local maxColumnGroupHeight = 0
    for _, d in ipairs(data) do
        local g = newColumnGroup(d, axisXDataKey) -- d[axisXDataKey], d.values, d.totalLabel)
        g.x = groupChartContent.numChildren == 0 and 0 or groupChartContent.contentWidth + 10
        groupChartContent:insert(g)
        maxColumnGroupHeight = math.max(maxColumnGroupHeight,g.contentHeight)
    end

    -- local bbb = display.newRect(0, 0, groupChartContent.contentWidth, groupChartContent.contentHeight)
    -- bbb.anchorX, bbb.anchorY = 0, 0
    -- groupChartContent:insert(bbb)
    -- bbb.fill = {0,.3,.9, .5}
    -- bbb:toBack( )

    -- aligning the bars by the bottom
    for i=1, groupChartContent.numChildren do
        groupChartContent[i].y = maxColumnGroupHeight - groupChartContent[i].contentHeight
    end

    if groupChartContent.contentWidth > width then
        local scrollView = require("widget").newScrollView{
            left = 0,
            top = groupChartContent.y,
            width = width,
            height = groupChartContent.height,
            -- hasBackground = true,
            -- backgroundColor = { 0.8, 0.8, 0.8 },
            horizontalScrollDisabled = false,
            verticalScrollDisabled = true,
            leftPadding = 20,
            rightPadding = 20,
        }
        groupChartContent.x = 0
        groupChartContent.y = 0
        scrollView:insert(groupChartContent, true)
        group:insert(scrollView)
    else
        groupChartContent.x = width*.5 - groupChartContent.contentWidth*.5
    end



    if height == nil then
        background.height = groupChartContent.y + groupChartContent.contentHeight + margin
    end




    -- positioning the group
    group.x = x or (left and (left + group.contentWidth*.5)) or (right and (right - group.contentWidth*.5))
    group.y = y or (top and (top + group.contentHeight*.5)) or (bottom and (bottom - group.contentHeight*.5))

    if parent then
        parent:insert(group)
    end

    return group
end

return rb


