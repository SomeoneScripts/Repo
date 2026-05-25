local Settings = select(1, ...) 
if Settings and Settings.Sea and Settings.Id then
    local Sea1 = table.find({2753915549, 85211729168715, 113741252407134, 114279672983750}, game.PlaceId)
    local Sea2 = table.find({4442272183, 79091703265657}, game.PlaceId)
    local Sea3 = table.find({7449423635, 100117331123089}, game.PlaceId)
    local currentSea = Sea1 and "1" or Sea2 and "2" or Sea3 and "3" or "Unknown"
    if currentSea == Settings.Sea then
        if game.JobId ~= Settings.Id then
            game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", Settings.Id)
        end
    else
        local queue = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
        if queue then
            queue(([[
                repeat task.wait() until game:IsLoaded()
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "%s")
            ]]):format(Settings.Id))
        end
        local CommF = game:GetService("ReplicatedStorage").Remotes.CommF
        if Settings.Sea == "1" then
            CommF:InvokeServer("TravelMain")
        elseif Settings.Sea == "2" then
            CommF:InvokeServer("TravelDressrosa")
        elseif Settings.Sea == "3" then
            CommF:InvokeServer("TravelZou")
        end
    end
end
