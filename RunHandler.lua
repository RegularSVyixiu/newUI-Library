local runService = game:GetService("RunService")
local players = game:GetService("Players")

local RunLoops = {
	RenderStepTable = {},
	StepTable = {},
	HeartTable = {},
	PreRenderTable = {},
	PreAnimationTable = {},
	PreSimulationTable = {},
	PlayerAddedTable = {},
	PlayerRemovingTable = {}
}

function RunLoops:BindToRenderStep(name, func)
	if not self.RenderStepTable[name] then
		self.RenderStepTable[name] = runService.RenderStepped:Connect(func)
	end
end

function RunLoops:UnbindFromRenderStep(name)
	if self.RenderStepTable[name] then
		self.RenderStepTable[name]:Disconnect()
		self.RenderStepTable[name] = nil
	end
end

function RunLoops:BindToStepped(name, func)
	if not self.StepTable[name] then
		self.StepTable[name] = runService.Stepped:Connect(func)
	end
end

function RunLoops:UnbindFromStepped(name)
	if self.StepTable[name] then
		self.StepTable[name]:Disconnect()
		self.StepTable[name] = nil
	end
end

function RunLoops:BindToHeartbeat(name, func)
	if not self.HeartTable[name] then
		self.HeartTable[name] = runService.Heartbeat:Connect(func)
	end
end

function RunLoops:UnbindFromHeartbeat(name)
	if self.HeartTable[name] then
		self.HeartTable[name]:Disconnect()
		self.HeartTable[name] = nil
	end
end

function RunLoops:BindToPreRender(name, func)
	if not self.PreRenderTable[name] then
		self.PreRenderTable[name] = runService.PreRender:Connect(func)
	end
end

function RunLoops:UnbindFromPreRender(name)
	if self.PreRenderTable[name] then
		self.PreRenderTable[name]:Disconnect()
		self.PreRenderTable[name] = nil
	end
end

function RunLoops:BindToPreAnimation(name, func)
	if not self.PreAnimationTable[name] then
		self.PreAnimationTable[name] = runService.PreAnimation:Connect(func)
	end
end

function RunLoops:UnbindFromPreAnimation(name)
	if self.PreAnimationTable[name] then
		self.PreAnimationTable[name]:Disconnect()
		self.PreAnimationTable[name] = nil
	end
end

function RunLoops:BindToPreSimulation(name, func)
	if not self.PreSimulationTable[name] then
		self.PreSimulationTable[name] = runService.PreSimulation:Connect(func)
	end
end

function RunLoops:UnbindFromPreSimulation(name)
	if self.PreSimulationTable[name] then
		self.PreSimulationTable[name]:Disconnect()
		self.PreSimulationTable[name] = nil
	end
end

-- Player Events
function RunLoops:BindToPlayerAdded(name, func)
	if not self.PlayerAddedTable[name] then
		self.PlayerAddedTable[name] = players.PlayerAdded:Connect(func)
	end
end

function RunLoops:UnbindFromPlayerAdded(name)
	if self.PlayerAddedTable[name] then
		self.PlayerAddedTable[name]:Disconnect()
		self.PlayerAddedTable[name] = nil
	end
end

function RunLoops:BindToPlayerRemoving(name, func)
	if not self.PlayerRemovingTable[name] then
		self.PlayerRemovingTable[name] = players.PlayerRemoving:Connect(func)
	end
end

function RunLoops:UnbindFromPlayerRemoving(name)
	if self.PlayerRemovingTable[name] then
		self.PlayerRemovingTable[name]:Disconnect()
		self.PlayerRemovingTable[name] = nil
	end
end

return RunLoops
