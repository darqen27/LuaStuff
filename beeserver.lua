local component = require("component")
--local robot_api = require("robot") Robot API commented out during testing
--local inet = component.internet
--local i_ctrl = component.inventory_controller This one too
--local sides = require("sides")
local running = true
local char_space = string.byte(" ")
local wan = component.modem
local event = require("event")
local whoami = "server"
local localport = 101
local remoteport = 102

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
chk_net(localport)

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

while running do	
areyouthere(remoteport)
eventHandle(event.pull(20))
os.sleep(1)
end