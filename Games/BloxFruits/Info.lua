local Info = {
 Elite = {"Deandre", "Diablo", "Urban"}
 Katakuri = {Boss = {"Cake Prince", "Dough King"}, Enemies = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}, Cocoa = {"Chocolate Bar Battler", "Cocoa Warrior"}},
 Ectoplasms = {Boss = "Cursed Captain", Enemies = {"Ship Deckhand", "Ship Engineer", "Ship Officer", "Ship Steward"}},
 Bones = {Boss = "Soul Reaper", Enemies = {"Demonic Soul", "Living Zombie", "Posessed Mummy", "Reborn Skeleton"}},
 Eagle = {Boss = "Tyrant of the Skies", Enemies = {"Isle Outlaw", "Island Boy", "Isle Champion", "Sun-kissed Warrior", "Serpent Hunter", "Skull Slayer"}},
}
function Info:DefeatedTikiOutpostBoss()
 return game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineWorkerSpeak"):InvokeServer("AskKilledTikiBoss")
end
function Info:IsQuestVisible()
 return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Quest").Visible
end
function Info:IsInQuestTitle(Text)
 local Text = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Quest"):WaitForChild("Container"):WaitForChild("QuestTitle"):WaitForChild("Title").Text
 if not Text then return end
 local Texts = typeof(Text) == "string" and {Text} or Text
 for _, text in ipairs(Texts) do
  if Text:lower():find(text:lower()) then
   return true
  end
 end
 return
end
return Info
