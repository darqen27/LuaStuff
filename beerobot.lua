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
local port = "101"

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

function myEventHandlers.modem_message(ad1,ad2,port,dist,message, ...)
	print(ad1, ad2, port, dist, message, ...)
		if string.find(message, "Are you there?")
				then
					print("Robot Alive!")
					yesimhere(ad2, port)
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

 function chk_net(port)
	localip = wan.address
	print("I am at address: " .. tostring(localip))
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port ")
	if wan.open(port) == false 
		then print("Port already open")
	end
end
chk_net(port)

function areyouthere(port)
		if whoami == "server" then return else 
		print("Sending " .. tostring(wan.broadcast(port, "Are you there?")))	
		os.sleep(1)
		end
end

function yesimhere(ad2, port)
	print(ad2, port)
	print("Signal Strength: " .. wan.getStrength())
	print("Responding")
		if wan.send(ad2, port, message) == true then
		print("Message sent, on port: "..port.."\nto adress: "..ad2.."\nwith message: "..message)
		else print("\nmessage failed!")
	os.sleep(1)
end

while running do	
areyouthere(port)
eventHandle(event.pull(20))
os.sleep(1)
end