-- @author gilaga4815

local treeFolder = game.Workspace:WaitForChild("Tree")
local beamsFolder = treeFolder:WaitForChild("Beams")
local bulbsFolder = treeFolder:WaitForChild("Bulbs")

local treeConnections = {}
local emergency = false

local TreeModule = {}

local function updateBulb(bulb, mat, col)
	bulb.Material = mat
	bulb.BrickColor = col
end

function TreeModule.ConnectTree()
	local touchingValues = {
		["PSL"] = false,
		["PSR"] = false,
		["SL"] = false,
		["SR"] = false,
	}
	local allowedHits = {["FL"] = true, ["FR"] = true}
	
	for index, beamInstance in pairs(beamsFolder:GetChildren()) do
		treeConnections[#treeConnections + 1] = beamInstance.Touched:Connect(function(hitInst)
			if touchingValues[beamInstance.Name] then return end
			
			if allowedHits[hitInst.Name] then
				if (string.sub(beamInstance.Name, 1, 1) == "P") or touchingValues["P" .. beamInstance.Name] then
					touchingValues[beamInstance.Name] = true
				end
				
				local focusBulb = bulbsFolder[beamInstance.Name]
				updateBulb(focusBulb, Enum.Material.Neon, BrickColor.new(255, 255, 0))
			end
		end)
		
		treeConnections[#treeConnections + 1] = beamInstance.TouchEnded:Connect(function(hitInst)			
			if allowedHits[hitInst.Name] then
				if (string.sub(beamInstance.Name, 1, 1) == "P") or touchingValues["P" .. beamInstance.Name] then
					touchingValues[beamInstance.Name] = false
				end
				
				local focusBulb = bulbsFolder[beamInstance.Name]
				updateBulb(focusBulb, Enum.Material.SmoothPlastic, BrickColor.new())
			end
		end)
	end
end

function TreeModule.Clean()
	for i = 1, #treeConnections do
		if typeof(treeConnections[i]) == "RBXScriptConnection" then
			treeConnections[i]:Disconnect()
		end
	end
	for _,bulbInstance in pairs(bulbsFolder:GetChildren()) do
		updateBulb(bulbInstance, Enum.Material.SmoothPlastic, BrickColor.new())
	end
	wait(1)
	TreeModule.ConnectTree()
end

-- WinLight Pattern

-- Function TreeWinLights :
-- @Parameter winningSide 
-- 1 = left side
-- 2 = right side

function TreeModule.TreeWinLights(winningSide)
	local winPatterns = {{"TA5", "TA3", "TA1"}, {"TA6", "TA4", "TA2"}} -- the lights that go in order during the light pattern
	
	if winPatterns[winningSide] then	
		local runCount = 0 
		local lastBulb
		
		repeat
			for currentBulb = 1, #winPatterns[winningSide] do
				if lastBulb ~= nil then
					updateBulb(lastBulb, Enum.Material.SmoothPlastic, BrickColor.new())
				end
				updateBulb(bulbsFolder[winPatterns[winningSide][currentBulb]], Enum.Material.Neon, BrickColor.new(255, 255, 0))
				lastBulb = bulbsFolder[winPatterns[winningSide][currentBulb]]
				
				wait(0.2)
			end	
			runCount += 1
		until runCount == 8
		
		updateBulb(lastBulb, Enum.Material.SmoothPlastic, BrickColor.new())
	end
end


-- Race Patterns

function TreeModule.InstantGreen(scriptSender) -- the scriptSender part is if it's being sent by the module itself (for the standard run)
	wait(scriptSender and 0.5 or 0.015)
	
	for _, bulbInstance in pairs(bulbsFolder:GetChildren()) do
		if string.sub(bulbInstance.Name, 1, 1) == "G" then
			updateBulb(bulbInstance, Enum.Material.Neon, BrickColor.new(0, 181, 0))
		end
	end
	
	wait(5.5)
	TreeModule.Clean()
end

function TreeModule.StandardRun(commandSender) -- commandSender just means if the tree is being ran with a command
	wait(commandSender and 3 or 0.015)
	
	for _, bulbInstance in pairs(bulbsFolder:GetChildren()) do
		if string.sub(bulbInstance.Name, 1, 1) == "T" then
			updateBulb(bulbInstance, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		end
	end
	
	TreeModule.InstantGreen(true)
end

function TreeModule.ProRun()
	wait(0.015)
	
	for _, bulbInstance in pairs(bulbsFolder:GetChildren()) do
		if string.find(bulbInstance.Name, "S") then
			updateBulb(bulbInstance, Enum.Material.SmoothPlastic, BrickColor.new())
		end
	end
	
	updateBulb(bulbsFolder.TA1, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	updateBulb(bulbsFolder.TA2, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	wait(0.4)
	updateBulb(bulbsFolder.TA1, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.TA2, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.TA3, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	updateBulb(bulbsFolder.TA4, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	wait(0.4)
	updateBulb(bulbsFolder.TA3, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.TA4, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.TA5, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	updateBulb(bulbsFolder.TA6, Enum.Material.Neon, BrickColor.new(255, 255, 0))
	wait(0.5)
	updateBulb(bulbsFolder.TA5, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.TA6, Enum.Material.SmoothPlastic, BrickColor.new())
	updateBulb(bulbsFolder.GL, Enum.Material.Neon, BrickColor.new(0, 181, 0))
	updateBulb(bulbsFolder.GR, Enum.Material.Neon, BrickColor.new(0, 181, 0))
	wait(5.5)
	TreeModule.Clean()
end

function TreeModule.BracketRun(sideTimes)
	local leftSide = coroutine.wrap(function()
		local sideDelay = 0.3 + (sideTimes[1] / 4)
		
		wait(sideDelay)
		updateBulb(bulbsFolder.TA1, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.TA3, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.TA5, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.GL, Enum.Material.Neon, BrickColor.new(0, 181, 0))
	end)
	local rightSide = coroutine.wrap(function()
		local sideDelay = 0.3 + (sideTimes[2] / 4)

		wait(sideDelay)
		updateBulb(bulbsFolder.TA2, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.TA4, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.TA6, Enum.Material.Neon, BrickColor.new(255, 255, 0))
		wait(sideDelay)
		updateBulb(bulbsFolder.GR, Enum.Material.Neon, BrickColor.new(0, 181, 0))
	end)
	
	wait(1)
	leftSide()
	rightSide()
	wait(sideTimes[1] + sideTimes[2] + 7)
	
	TreeModule.Clean()
end

-- End of Race Patterns

function TreeModule.Emergency(emergencyValue)
	emergency = emergencyValue
	
	if emergencyValue then
		spawn(function()
			repeat
				updateBulb(bulbsFolder.RL, Enum.Material.Neon, BrickColor.new(255, 0, 0))
				updateBulb(bulbsFolder.RR, Enum.Material.Neon, BrickColor.new(255, 0, 0))
				wait(0.65)
				updateBulb(bulbsFolder.RL, Enum.Material.SmoothPlastic, BrickColor.new())
				updateBulb(bulbsFolder.RR, Enum.Material.SmoothPlastic, BrickColor.new())
				wait(0.65)
			until not emergency
		end)
	end
	
end



return TreeModule

