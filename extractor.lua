local component = require("component")
local sides = require("sides")
local rs = component.redstone
local extractor = component.Extractor
local cvt1 = component.proxy("cadee4ce-b9af-45ca-9869-946d1aaf3bc9")

function gearSwitch()
	local checkitems0,checkitems1,checkitems2,checkitems3,checkitems4,checkitems5,checkitems6=table.pack(extractor.getSlot(0)),table.pack(extractor.getSlot(1)),table.pack(extractor.getSlot(2)),table.pack(extractor.getSlot(3)),table.pack(extractor.getSlot(4)),table.pack(extractor.getSlot(5)),table.pack(extractor.getSlot(6))
	if 	checkitems3[3]==nil and checkitems2[3]~=nil
		then 	if (checkitems2[3]>=1) then
			rs.setOutput(sides.south,0)
			print("Switching to 32x") end 
	elseif (checkitems6[3] ~=nil or checkitems3[3]~=nil) 
		then 	if (checkitems3[3]>=63) then
			rs.setOutput(sides.south,15)
			print("Switching to 2x") elseif checkitems2[4]~=nil and (string.match(checkitems3[4],"%w+") ~= string.match(checkitems2[4],"%w+") and checkitems3[3]>=1) then 
			rs.setOutput(sides.south,15)
			print("Switching to 2x") elseif (checkitems3[3] ~=nil and checkitems2[3] ==nil) then rs.setOutput(sides.south,15) print("Switching to 2x")  end
	elseif (checkitems1[3] ~= nil or checkitems2[3] ~= nil) and (checkitems0[3] == nil and checkitems3[3] == nil)
		then
			rs.setOutput(sides.south,0)
			print("Switching to 32x")			
	elseif checkitems0[3] ~= nil and (checkitems1[3] == nil and checkitems2[3] == nil and checkitems3[3] == nil)
		then
			rs.setOutput(sides.south,15)
			print("Starter Cycle")
	elseif ((checkitems0[3] ~= nil and checkitems3[3] ~= nil) and (checkitems1[3] == nil and checkitems2[3] == nil)) or ((checkitems6[3] ~=nil or checkitems3[3]~=nil) and (checkitems0[3]==nil and checkitems1[3]==nil and checkitems2[3]==nil))
		then
			rs.setOutput(sides.south,15)
			print("Cleaning up")
	elseif (checkitems0[3] == nil and checkitems1[3] == nil and checkitems2[3] == nil and checkitems3[3] == nil)
		then 
			running = false
			print("Turbine Spinning down!")
	end
end
rs.setOutput(sides.west,15)
rs.setOutput(sides.north,0)
running = true
while running do
	gearSwitch()
	os.sleep(1.5)
end
rs.setOutput(sides.west,0)
rs.setOutput(sides.north,15)

