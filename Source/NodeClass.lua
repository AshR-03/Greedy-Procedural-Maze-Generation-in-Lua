local nodeClass = {}
nodeClass.__index = nodeClass

-- Class to store information on each cell.
function nodeClass.new(i, j, w, h, boardW, boardH)
	local self = setmetatable({}, nodeClass)
	self.i = i
	self.j = j
	
	self.x = j * w
	self.y = i * w
	
	self.wallColour = Color3.new(0.207843, 0.207843, 0.207843)
	
	if self.x == w and self.y == w then
		self.wallColour = Color3.new(0.207843, 0.207843, 0.207843)
	end
	
	self.w = w
	self.boardW = boardW
	self.boardH = boardH
	
	self.h = h
	self.stroke = 3
	
	self.visited = false
	
	self.walls = {}
	return self
end

-- Change the wall colours
function nodeClass:changeWallColours()
	for i, v in pairs(self.walls) do
		v.Color = Color3.new(0.207843, 0.207843, 0.207843)
	end
end

-- Spawn the walls in the correct world position.
function nodeClass:spawnWalls()
	--TOP WALL
	self:createWall(Vector3.new(self.w,self.h, self.stroke), Vector3.new(self.x, 0, self.y - self.w/2), "TOP")
	--LEFT WALL
	self:createWall(Vector3.new(self.stroke,self.h, self.w), Vector3.new(self.x - self.w/2, 0, self.y), "LEFT")
	--BOTTOM WALL
	self:createWall(Vector3.new(self.w,self.h, self.stroke), Vector3.new(self.x, 0, self.y + self.w/2), "BOTTOM")
	--RIGHT WALL
	self:createWall(Vector3.new(self.stroke,self.h, self.w), Vector3.new(self.x + self.w/2, 0, self.y), "RIGHT")
end

-- Create a single wall instance.
function nodeClass:createWall(size, position, name)
	local wall = Instance.new("Part")
	wall.CanCollide = false
	wall.Anchored = true
	wall.Name = name
	wall.Size = size
	wall.Position = position
	wall.CanCollide = true
	wall.Parent = game.Workspace
	wall.Color = self.wallColour
	wall.Material = Enum.Material.SmoothPlastic
	table.insert(self.walls, wall)
end

-- Create the node index for the stack.
function nodeClass:calculateStackNodeIndex(i ,j)
	if i < 1 or j < 1 or i > self.boardW or j > self.boardH then
		return "nil"
	end
	return (j + (i-1) * self.boardW)
end

-- Check the neighbouring nodes to see if visited.
function nodeClass:checkNeighbours(nodes)
	local neighbours = {}
	
	local bottom = nodes[self:calculateStackNodeIndex(self.i, self.j+1)]
	
	local left = nodes[self:calculateStackNodeIndex(self.i-1, self.j)]
	
	local top = nodes[self:calculateStackNodeIndex(self.i, self.j-1)]

	local right = nodes[self:calculateStackNodeIndex(self.i+1, self.j)]
	
	
	if top ~= nil and not top.visited then
		table.insert(neighbours, top)
	end
	if right ~= nil and not right.visited then
		table.insert(neighbours, right)
	end
	if bottom ~= nil and not bottom.visited then
		table.insert(neighbours, bottom)
	end
	if left ~= nil and not left.visited then
		table.insert(neighbours, left)
	end
	
	if #neighbours > 0 then
		local randomNeighbour = neighbours[math.random(1, #neighbours)]
		local index = table.find(nodes, randomNeighbour)
		return neighbours[math.random(1, #neighbours)], index
	else
		return nil, nil
	end

end

return nodeClass
