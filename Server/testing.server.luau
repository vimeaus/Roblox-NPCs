local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NPC = require(ReplicatedStorage.NPC)


task.wait(2)
local Chosen = workspace.Chosen

local Settings:NPCSettings = {

}

NPC.newNPC(Chosen.Humanoid,Settings)
