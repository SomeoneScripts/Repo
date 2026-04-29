local HttpService: HttpService = game:GetService("HttpService")

-- Compatibility layer for different executors
local isfile: (string) -> boolean = isfile or function(...) return false end
local writefile: (string, string) -> () = writefile or function(...) end
local readfile: (string) -> string = readfile or function(...) return "" end

local Settings: {[string]: any} = {
    Data = {
        Name = "Default User",
        Day = 1,
    },
}

-- Saves the current data to a JSON file
function Settings:Save()
    local success: boolean, err: any = pcall(function()
        local data: string = HttpService:JSONEncode(self.Data)
        writefile("save-file.json", data)
    end)
    
    if not success then
        warn("Failed to save settings: " .. tostring(err))
    end
end

-- Loads settings from the file or creates a new one if it doesn't exist
function Settings:LoadSettings()
    if not isfile("save-file.json") then
        self:Save()
        return
    end
    
    local success: boolean, data: any = pcall(function()
        return HttpService:JSONDecode(readfile("save-file.json"))
    end)
    
    if success and data then
        for key: string, value: any in pairs(data) do
            self.Data[key] = value
        end
    end
end

-- Helper to get a specific value
function Settings:GetFlag(Name: string): any
    return self.Data[Name]
end

-- Helper to set a value and auto-save
function Settings:SetFlag(Name: string, Value: any)
    self.Data[Name] = Value
    self:Save()
end

return Settings
