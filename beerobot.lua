local component = require("component")
local robot = require("robot") --Robot API commented out during testing
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
	getWaypoints()
	while xpos[1] ~= 0 do
	changeX(xpos)
	getWaypoints()
	end
	--changeY(ypos)
	while zpos[1] ~= 0 do
	changeZ(zpos)
	getWaypoints()
	end
	--changeY(ypos)

end
function changeX(xpos)
	print("Move X: " .. xpos[1])
		if xpos[1] == 0 then return end
			if xpos[1] > 0 then 
				while nav.getFacing() ~= 5 do 
					robot.turnLeft()
				end
				if robot.detect() == false 
					then robot.forward() else return changeY(ypos) end
				elseif xpos[1] < 0 then 
					while nav.getFacing() ~= 4 do
					robot.turnRight()
					end						
				if robot.detect() == false
					then robot.forward() else return changeY(ypos) end
		end
end
function changeY(ypos)
	if ypos[1] > 0 then
		if robot.detectUp() == false
			then robot.up()
			else end
	elseif ypos[1] < 0 then
		if robot.detectDown() == false
			then robot.down()
			else end
	elseif ypos[1] == 0 then
	end	
		if ypos[1] == 0 
			then if xpos[1] and zpos[1] == 0 
				then return end 
			elseif ypos[1] ~= 0 
				then return changeY() end
			
			if robot.detect() == true
				then 
					if robot.detectUp() == false
						then robot.up()
					elseif robot.detectDown() == false
						then robot.down()
					end
				
			end
		end
	
function changeZ(zpos)
	print("Move Z: " .. zpos[1])
	if zpos[1] == 0 then return end
		if zpos[1] > 0 then 
			while nav.getFacing() ~= 3 do 
				robot.turnLeft()
			end
			if robot.detect() == false
				then robot.forward() else return changeY(ypos) end
			elseif zpos[1] < 0 then 
				while nav.getFacing() ~= 2 do
				robot.turnRight()
				end						
			if robot.detect() == false
				then robot.forward() else return changeY(ypos) end
		end
end
function stuck(xpos, ypos, zpos)

end
while running do	
moveAround(xpos, ypos, zpos)
--areyouthere(remoteport)
--chk_net(localport)
eventHandle(event.pull(10))
os.sleep(5)
end