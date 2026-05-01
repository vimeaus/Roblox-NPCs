--Copyright 2026 vimeaus

-- Pathfinding implementation of A in 2d

-- Allows for the use of ramps or stairs with limited height difference between nodes. 
-- No height is taken into account when defining the start or end node of the path, thus the path may lead above or below a 3d target position.

--!native

--# Types

export type Config = {

}

type node = {
    Position:Vector3,
    Cost:number,
    TravelCost:number,
    PreviousNode:node?
}

type heap = { 
    _raw:{node}?,

    Pop : (heap) -> node,
    Insert : (heap, node) -> nil,
}

--# Min heap | very simple implementation for A

local nodeHeapClass = {}
nodeHeapClass.__index = nodeHeapClass

local function SiftUp(heapArray:{node})
    local currentIndex = #heapArray

    while true do
        local current = heapArray[currentIndex]
        
        local parentIndex = math.floor(currentIndex/2)
        if heapArray[currentIndex].Cost > heapArray[parentIndex].Cost then
            break
        end

        heapArray[currentIndex],heapArray[parentIndex] = heapArray[parentIndex],heapArray[currentIndex]
        
        if parentIndex == 1 then
            break
        end

        currentIndex = parentIndex
    end
end

local function SiftDown(heapArray:{node})
    local size = #heapArray
    local currentIndex = 1

    while true do
        local current = heapArray[currentIndex]

        local nextIndex = currentIndex
        local leftIndex = currentIndex * 2 
        local rightIndex  = currentIndex * 2 + 1

        if leftIndex <= size and heapArray[leftIndex].Cost < heapArray[nextIndex].Cost then
            nextIndex = leftIndex
        end

        if rightIndex <= size and heapArray[rightIndex].Cost < heapArray[nextIndex].Cost then
            nextIndex = rightIndex
        end

        if currentIndex == nextIndex then 
            break
        end

        heapArray[currentIndex],heapArray[nextIndex] = heapArray[nextIndex],heapArray[currentIndex]
        currentIndex = nextIndex
    end
end

function nodeHeapClass.Pop(self) : node
    if #self._raw <= 0 then
        return nil
    end

    if #self._raw == 1 then
        table.remove(self._raw,1)
        return self._raw[1]
    end

    local popped = self._raw[1]
    local last = table.remove(self._raw,#self._raw)
    self._raw[1] = last
    SiftDown(self._raw)
end

function nodeHeapClass.Insert(self,Node:node) : nil
    table.insert(self._raw,Node)
    SiftUp(self._raw)
end

local function createHeap() 
    local Heap = {}
    Heap._raw = {}
    return setmetatable(Heap,nodeHeapClass)
end

--# Node

local function createNode(Position, Cost, TravelCost, PreviousNode)
    local Node = {}
    Node.Position = Position
    Node.Cost = Cost
    Node.TravelCost = TravelCost
    Node.PreviousNode = PreviousNode
    return Node
end

--# Local Functions

local function getAdjacentPositions(Position:Vector2,Precision:number,Diagonals:boolean) : {Vector2}

    local adjacent = {
        Position + Vector2.new(0,1),
        Position + Vector2.new(0,-1),
        Position + Vector2.new(1,0),
        Position + Vector2.new(-1,0)
    }

    if Diagonals then
        for i = -1,1,2 do
            for j = -1,1,2 do
                table.insert(adjacent,Position+Vector2.new(i,j))
            end
        end
    end
end

local function inverseList(list:{}) : nil
    local size = #list
    local clone = table.clone(list)
    for i = 1,size,1 do
        list[i] = clone[size - i + 1]
    end
end

local function tracePath(node:node) : {node}
    local inversedPath = {}
    
    local current:node = node
    while current.PreviousNode do
        table.insert(inversedPath,current)
        current = node.PreviousNode
    end

    inverseList(inversedPath)
end

--# Pathing

local Pathing = {}

function Pathing.ComputePath(StartPosition:Vector3|Vector2,EndPosition:Vector3|Vector2,Config:{}?)
    Config = Config or {} :: Config

    if typeof(StartPosition) == "Vector3" then
        StartPosition = Vector2.new(StartPosition.X,StartPosition.Z)
    end
    if typeof(EndPosition) == "Vector3" then
        EndPosition = Vector2.new(EndPosition.X,EndPosition.Z)
    end

    local MinHeap:heap = createHeap()
    local FirstNode:node = createNode(StartPosition, 0, 0, nil)
    
    local current:node = FirstNode
    while true do
        current= MinHeap:Pop()

        if current.Position == EndPosition then
            break
        end

        local adjacent = getAdjacentPositions(current.Position, Config.Precision or 1, Config.Diagonals or false)
        for _,position in adjacent do
            local travelCost = (position - current.Position).Magnitude + current.TravelCost
            local cost = travelCost + (position - EndPosition).Magnitude
            local newNode = createNode(position, cost, travelCost, current)
            MinHeap:Insert(newNode)
        end
    end

    local path = tracePath(current)

    return path
end

return Pathing


