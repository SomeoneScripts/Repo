local Cache = select(1, ...)
local CollectionService = game:GetService("CollectionService")

function Cache.Enemies:AddEnemy(enemy)
 local enemyName = enemy.Name
 if not self[enemyName] then
  self[enemyName] = {}
 end
 self[enemyName][enemy] = true
end
 
function Cache.Enemies:RemoveEnemy(enemy)
 local enemyName = enemy.Name
 if self[enemyName] and self[enemyName][enemy] then
  self[enemyName][enemy] = nil
  if next(self[enemyName]) == nil then
   self[enemyName] = nil
  end
 end
end
 
function Cache.Enemies:Init()
 for _, enemy in ipairs(CollectionService:GetTagged("BasicMob")) do
  self:AddEnemy(enemy)
 end
 CollectionService:GetInstanceAddedSignal("BasicMob"):Connect(function(enemy)
  self:AddEnemy(enemy)
 end)
 CollectionService:GetInstanceRemovedSignal("BasicMob"):Connect(function(enemy)
  self:RemoveEnemy(enemy)
 end)
end
 
Cache.Enemies:Init()
