local getcustomasset: (string, boolean?) -> string = (getcustomasset or function(...) return ... end) :: any
local isfile: (string) -> boolean = (isfile or function() return false end) :: any
local writefile: (string, string) -> () = (writefile or function() end) :: any

-- Transforms an image/audio link into a valid rbxassetid using the executor's file system
local function GetIcon(link: string): string
	local file_name: string = tostring(link):gsub("%p", "")
	if not isfile(file_name) then
		local success: boolean, bytes: any = pcall(function()
			return game:HttpGet(link)
		end)
		if success and type(bytes) == "string" then
			writefile(file_name, bytes)
		else
			error("Could not access link: " .. tostring(bytes))
		end
	end
	local rbx: string = getcustomasset(file_name)
	return rbx
end

return GetIcon
