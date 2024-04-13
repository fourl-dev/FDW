local module = {}

local DSS = game:GetService("DataStoreService")

local Datas = {}
local Tables = {}

local Wrapper = {}
Wrapper.__index = Wrapper

local Default = {}
Default.__index = Default

local UPD = {}
UPD.__index = UPD

export type FDW = {
	Store: any
}

export type SaveObject = {
	Store: FDW
}

export type UnpackBuffer = {}

function GetDataStore(Name, ordered)
	local Data

	if not table.find(Datas, Name) then
		if ordered then
			Data = DSS:GetOrderedDataStore(Name)
		else

			Data = DSS:GetDataStore(Name)
		end

		Datas[Name] = Data
	else
		Data = Datas[Name]
	end

	return Data
end

function SetData(Data, key, value)
	local success, errormsg
	local s, e
	local retries = 0

	repeat 
		s, e = pcall(function()
			return Data:GetAsync(key)
		end)

		if not s then
			warn(e)
			task.wait(1)
		end

		retries += 1

	until s or retries == 5

	if not s then
		warn(e)
		return
	end

	retries = 0

	if e then
		repeat
			success, errormsg = pcall(function()
				Data:UpdateAsync(key, function(oldData)
					return value
				end)
			end)

			if not success then
				warn(errormsg)
				task.wait(1)
			end

			retries += 1
		until success or retries == 5

		if not success then
			warn(errormsg)
			return
		end
	else
		repeat
			success, errormsg = pcall(function()
				Data:SetAsync(key, value)
			end)

			if not success then
				warn(errormsg)
				task.wait(1)
			end

			retries += 1
		until success or retries == 5

		if not success then
			warn(errormsg)
			return
		end
	end
end

function GetData(Data, key)
	local success, errormsg
	local s, e
	local retries = 0

	repeat 
		s, e = pcall(function()
			return Data:GetAsync(key)
		end)

		if not s then
			warn(e)
			task.wait(1)
		end

		retries += 1

	until s or retries == 5

	if not s then
		warn(e)
		return nil
	end

	return e
end

function findTable(n)
	for k, v in pairs(Tables) do
		if k == n then
			return v
		end
	end

	return nil
end


module.CreateDataStore = function(Name, Ordered) : FDW
	if not findTable(Name) then
		local DS = GetDataStore(Name)

		local newTable : any = {
			Store = DS
		}

		setmetatable(newTable, Wrapper)

		Tables[Name] = newTable

		return newTable
	else
		return findTable(Name)
	end
end

module.NewSaveObject = function(object : FDW) : SaveObject
	local SaveObject : any = {
		Store = object
	}

	setmetatable(SaveObject, Default)

	return SaveObject
end

module.Unpack = function(t) : UnpackBuffer
	local Converted : any = {}

	for k, v in pairs(t) do
		local convert = buffer.tostring(v)

		Converted[k] = tonumber(convert) or convert
	end

	setmetatable(Converted, UPD)

	return Converted
end


function Wrapper:SetData(key, value)
	SetData(self.Store, key, value)
end

function Wrapper:GetData(key)
	return GetData(self.Store, key)
end

function Default:AddItem(n, s)
	if not self.Buffers then
		self.Buffers = {}
	end

	local BuffT = self.Buffers
	BuffT[n] = buffer.fromstring(tostring(s))

	self.Buffers = BuffT
end

function Default:Save(key)
	SetData(self.Store.Store, key, self.Buffers)
end

function UPD:GetItem(name)
	return self[name]
end



return module
