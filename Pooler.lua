local customerFolder = workspace.CustomerPool
local customerSpawnPointFolder = workspace.SpawnTargets
local customerSpawnPoints = {}
local customerPool = {}
local maxActive = 5
local spawnIntervalMin, spawnIntervalMax = 20, 120

local function initializeObjectPoolFromFolder(objectFolder, objectPool)
	for _, object in ipairs(objectFolder:GetChildren()) do
		if object then
			object:SetAttribute("Active", false)  -- Custom attribute to track usage
			object.Transparency = 1 
			object.Anchored = true
			object.CanCollide = false
			table.insert(objectPool, object)
		end
	end
end

local function initializeSpawnPointPoolFromFolder(spawnFolder, spawnPoints)
	for _, spawnPoint in ipairs(spawnFolder:GetChildren()) do
		if spawnPoint then
			local spawnPosition = spawnPoint.Position
			table.insert(spawnPoints, spawnPosition)
		end
	end
end

initializeObjectPoolFromFolder(customerFolder, customerPool)
initializeSpawnPointPoolFromFolder(customerSpawnPointFolder, customerSpawnPoints)

-- =========================================================================================================

local function getInactiveObject(pool)
	for _, object in ipairs(pool) do
		if not object:GetAttribute("Active") then
			return object
		end
	end
	return nil
end

local function activateObject(pool, spawnPoints)
	local object = getInactiveObject(pool)
	if not object then return end
	object.CanCollide = true
	object.Anchored = false
	local spawnPosition = spawnPoints[math.random(1, #spawnPoints)]
	object.Position = spawnPosition
	object.Transparency = 0 
	object:SetAttribute("Active", true)
end

local function spawnLoop(pool, spawnPoints, spawnMin, spawnMax)
	if #pool > 0 then
		activateObject(pool, spawnPoints)
		print("object activated")
	end
	task.wait(math.random(spawnMin, spawnMax))
end

-- =======================================================================================================
-- Duplicate these with different parameters.(As well as initializations) Don't duplicate the script :)

task.spawn(function()
	while true do
		spawnLoop(
			customerPool, 
			customerSpawnPoints, 
			spawnIntervalMin, 
			spawnIntervalMax
		)
	end
end)

-- =======================================================================================================
-- Example for handling death

local function onDeath(object)
	object.CanCollide = false
	object.Transparency = 1
	object:SetAttribute("Active", false)
end