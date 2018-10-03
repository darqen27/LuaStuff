local component = require("component")
local robot_api = require("robot") --Robot API commented out during testing
--local inet = component.internet
local i_ctrl = component.inventory_controller --This one too
local sides = require("sides")
local running = true
local char_space = string.byte(" ")
local wan = component.modem
local event = require("event")
local whoami = "robot"
local localport = 102
local remoteport = 101
local waytable = setmetatable({}, {}, {})
local nav = component.navigation
local xpos = {}
local ypos = {}
local zpos = {}
local startX, startY, startZ = nav.getPosition()


function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_down(adress, char, code, player)
	print(char)
	if (char == char_space) then
		--print("SPACE BAR")
		running = false
	end
end

function myEventHandlers.modem_message(ad1,ad2,localport,dist,message, ...)
	print(ad1, ad2, localport, dist, message, ...)
		if string.find(message, "Are you there?")
				then
					print("Robot Alive!")
					yesimhere(ad2, remoteport)
						elseif string.find(message, "Yes I am here.")
							then print("Response") 
		end
end
--	if message == string
--		then
--			print("Test message from " .. from .. "with: " .. tostring(message, ...))
--			else
--				print("Unknown Message: " .. tostring(message, ...))
--	end



	
			
function eventHandle(eID, ...)
	if (eID) then
		print(eID)
		myEventHandlers[eID](...)
	end
end

 function chk_net(localport)
	localip = wan.address
	print("I am at address: " .. tostring(localip))
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port ")
	if wan.open(localport) == false 
		then print("Port already open")
	end
end


function areyouthere(remoteport)
		if whoami == "server" then return else 
		print("Sending " .. tostring(wan.broadcast(remoteport, "Are you there?")))	
		--os.sleep(1)
		end
end

function yesimhere(ad2, remoteport)
	local message = "Yes I am here."
	--print(ad2, remoteport)
	print("Signal Strength: " .. wan.getStrength())
	print("Responding")
		if wan.send(ad2, remoteport, message) == true then
		print("Message sent, on port: "..remoteport.."\nto adress: "..ad2.."\nwith message: "..message)
		else print("\nmessage failed!")
		end
	--os.sleep(1)
end

function getWaypoints()
	waytable = nav.findWaypoints(30)
	local xcoord=1 ycoord=2 zcoord=3
	local n=1
	for i=1, waytable.n do
		xpos[n] = waytable[n].position[xcoord]
		ypos[n] = waytable[n].position[ycoord]
		zpos[n] = waytable[n].position[zcoord]
		print(xpos[n], ypos[n], zpos[n])
		n=n+1
	end
end

function moveAround(xpos, ypos, zpos)
	myX, myY, myZ = nav.getPosition()
	print(myX, myY, myZ)
		function changeX(xpos)
			local facing = nav.getFacing()
				
					if xpos[1] > 0 and 
						while facing ~= 5 do 
							robot.turnLeft()
							facing = nav.getfacing()
						end
						then if robot.detect() == true 
							then robot.forward() else end
						elseif xpos[1] < 0 and while facing ~= 4 do
							robot.turnRight()
							facing = nav.getFacing()
							end						
						then if robot.detect() == true
							then robot.back() else end
						elseif xpos[1] == 0
						then

				end
		end
		function changeY(ypos)
			if ypos[1] > 0 then
				if robot.detectUp() == true
					then robot.up()
					else
				end
			elseif ypos[1] < 0 then
				if robot.detectDown() == true
					then robot.down()
					else
				end
			elseif ypos[1] == 0 then
			end
		end
	
		function changeZ(zpos)
			local facing = nav.getFacing()
				
				if zpos[1] > 0 and 
					while facing ~= 3 do 
						robot.turnLeft()
						facing = nav.getfacing()
					end
					then if robot.detect() == true 
						then robot.forward() else end
					elseif zpos[1] < 0 and 
						while facing ~= 2 do
						robot.turnRight()
						facing = nav.getFacing()
						end						
					then if robot.detect() == true
						then robot.back() else end
					elseif zpos[1] == 0
					then
				end
		end
		function stuck(xpos, ypos, zpos)
		
		end
while running do	
getWaypoints()
moveAround(xpos, ypos, zpos)
--areyouthere(remoteport)
--chk_net(localport)
--eventHandle(event.pull(20))
os.sleep(5)
end