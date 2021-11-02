-- @author gilaga4815

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

local TreeEvents = ReplicatedStorage:WaitForChild("RaceReplication"):WaitForChild("Events"):WaitForChild("TreeEvents")

local TreeControl = TreeEvents:WaitForChild("ControllerRelay")

local TreeModule = require(script.Parent:WaitForChild("TreeModule"))

local runFormat = {
	["Pro"] = "ProRun",
	["InstGreen"] = "InstantGreen",
	["Normal"] = "StandardRun",
	["Bracket"] = "BracketRun",
}

local commandsAllowed = true

TreeControl.OnServerEvent:Connect(function(sender, event, ...)
	local args = {...}
	
	if event == "DoRun" then
		local runType = args[1]
		
		if runFormat[runType] then
			if runType == "Bracket" then
				print(args[2])
				local sideTimes = {args[2][1] == 0 and args[2][2] or 0, args[2][1] == 1 and args[2][2] or 0}
				TreeModule.BracketRun(sideTimes)
			else
				TreeModule[runFormat[runType]]()
			end
		end
	elseif event == "Emergency" then
		local emergencyBool = args[1]
		TreeModule.Emergency(emergencyBool)
	elseif event == "Commands" then
		commandsAllowed = args[1]
	end
end)

PlayerService.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		msg = msg:lower()
		
		if msg == "start" and commandsAllowed then
			TreeModule.StandardRun(true)
		end
	end)
end)

TreeModule.ConnectTree() -- initiates the tree cycle so it can start doing stuff.

