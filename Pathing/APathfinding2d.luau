--Copyright 2026 vimeaus

-- Pathfinding implementation of A in 2d

-- Allows for the use of ramps or stairs with limited height difference between nodes.
-- No height is taken into account when defining the start or end node of the path, thus the path may lead above or below a 3d target position.

--!native

--# Types

export type Config = {}

type node = {
	Position: Vector3,
	Cost: number,
	TravelCost: number,
	PreviousNode: node?,
}

type heap = {
	_raw: { node }?,

	Pop: (heap) -> node,
	Insert: (heap, node) -> nil,
}

--# Min heap | very simple implementation for A

local nodeHeapClass = {}
nodeHeapClass.__index = nodeHeapClass

local function SiftUp(heapArray: { node })
	local currentIndex = #heapArray

	while true do
		local current = heapArray[currentIndex]

		local parentIndex = math.floor(currentIndex / 2)
		if heapArray[currentIndex].Cost > heapArray[parentIndex].Cost then
			break
		end

		heapArray[currentIndex], heapArray[parentIndex] = heapArray[parentIndex], heapArray[currentIndex]

		if parentIndex == 1 then
			break
		end

		currentIndex = parentIndex
	end
end

local function SiftDown(heapArray: { node })
	local size = #heapArray
	local currentIndex = 1

	while true do
		local current = heapArray[currentIndex]

		local nextIndex = currentIndex
		local leftIndex = currentIndex * 2
		local rightIndex = currentIndex * 2 + 1

		if leftIndex <= size and heapArray[leftIndex].Cost < heapArray[nextIndex].Cost then
			nextIndex = leftIndex
		end

		if rightIndex <= size and heapArray[rightIndex].Cost < heapArray[nextIndex].Cost then
			nextIndex = rightIndex
		end

		if currentIndex == nextIndex then
			break
		end

		heapArray[currentIndex], heapArray[nextIndex] = heapArray[nextIndex], heapArray[currentIndex]
		currentIndex = nextIndex
	end
end

function nodeHeapClass.Pop(self): node
	if #self._raw <= 0 then
		return nil
	end

	if #self._raw == 1 then
		table.remove(self._raw, 1)
		return self._raw[1]
	end

	local popped = self._raw[1]
	local last = table.remove(self._raw, #self._raw)
	self._raw[1] = last
	SiftDown(self._raw)
end

function nodeHeapClass.Insert(self, Node: node): nil
	table.insert(self._raw, Node)
	SiftUp(self._raw)
end

local function createHeap()
	local Heap = {}
	Heap._raw = {}
	return setmetatable(Heap, nodeHeapClass)
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

--? Checks if the adjacent position is reachable.
local function checkForValidAdjacentPosition(PreviousPosition: Vector3, Position: Vector3, Epsilon): Vector3?
	local RP = RaycastParams.new()
	local direction = Position - PreviousPosition

	local result: RaycastResult = workspace:Raycast(PreviousPosition, Vector3.new(0, 1, 0), RP)

	--? No ground underneath the node?
	if not result then
		return nil
	end

	result = workspace:Raycast(PreviousPosition, direction, RP)

	--? No direct line available? Possible ramp?
	if result then
		if Epsilon == 0 then
			return nil
		end

		--? Is there a line if the unit moves up a little? ramp or stairs?
		result = workspace:Raycast(PreviousPosition, direction + Vector3.new(0, Epsilon, 0), RP)
		if result then
			return nil
		else
			return Position + Vector3.new(0, Epsilon, 0)
		end

	--? Direct line available to node
	else
		return Position
	end
end

--? Retrieves all adjacent position based on the precision of the algorithm (distance of nodes), and if diagonals are accepted.
local function getAdjacentPositions(Position: Vector3, Precision: number, Config: Config): { Vector2 }
	local adjacent = {}

	for i = -Precision, Precision do
		for j = -Precision, Precision do
			if math.abs(i) == math.abs(j) then
				if i == 0 or not Config.Diagonals then
					continue
				end
			end

			local neighborPosition = Position + Vector3.new(i, 0, j)
			local validPosition = checkForValidAdjacentPosition(Position, neighborPosition, Config.Epsilon or 0)

			if validPosition then
				table.insert(adjacent, validPosition)
			end
		end
	end
end

local function inverseList(list: {}): nil
	local size = #list
	local clone = table.clone(list)
	for i = 1, size, 1 do
		list[i] = clone[size - i + 1]
	end
end

local function tracePath(node: node): { node }
	local inversedPath = {}

	local current: node = node
	while current.PreviousNode do
		table.insert(inversedPath, current)
		current = node.PreviousNode
	end

	inverseList(inversedPath)
end

--# Pathing

local Pathing = {}

function Pathing.ComputePath(StartPosition: Vector3, EndPosition: Vector3, Config: {}?)
	Config = Config or {} :: Config

	local MinHeap: heap = createHeap()
	local FirstNode: node = createNode(StartPosition, 0, 0, nil)

	local current: node = FirstNode
	while true do
		current = MinHeap:Pop()

		if current.Position == EndPosition then
			break
		end

		local adjacent = getAdjacentPositions(current.Position, Config.Precision or 1, Config.Diagonals or false)

		for _, Position in adjacent do
			local travelCost = (Position - current.Position).Magnitude + current.TravelCost
			local cost = travelCost + (Position - EndPosition).Magnitude
			local newNode = createNode(Position, cost, travelCost, current)
			MinHeap:Insert(newNode)
		end
	end

	local path = tracePath(current)

	return path
end

return Pathing
