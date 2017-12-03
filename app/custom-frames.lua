local frames = {}

frames.newSection = function(options)

	local parent = options.parent
	local labelLeft = options.labelLeft or options.label
	local labelMid = options.labelMid
	local labelRight = options.labelRight
	local labelFontRight = options.labelFontRight or _G.FONTS.regular
	local top = options.top
	local isHeader = options.isHeader

	local backgroundColor =  _G.COLORS.white --{1,math.random(1,244)/255, 4}--
	local labelColor = _G.COLORS.black
	if isHeader then
		backgroundColor = _G.COLORS.blue
		labelColor = _G.COLORS.white
	end


	local col3W = 100
	local col2W = 80
	local col1W = _G.SCREEN_W - col2W - col3W



	local group = display.newGroup()

	local backgroundH = 40
	local background = display.newRect( group, _G.SCREEN_W*.5, backgroundH*.5, _G.SCREEN_W, backgroundH )
	background.fill = backgroundColor

	if labelRight then
		local lb = display.newText{parent=group, text=labelRight or "[RIGHT]", x=SCREEN_W - col3W*.5, y=backgroundH*.5, font=labelFontRight, fontSize=18 }
		lb:setTextColor(unpack(labelColor))
	end

	if labelMid then
		local lb = display.newText{parent=group, text=labelMid or "[MID]", x=col1W + col2W*.5, y=backgroundH*.5, font=_G.FONTS.regular, fontSize=18 }
		lb:setTextColor(unpack(labelColor))
	end

	if labelLeft then
		local lb = display.newText{parent=group, text=labelLeft or "[LEFT]", x=_G.MARGIN_W, y=backgroundH*.5, font=_G.FONTS.regular, fontSize=18 }
		lb.anchorX = 0
		lb:setTextColor(unpack(labelColor))
	end

	if top then
		group.y = top
	elseif parent then
		group.y = parent.contentHeight
	end
	if parent then
		parent:insert(group)
	end


	return group

end

frames.newPieLegend = function(options)
	local parent = options.parent
	local x = options.x
	local y = options.y

	local group = display.newGroup()

	local data = {
		{label="Carbs", color = _G.COLORS.carb},
		{label="Fat", color = _G.COLORS.fat},
		{label="Protein", color = _G.COLORS.protein},
	}

	local sqW = 14
	local top = 0
	for k, v in ipairs( data ) do
		local sq = display.newRect(group,sqW*.5,top + sqW*.5,sqW,sqW)
		sq.fill = v.color
		local lb = display.newText{parent=group, text=v.label, x=sq.x + sq.contentWidth*.5 + 10, y=sq.y, font=_G.FONTS.light, fontSize=12 }
		lb.anchorX = 0
		lb:setTextColor(unpack(_G.COLORS.black))
		top = sq.y + sq.contentHeight*.5 + 4
	end

	group.x = x - group.contentWidth*.5
	group.y = y - group.contentHeight*.5

	if parent then
		parent:insert(group)
	end
	return group
end


return frames