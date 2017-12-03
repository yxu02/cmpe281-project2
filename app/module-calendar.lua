local mCalendar = {}

mCalendar.currDateString = nil -- we start as today's date (set on the bottom of this file)


local monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
local oneHourInSec = 60*60
local oneDayInSec = 24*oneHourInSec


local getDateTableFromDateString = function(dateString)
	local dp = string.split(dateString,"-")

	local dateTable = {}
	dateTable.day = tonumber(dp[3])
	dateTable.month = tonumber(dp[2])
	dateTable.year = tonumber(dp[1])

	return dateTable
end
mCalendar.getDateTableFromDateString = getDateTableFromDateString


local getDateStringFromDateTable= function(dateTable)
	local day = string.format("%.2d", dateTable.day)
	local month = string.format("%.2d", dateTable.month)
	local year = tostring(dateTable.year)
	return year .. "-" .. month .. "-" .. day
end


mCalendar.getMonthDayFromDateString = function(dateString)
	local dateTable = getDateTableFromDateString(dateString)
	return dateTable.month .. "-" .. dateTable.day
end


mCalendar.getTodayDateString = function()
	local todayTable = os.date("*t")
	return getDateStringFromDateTable(todayTable)
end

mCalendar.getTodayDateTable = function()
	local todayTable = os.date("*t")
	return todayTable
end


mCalendar.getDateForTopBarFromDateString = function(dateString)
	local date = getDateTableFromDateString(dateString)
	jp(date)
	return date.day .. " " .. monthNames[date.month]:sub(1,3) .. " " .. tostring(date.year):right(2)
end


-- receives a date table and increases by the specified amount
mCalendar.increaseDateStringByDays = function(dateString, numOfDays)
	if numOfDays == nil or numOfDays == 0 then return dateString end
	local dateTable = getDateTableFromDateString(dateString)
    local dateTableInSec = os.time(dateTable)

    local endDateInSec = dateTableInSec + oneDayInSec * numOfDays
    local endDateTable = os.date("*t", endDateInSec)

	return getDateStringFromDateTable(endDateTable)
end



----------------
-- RUN CODE

mCalendar.currDateString = mCalendar.getTodayDateString()


return mCalendar