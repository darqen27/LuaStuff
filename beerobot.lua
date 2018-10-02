local component = require("component")
--local robot_api = require("robot") Robot API commented out during testing
--local inet = component.internet
--local i_ctrl = component.inventory_controller This one too
--local sides = require("sides")
local running = true
local char_space = string.byte(" ")



function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, playerName)
	if (char == char_space) then
		running = false
	end
end

function myEventHandlers.modem_message(_,_,from,port,_,message, ...)
	if message == "modem_message"
		then
			print("Test message from " .. from .. "with: " .. tostring(message))
			else
				print("Unknown Message" .. tostring(message))
	end
end
	
			
function anEventHandle(eID, ...)
	if (eID) then
		myEventHandlers[eID](...)
	end
end

 function chk_net()
 local wan = component.modem
 local event = require("event")
	localip = wan.address
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port " .. tostring(wan.open(001)))
	function areyouthere()
		while running do
			print("Sending " .. tostring(wan.broadcast(001, "Are you there?")))
			anEventHandle(event.pull(5))
		end
	end
end

conn = chk_net 
return conn

function chk_conn(conn)
	if conn ~= tostring(string)
		then print("No network found!")	
			elseif conn == tostring(string)
			then print("Network Connected!")
	end
end

	
repeat
	chk_conn
until running = false
