--Copyright 2026 vimeaus

--# Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--# Modules
local ImplementationFolder = ReplicatedStorage.Pathing
local APathfinding2d = require(ImplementationFolder.APathfinding2d)

--# Types
export type NPCSettings = {
    PathfindingType:"APathfinding2d"?,
    Size:Vector3,
}

export type NonPlayerCharacter = {
    --Properties
    State : string,
    Destination : (Vector3|Vector2)?,
    PathfindingType : string,
    Size : Vector3,
    Humanoid : Humanoid,

    --Methods
    Move : (NonPlayerCharacter,(Vector3|Vector2)?,NPCSettings) -> boolean,
    Cancel : (NonPlayerCharacter) -> boolean,
    Stop : (NonPlayerCharacter) -> boolean,
    Pause : (NonPlayerCharacter) -> boolean,
    Wait : (NonPlayerCharacter) -> boolean,
    Continue : (NonPlayerCharacter) -> boolean,
    Destroy : (NonPlayerCharacter) -> nil,

}

--# Variables
local ActiveNPCs = {}
local AllNPCs = {}

--# Local Functions


--# Classes

--+ Defining the methods and properties of a NPC
local NPC = {}

--? Moves the NPC to the given destination utilizing the NPC's pathing type. -The moving is Asynchronous.
function NPC.Move(self,Destination:Vector3|Vector2)
    if not Destination then
       return
    end



end

--? Cancels the respective NPC's pathing, causing it to finish its current movement, but stopping on the next path 'node'. 
function NPC.Cancel(self)
end

--? Cancels the respective NPC's pathing, ceasing any movement immediately. 
function NPC.Stop(self)
end

--? Interrupts the respective NPC's pathing, ceasing any movement, but being able to continue using :Continue()
function NPC.Pause(self)
end

--? Interrupts the respective NPC's pathing, causing it to finish its current movement, but pausing on the next path 'node'. 
function NPC.Wait(self)
end

--? Continues the NPC's path in the case it was paused using :Pause() or :Wait(), if already moving or no path is assigned, nothing will happen. 
function NPC.Continue(self)
end

--? The appropiate way to destroy an NPC object, will remove any related data to ensure no memory leaks. 
function NPC.Destroy(self)
end

--+ Defining the methods and properties of the NPC Handler
local NPCHandler = {}

function NPCHandler.newNPC(Humanoid:Humanoid,Settings:NPCSettings?):Object
    if not Settings then
        Settings = {}
    end

    local newNPC = {}
    newNPC.State = "Idle"
    newNPC.Humanoid = Humanoid
    newNPC.Destination = nil
    newNPC.PathfindingType = Settings["PathfindingType"]
    newNPC.Size = Settings.Size or Vector3.new(1,1,1)
    return setmetatable(newNPC,NPC::NonPlayerCharacter)
end

 



return NPCHandler
