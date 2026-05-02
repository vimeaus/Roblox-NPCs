--Copyright 2026 vimeaus

--[[

An NPCHandler aimed at abstracting & encapsulating NPC pathing while improving on current Roblox implementations. 
New pathfinding types and other improvements can be expected in the future. 
I recommend using the NPC class as a superclass, and adding any other NPC implementations you want (besides movement) into a new class.


]]

--# Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")


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
    State : number,
    Destination : Vector3?,
    Config : Config,
    Humanoid : Humanoid,

    --Methods
    Move : (self:NonPlayerCharacter,Destination:Vector3,NPCSetting:NPCSettings) -> boolean,
    Cancel : (self:NonPlayerCharacter) -> boolean,
    Stop : (self:NonPlayerCharacter) -> boolean,
    Pause : (self:NonPlayerCharacter) -> boolean,
    Wait : (self:NonPlayerCharacter) -> boolean,
    Continue : (self:NonPlayerCharacter) -> boolean,
    Destroy : (self:NonPlayerCharacter) -> nil,
}

export type Config = ({} | APathfinding2d.Config)?

--# Variables

local ActiveNPCs : {NonPlayerCharacter:boolean?} = {} --+ Dicts instead of lists, for membership testing and is iterable (order is irrelevant)
local InactiveNPCs : {NonPlayerCharacter:boolean?} = {}

local HandlerThread = nil

--# Local Functions

local function handlerLoop()

    RunService.Heartbeat:Connect(function(deltaTime)
        
    end)

end

--# Classes

--+ NPC Class
local NPC = {}
NPC.__index = NPC

--? Moves the NPC to the given destination utilizing the NPC's pathing type. | The moving & path calculation is Asynchronous.
function NPC.Move(self,Destination:Vector3)
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

--+ NPC Handler
local NPCHandler = {}

--? Creates a new NonPlayerCharacter object from the provided humanoid and settings.
function NPCHandler.newNPC(Humanoid:Humanoid,Config:NPCSettings?):Object
    if not Config then
        Config = {}
    end
    
    if not HandlerThread then
        HandlerThread = coroutine.create(handlerLoop)
        coroutine.resume(HandlerThread)
    end

    local newNPC = {}
    newNPC.State = 0
    newNPC.Humanoid = Humanoid
    newNPC.Destination = nil
    newNPC.Config = Config
    return setmetatable(newNPC,NPC::NonPlayerCharacter)
end

 



return NPCHandler
