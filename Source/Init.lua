-- Create a Maze object using the Server class --

local MazeClass = require(script.Server)
local UnitTests = require(script.UnitTests)

local maze = MazeClass.new()
maze:createNewMaze()
maze:calculateMaze()


