function UpdateCheck()
	PerformHttpRequest('https://api.github.com/repos/Gittified/null_offroad/releases/latest', function(code, response)
		local data = json.decode(response)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

		if data.tag_name ~= currentVersion then
			print('^3An update is available for null_offroad (current version: ' ..
				currentVersion .. ')\r\n' .. data.html_url .. '^0')
		end
	end, 'GET')
end
