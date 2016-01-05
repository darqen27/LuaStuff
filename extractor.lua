local component = require("component")
local sides = require("sides")
local rs = component.redstone
local extractor = component.Extractor
local cvt1 = component.proxy("cadee4ce-b9af-45ca-9869-946d1aaf3bc9")

function gearSwitch()
	local checkitems0,checkitems3,checkitems4,checkitems5,checkitems6=extractor.getSlot(0),extractor.getSlot(3),extractor.getSlot(4),extractor.getSlot(5),extractor.getSlot(6)
	if checkitems5 and checkitems6 == nil and checkitems0 ~= nil and checkitems3 and checkitems4 ~= nil 
		then 	
			rs.setOutput(sides.south,0)
			print("Switching to 32x")
	elseif checkitems5 and checkitems6 ~= nil or checkitems0 ~= nil
		then 
			rs.setOutput(sides.south,15)
			print("Switching to 2x")
	elseif checkitems0 and checkitems3 and checkitems4 and checkitems5 and checkitems6 == nil
		then 
			running = false
			print("fin")
	end
end
rs.setOutput(sides.west,15)
rs.setOutput(sides.north,0)
running = true
while running do
	gearSwitch()
	os.sleep(0.5)
end
rs.setOutput(sides.west,0)
rs.setOutput(sides.north,15)

