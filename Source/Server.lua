local Server = {}
local nodeClass = require(script.Parent.NodeClass);
local stackModule = require(script.Parent.Stack);

Server.__index = Server

function Server.new(boardWidth, cellWidth, wallHeight)
	local self = setmetatable({}, Server)
	
	self.BOARD_WIDTH = boardWidth or 30
	self.CELL_WIDTH = cellWidth or 20
	self.HEIGHT = wallHeight or 50
	
	self.nodes = {}
	
	return self
end

-- Function to create a new maze and its cells
function Server:createNewMaze()
	local index = 1;
	for i = 1, self.BOARD_WIDTH do
		for j = 1, self.BOARD_WIDTH do
			local currentNode = nodeClass.new(i, j, self.CELL_WIDTH, self.HEIGHT, self.BOARD_WIDTH, self.BOARD_WIDTH);
			currentNode:spawnWalls();
			self.nodes[index] = currentNode;
			index += 1;
		end
	end
end

-- Function to remove the walls between the current and next node
function Server:removeWalls(currentNode, nextNode)
	local y = (currentNode.i - nextNode.i);
	local x = (currentNode.j - nextNode.j);

	if x == 1  then
		currentNode.walls[2]:Destroy();
		nextNode.walls[4]:Destroy();
		
		currentNode.walls[2] = nil
		nextNode.walls[4] = nil
	elseif x == -1 then
		currentNode.walls[4]:Destroy();
		nextNode.walls[2]:Destroy();
		
		currentNode.walls[4] = nil
		nextNode.walls[2] = nil
	end

	if y == 1  then
		currentNode.walls[1]:Destroy();
		nextNode.walls[3]:Destroy();
		
		currentNode.walls[1] = nil
		nextNode.walls[3] = nil
	elseif y == -1 then
		currentNode.walls[3]:Destroy();
		nextNode.walls[1]:Destroy();
		
		currentNode.walls[3] = nil
		nextNode.walls[1] = nil
	end
end

-- Function to check if an entrance needs to be made
function Server:checkForEntrance(currentNode)
	if (currentNode.x//self.CELL_WIDTH == self.BOARD_WIDTH and currentNode.y//self.CELL_WIDTH == self.BOARD_WIDTH) then
		currentNode.walls[4]:Destroy()
		currentNode.walls[4] = nil
	elseif (currentNode.x//self.CELL_WIDTH == 1 and currentNode.y//self.CELL_WIDTH == 1) then
		currentNode.walls[1]:Destroy()
		currentNode.walls[1] = nil
	end
end

-- Function to check if the walls need to be painted
function Server:paintEdgeWalls(currentNode)
	if (currentNode.y//self.CELL_WIDTH) == self.BOARD_WIDTH then
		currentNode.walls[3].Color = Color3.new(0.396078, 0.917647, 1)
	end    
	if (currentNode.y//self.CELL_WIDTH) == 1 then
		currentNode.walls[1].Color = Color3.new(0.396078, 0.917647, 1)
	end        
	if (currentNode.x//self.CELL_WIDTH) == self.BOARD_WIDTH then
		currentNode.walls[4].Color = Color3.new(0.396078, 0.917647, 1)
	end
	if (currentNode.x//self.CELL_WIDTH) == 1 then
		currentNode.walls[2].Color = Color3.new(0.396078, 0.917647, 1)
	end 
end

-- Where the backtracking algorithm runs, loops until the stack object is empty.
function Server:calculateMaze()
	self.nodeStack = stackModule.new(self.CELL_WIDTH * self.CELL_WIDTH);
	local current = self.nodes[1];

	--Mark first one as visited and push onto stack
	current.visited = true;
	self.nodeStack:push(current);

	--Create the currentNodePointerMesh
	local pointer = Instance.new("Part")
	pointer.Size = Vector3.new(self.CELL_WIDTH, self.HEIGHT, self.CELL_WIDTH);
	pointer.Position = Vector3.new(current.x, 0,current.y)
	pointer.Parent = workspace;
	pointer.Anchored = true;
	pointer.CanCollide = false;
	pointer.Material = Enum.Material.Neon;
	pointer.Color = Color3.new(0.309804, 1, 0.470588);

	while not self.nodeStack:isEmpty() do
		current = self.nodeStack:pop();
		current:changeWallColours();
		pointer.Position = Vector3.new(current.x, 0,current.y)

		local neighbour, index = current:checkNeighbours(self.nodes);

		--checkForEntrance(current)
		--self:paintEdgeWalls(current)


		if neighbour ~= nil then
			self.nodeStack:push(current);
			self:removeWalls(current, neighbour);
			neighbour.visited = true;
			self.nodeStack:push(neighbour);
		end
		task.wait()
	end
end


return Server
