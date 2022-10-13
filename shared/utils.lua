InTable = function(tab, val)
	for _, v in ipairs(tab) do
		if v == val then
			return true
		end
	end

	return false
end

ModelsToHashKey = function(tab)
	local result = {}

	for _, model in ipairs(tab) do
		table.insert(result, GetHashKey(model))
	end

	return result
end

resourceName = GetCurrentResourceName()

clientEvent = function(name)
	return resourceName .. ':client:' .. name
end

serverEvent = function(name)
	return resourceName .. ':server:' .. name
end
