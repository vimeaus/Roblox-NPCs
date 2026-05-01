--Copyright 2026 vimeaus

-- Pathfinding implementation of A in 2d

-- Allows for the use of ramps or stairs with limited height difference between nodes. 
-- No height is taken into account when defining the start or end node of the path, thus the path may lead above or below a 3d target position.

--!native

--# Types

type node = {

}

type heap = {

}

--# Heap

local nodeHeapClass = {}
nodeHeapClass.__index = nodeHeapClass

local function createHeap() 
    return setmetatable({},heapClass)
end

--# Node

local nodeClass = {}
nodeClass.__index = {}

local function createNode()
    return setmetatable({},nodeClass)
end

--# Pathing

local Pathing = {}

function Pathing.ComputePath(StartPosition:Vector3|Vector2,EndPosition:Vector3|Vector2,Config)

end



return Pathing


