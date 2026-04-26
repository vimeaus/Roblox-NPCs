--Copyright 2026 vimeaus

--[[

An NPCHandler aimed at abstracting & encapsulating NPC pathing while improving on current Roblox implementations. 
New pathfinding types and other improvements can be expected in the future. 
I recommend using the NPC class as a superclass, and adding any other NPC implementations you want (besides movement) into a new class.


]]


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
    Move : (self:NonPlayerCharacter,Destination:(Vector3|Vector2),NPCSetting:NPCSettings) -> boolean,
    Cancel : (self:NonPlayerCharacter) -> boolean,
    Stop : (self:NonPlayerCharacter) -> boolean,
    Pause : (self:NonPlayerCharacter) -> boolean,
    Wait : (self:NonPlayerCharacter) -> boolean,
    Continue : (self:NonPlayerCharacter) -> boolean,
    Destroy : (self:NonPlayerCharacter) -> nil,
}

--# Variables
local ActiveNPCs : {NonPlayerCharacter:boolean?} = {} --+ Dicts instead of lists, for membership testing and is iterable (order is irrelevant)
local InactiveNPCs : {NonPlayerCharacter:boolean?} = {}

local HandlerThread = nil
--# Local Functions

local function handlerLoop()

    while true do
        task.wait()

        


    end

end

--# Classes

--+ Defining the methods and properties of a NPC
local NPC = {}

--? Moves the NPC to the given destination utilizing the NPC's pathing type. | The moving & path calculation is Asynchronous.
function NPC.Move(self,Destination:Vector3|Vector2)
    assert(Destination,"Cannot move NPC when no destination is provided!")

end

--? Cancels the respective NPC's pathing, causing it to finish its current movement, but stopping on the next path 'node'. 
function NPC.Cancel(self) : boolean --+ False if not currently pathing (nothing to cancel), true if successfully cancelled.
end

--? Cancels the respective NPC's pathing, ceasing any movement immediately. 
function NPC.Stop(self) : boolean --+ False if not currently pathing (nothing to stop), true if successfully cancelled.
end

--? Interrupts the respective NPC's pathing, ceasing any movement, but being able to continue using :Continue()
function NPC.Pause(self) : boolean --+ False if not currently pathing (nothing to pause), true if successfully paused.
end

--? Interrupts the respective NPC's pathing, causing it to finish its current movement, but pausing on the next path 'node'. 
function NPC.Wait(self,TimeLimit:number) : boolean --+ False if not currently pathing (nothing to wait), true if successfully paused.
end

--? Continues the NPC's path in the case it was paused using :Pause() or :Wait(), if already moving or no path is assigned, nothing will happen. 
function NPC.Continue(self) : boolean --+ False if no path to continue, otherwise always true. 
end

--? The appropiate way to destroy an NPC object.
function NPC.Destroy(self) : nil
end

--+ Defining the methods and properties of the NPC Handler
local NPCHandler = {}

--? Creates a new NonPlayerCharacter object from the provided humanoid and settings.
function NPCHandler.newNPC(Humanoid:Humanoid,Settings:NPCSettings?):Object
    if not Settings then
        Settings = {}
    end
    if not HandlerThread then
        HandlerThread = coroutine.create(handlerLoop)
        coroutine.resume(HandlerThread)
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
