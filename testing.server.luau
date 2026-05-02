local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NPC = require(ReplicatedStorage.NPC)



task.wait(2)
local Chosen = workspace.Chosen

local Settings:NPC.NPCSettings = {

}

NPC.newNPC(Chosen.Humanoid,Settings)

NPC.Move(Vector3.new(15,15,15))
