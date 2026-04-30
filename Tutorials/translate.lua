local LocalizationService: LocalizationService = game:GetService("LocalizationService")
local Players: Players = game:GetService("Players")

local Translate: {[string]: any} = {
	Translations = { -- More country codes at https://create.roblox.com/docs/en-us/reference/engine/classes/LocalizationService#GetCountryRegionForPlayerAsync
		["BR"] = {
			["hello"] = "Olá",
			["help"] = "Ajuda",
		},
	},
}

function Translate:Translate(Text: string): string
	local success: boolean, country: any = pcall(function()
		return LocalizationService:GetCountryRegionForPlayerAsync(Players.LocalPlayer)
	end)

	if success then
		local data: {[string]: string} = self.Translations[country]
		if data then
			return (data[Text and Text:lower()] or Text)
		else
			return Text
		end
	else
		error("Could not access country: " .. tostring(country))
	end
end

return Translate
