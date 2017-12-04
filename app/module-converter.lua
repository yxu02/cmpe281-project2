local mConverter = {}

local dicToMetric = {}
dicToMetric["lbs"] = 453.59 -- 1lbs == 453.59 grams
dicToMetric["oz"] = 28.35 -- 1oz == 29.574 ml


local dicToImperial = {}
dicToImperial["grams"] = 1/453.59 -- 1grams == 1/453.59 oz
dicToImperial["ml"] = 1/28.35 -- 1ml == 1/29.574 oz


mConverter.getConvertedWeight = function(value, unit)



end


mConverter.toMetric = function(value, valueUnit)
	local convertedValue =  value * (dicToMetric[valueUnit] or 1)
	return convertedValue
end

mConverter.toImperial = function(value, valueUnit)
	--print("mConverter.toImperial-", value, valueUnit)
	if valueUnit == "gm" then
		valueUnit = "grams"
	end
	--print("dicToImperial[valueUnit]=", dicToImperial[valueUnit])
	local convertedValue =  value * (dicToImperial[valueUnit] or 1)
	--print("from ", value, " to ", convertedValue)
	return AUX.formatDecimal(convertedValue, 4)
end


return mConverter