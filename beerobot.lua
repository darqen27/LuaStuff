local component = require("component")
--local robot_api = require("robot") Robot API commented out during testing
--local inet = component.internet
--local i_ctrl = component.inventory_controller This one too
--local sides = require("sides")
local running = true
local char_space = string.byte(" ")
local wan = component.modem
local event = require("event")


function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, player)
	if (char == char_space) then
		print("SPACE BAR")
		running = false
	end
end

function myEventHandlers.modem_message(eID,_,_,from,port,_,message, ...)
	if tostring(eID) == "modem_message"
		then
			print("Test message from " .. from .. "with: " .. tostring(message, ...))
			else
				print("Unknown Message" .. tostring(message, ...))
	end
end


	
			
function anEventHandle(eID, ...)
	if (eID) then
		myEventHandlers[eID](...)
	end
end

 function chk_net()
	localip = wan.address
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port " .. tostring(wan.open(001)))
end
chk_net

function areyouthere()
		print("Sending " .. tostring(wan.broadcast(001, "Are you there?")))	
end


function chk_conn()
	local conn = setmetatable({})
	conn = anEventHandle(event.pull())  
		print(tostring(conn))
		if conn ~= string
			then print("No network found!")	
				elseif conn == string
				then print("Network Connected!")
					else 
		end
end

while running do	
chk_conn
areyouthere
os.sleep(1)
end