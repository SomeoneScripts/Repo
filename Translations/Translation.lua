local Translations = {
	Language = string.sub(game:GetService("LocalizationService").SystemLocaleId, 1, 2):lower(),
	Data = {},
	Files = {
		["pt"] = "Portuguese"
	}
}
if Translations.Files[Translations.Language] then
	Translations.Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneScripts/Repo/refs/heads/main/Translations/Languages/" .. Translations.Files[Translations.Language] .. ".lua"))()
end
function Translations.Get(Text, ...)
	local Args = {...}
	local GameTable = Translations.Data[tostring(game.GameId)]
	local Translated = GameTable and GameTable[Text] or Text
	if #Args > 0 then
		for i, v in ipairs(Args) do
			Translated = string.gsub(Translated, "{" .. i .. "}", tostring(v))
		end
	end
	return Translated
end
return Translations