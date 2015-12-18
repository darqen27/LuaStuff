local robot = require("robot")
local outsideargs = {...}
local dropnum = tonumber(outsideargs[1])
local navtablenum = outsideargs[2]



function navtable2(args)
	local navtable = { 
		[1] = {command = "up", amount = 4},
		[2] = {command = "forward", amount = 3},
		[3] = {command = "turnRight", amount = 1}, 
		[4] = {command = "forward", amount = 25},
		[5] = {command = "turnLeft", amount = 1},
		[6] = {command = "forward", amount = 3},
		[7] = {command = "dropDown", amount = 1, args = {dropnum}},
		[8] = {command = "forward", amount = 1},
		[9] = {command = "dropDown", amount = 1, args = {dropnum}},
		[10] = {command = "forward", amount = 1},
		[11] = {command = "dropDown", amount = 1, args = {dropnum}},
		[12] = {command = "turnRight", amount = 1},
		[13] = {command = "forward", amount = 1},
		[14] = {command = "turnRight", amount = 1},
		[15] = {command = "dropDown", amount = 1, args = {dropnum}},
		[16] = {command = "forward", amount = 1},
		[17] = {command = "dropDown", amount = 1, args = {dropnum}},
		[18] = {command = "forward", amount = 1},
		[19] = {command = "dropDown", amount = 1, args = {dropnum}},
		[20] = {command = "turnLeft", amount = 1},
		[21] = {command = "forward", amount = 1},
		[22] = {command = "turnLeft", amount = 1},
		[23] = {command = "dropDown", amount = 1, args = {dropnum}},
		[24] = {command = "forward", amount = 1},
		[25] = {command = "dropDown", amount = 1, args = {dropnum}},
		[26] = {command = "forward", amount = 1},
		[27] = {command = "dropDown", amount = 1, args = {dropnum}},
		[28] = {command = "turnAround", amount = 1},
		[29] = {command = "forward", amount = 5},
		[30] = {command = "turnRight", amount = 1},
		[31] = {command = "forward", amount = 27},
		[32] = {command = "turnLeft", amount = 1},
		[33] = {command = "forward", amount = 3},
		[34] = {command = "down", amount = 4},
		[35] = {command = "turnAround", amount = 1},
			}
	for i=1, #navtable do 
		for j=1, navtable[i].amount do 
		robot[navtable[i].command](table.unpack(navtable[i].args or {}))	
		end 
	end	
end


function navtable1(args)
	local navtable = 	{ 
	[1] = {command = "up", amount = 4},
	[2] = {command = "forward", amount = 3},
	[3] = {command = "turnRight", amount = 1}, 
	[4] = {command = "forward", amount = 4},
	[5] = {command = "turnLeft", amount = 1},
	[6] = {command = "forward", amount = 1},
	[7] = {command = "down", amount = 1},
	[8] = {command = "dropDown", amount = 1, args = {dropnum}},
	[9] = {command = "forward", amount = 1},
	[10] = {command = "dropDown", amount = 1, args = {dropnum}},
	[11] = {command = "up", amount = 1},
	[12] = {command = "forward", amount = 2},
	[13] = {command = "down", amount = 1},
	[14] = {command = "dropDown", amount = 1, args = {dropnum}},
	[15] = {command = "forward", amount = 1},
	[16] = {command = "dropDown", amount = 1, args = {dropnum}},
	[17] = {command = "turnRight", amount = 1},
	[18] = {command = "forward", amount = 1},
	[19] = {command = "turnRight", amount =1},
	[20] = {command = "select", amount = 1, args = 2},
	[21] = {command = "dropDown", amount = 1, args = {dropnum}},
	[22] = {command = "forward", amount = 1},
	[23] = {command = "dropDown", amount = 1, args = {dropnum}},
	[24] = {command = "up", amount = 1},
	[25] = {command = "forward", amount = 2},
	[26] = {command = "down", amount = 1},
	[27] = {command = "dropDown", amount = 1, args = {dropnum}},
	[28] = {command = "forward", amount = 1},
	[29] = {command = "dropDown", amount = 1, args = {dropnum}},
	[30] = {command = "turnLeft", amount = 1},
	[31] = {command = "up", amount = 1},
	[32] = {command = "forward", amount = 2},
	[33] = {command = "down", amount = 1},
	[34] = {command = "turnLeft", amount = 1},
	[35] = {command = "dropDown", amount = 1, args = {dropnum}},
	[36] = {command = "forward", amount = 1},
	[37] = {command = "dropDown", amount = 1, args = {dropnum}},
	[38] = {command = "up", amount = 1}, 
	[39] = {command = "forward", amount = 2},
	[40] = {command = "down", amount = 1},
	[41] = {command = "dropDown", amount = 1, args = {dropnum}},
	[42] = {command = "forward", amount = 1},
	[43] = {command = "dropDown", amount = 1, args = {dropnum}},
	[44] = {command = "turnRight", amount = 1},
	[45] = {command = "forward", amount = 1},
	[46] = {command = "select", amount = 1, args = 1},
	[47] = {command = "turnRight", amount = 1},
	[48] = {command = "dropDown", amount = 1, args = {dropnum}},
	[49] = {command = "forward", amount = 1},
	[50] = {command = "dropDown", amount = 1, args = {dropnum}},
	[51] = {command = "up", amount = 1}, 
	[52] = {command = "forward", amount = 2},
	[53] = {command = "down", amount = 1},
	[54] = {command = "dropDown", amount = 1, args = {dropnum}},
	[55] = {command = "forward", amount = 1},
	[56] = {command = "dropDown", amount = 1, args = {dropnum}},
	[57] = {command = "up", amount = 1},
	[58] = {command = "forward", amount = 1},
	[59] = {command = "turnRight", amount = 1},
	[60] = {command = "forward", amount = 8},
	[61] = {command = "turnLeft", amount = 1},
	[62] = {command = "forward", amount = 3},
	[63] = {command = "down", amount = 4},
	[64] = {command = "turnAround", amount = 1}
			}
	for i=1, #navtable do 
		for j=1, navtable[i].amount do 
		robot[navtable[i].command](table.unpack(navtable[i].args or {}))	
		end 
	end
end


if navtablenum == ("navtable1") then
        return print("Adding " .. dropnum .. " fuel to the Hybrid cores"), navtable1(args)
		else if navtablenum == ("navtable2") then
			return  print("Adding " .. dropnum .. " fuel to the Breeder cores"), navtable2(args)
				else return print("Invalid Navigation Table." .. " Please select navtable1 or navtable2")
	end
end

