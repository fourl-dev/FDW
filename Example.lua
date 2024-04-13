local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local FDW = require(ServerScriptService:WaitForChild("FourlDSWrapper"))
local CashDataStore = FDW.CreateDataStore("NewCash")

function onPlayerAdded(plr : Player)
	local leaderstats = Instance.new("Folder")
	
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local Cash = Instance.new("IntValue")
	
	local Data = CashDataStore:GetData(plr.UserId)
	
	if Data then
		local Unpacked = FDW.Unpack(Data)
		local NC = Unpacked:GetItem("Cash")
		
		Cash.Value = NC
	else
		Cash.Value = 0
	end
	
	Cash.Name = "Cash"
	Cash.Parent = leaderstats
	
	Cash:GetPropertyChangedSignal("Value"):Connect(function()
		print("saving...")
		
		local SaveObject = FDW.NewSaveObject(CashDataStore)
		SaveObject:AddItem("Cash", Cash.Value)
		SaveObject:Save(plr.UserId)
		
		print("saved!")
	end)
end

function onPlayerRemoving(plr : Player)
	local LS = plr:FindFirstChild("leaderstats")
	
	if not LS then return end
	
	local Cash = LS:FindFirstChild("Cash")
	
	if not Cash then return end
	
	print("saving...")
	
	local SaveObject = FDW.NewSaveObject(CashDataStore)
	SaveObject:AddItem("Cash", Cash.Value)
	SaveObject:Save(plr.UserId)
	
	print("saved!")
end

PlayerService.PlayerAdded:Connect(onPlayerAdded)
PlayerService.PlayerRemoving:Connect(onPlayerRemoving)
