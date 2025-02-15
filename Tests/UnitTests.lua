local UnitTests = {}
local MazeClass = require(script.Parent.Server)

-- Tests if any nodes were created
function UnitTests.createMazeNodeTest()
	local testMaze = MazeClass.new()
	testMaze:createNewMaze()
	assert(#testMaze.nodes > 0, "No nodes were created or added to the nodes table")
end

-- Tests if the node count equals the correct size
function UnitTests.testNodeCount()
	local testMaze = MazeClass.new(20, nil, nil)
	testMaze:createNewMaze()
	assert(#testMaze.nodes == math.pow(30, 2), "Maze Node Number is not correct.")
end

-- Tests if the cell width is correct with the wall parts.
function UnitTests.testCellWidth()
	local testMaze = MazeClass.new(20, 10, nil)
	testMaze:createNewMaze()
	assert(testMaze.nodes[1].walls[1].Size.X == 10, "Wall width is not the correct Cell width")
end

-- Tests if the wall height was correct with the wall parts.
function UnitTests.testWallHeight()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	assert(testMaze.nodes[1].walls[1].Size.Y == 5, "Wall Size Y value is not equal to wall height")
end

-- Tests if the right wall gets removed when removing neighbouring walls
function UnitTests.testRightWallRemoval()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:removeWalls(testMaze.nodes[1], testMaze.nodes[2])
	assert(testMaze.nodes[1].walls[4] == nil, "The incorrect wall was removed For Moving Right")
end

-- Tests if the down wall gets removed when removing neighbouring walls
function UnitTests.testDownWallRemoval()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:removeWalls(testMaze.nodes[1], testMaze.nodes[21])
	assert(testMaze.nodes[1].walls[3] == nil, "The incorrect wall was removed For Moving Down")
end

-- Tests if the entrance gets created at cell (0,0)
function UnitTests.testEntranceCreation()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:checkForEntrance(testMaze.nodes[1])
	assert(testMaze.nodes[1].walls[1] == nil, "An entrance was meant to be created, but wall still exists")
end

-- Tests if the exit gets created at cell (n,n)
function UnitTests.testExitCreation()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:checkForEntrance(testMaze.nodes[400])
	assert(testMaze.nodes[400].walls[4] == nil, "An entrance was meant to be created, but wall still exists")
end

-- Tests if a non corner edge gets coloured walls.
function UnitTests.testEdgeWallColouring()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:paintEdgeWalls(testMaze.nodes[2])
	assert(testMaze.nodes[2].walls[1].Color == Color3.fromRGB(100, 233, 255), "The correct wall did not change colour")
end

-- Tests if a corner edge gets coloured walls.
function UnitTests.testCornerWallColouring()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:paintEdgeWalls(testMaze.nodes[1])
	assert(testMaze.nodes[1].walls[2].Color == Color3.fromRGB(100, 233, 255) and testMaze.nodes[1].walls[1].Color == Color3.fromRGB(100, 233, 255), "The correct corner walls did not change colour")
end

-- Tests if the stack at the end of maze calculation is empty and all neighbours are visited.
function UnitTests.testNodeStackSize()
	local testMaze = MazeClass.new(20, 10, 5)
	testMaze:createNewMaze()
	testMaze:calculateMaze()
	assert(testMaze.nodeStack:isEmpty(), "Node stack is not empty")
end

return UnitTests
