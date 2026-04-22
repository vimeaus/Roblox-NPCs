--Copyright 2026 vimeaus

--# Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--# Modules
local ImplementationFolder = ReplicatedStorage.Pathing
local APathfinding2d = require(ImplementationFolder.APathfinding2d)

--# Types
type NPCSettings = {
    PathfindingType:"APathfinding2d"?,
    Size:Vector3,
}

--# Variables
local ActiveNPCs = {}
local AllNPCs = {}

--# Local Functions


--# Classes

--+ Defining the methods and properties of a NPC
local NPC = {}

function NPC.Move(self,Destination:Vector3|Vector2)
    if not Destination then
       return
    end



end

--+ Defining the methods and properties of the NPC Handler
local NPCHandler = {}

function NPCHandler.newNPC(Humanoid:Humanoid,Settings:NPCSettings?):Object
    if not Settings then
        Settings = {}
    end

    local newNPC = {}
    newNPC.State = "Idle"
    newNPC.Destination = nil
    newNPC.PathfindingType = Settings["PathfindingType"]
    newNPC.Size = Settings.Size or Vector3.new(1,1,1)
    return setmetatable(newNPC,NPC)
end





return NPCHandler
