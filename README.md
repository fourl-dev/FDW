# FDW

FDW is a work in progress Datastore wrapper with buffers. 

FDW has 3 three main functions:

```
CreateDataStore(name : string, isOrdered : boolean), returns a FDW type object.
NewSaveObject(object : FDW), returns a save object
Unpack(t : table)
```
Save objects allow you to add items like

```
local SaveObject = FDW.NewSaveObject(FDW)
SaveObject:AddItem("Cash", 99)
```

And you can using the save function like:

```
local SaveObject = FDW.NewSaveObject(FDW)
SaveObject:AddItem("Cash", 99)
SaveObject:Save(plr.UserId)
```

Unpack can be used:

```
local Unpacked = FDW.Unpack(FDW)
local Cash = Unpacked:GetItem("Cash")
```

Additionally you can normally use SetData on a FDW if you do not want to use SaveObjects/buffers.

```
local CDS = FDW.CreateDataStore("NewCash")
CDS:SetData(k, v)
```

Any feedback on improving this would be appreciated.
