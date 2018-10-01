local component = require("component")
--local robot_api = require("robot") Robot API commented out during testing
local inet = component.internet
--local i_ctrl = component.inventory_controller This one too
local wan = component.modem
local sides = require("sides")
local running = true
local char_space = string.byte(" ")


 chk_net = coroutine.create(
 function ()
 local event = require("event")
	localip = wan.address
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port " .. tostring(wan.open(001)))
		while running do
			print("Sending " .. tostring(wan.broadcast(001, "Are you there?")))
			local _,_, from, port, _, message = event.pull(5, "modem_message")
			print("Test message from " .. from .. "with: " .. tostring(message))
		coroutine.yield()
	end
end
)
function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(char)
	if (char == char_space) then
		running = false
	end
end

function anEventHandle(eID, ...)
	if (eID) then
		myEventHandlers[eID](...)
	end
end

repeat
	conn = coroutine.resume(chk_net)
	if conn ~= tostring(string)
		then print("No network found!")
			os.sleep(5)	
			elseif conn == tostring(string)
			then print("Network Connected!")
		end
until conn == tostring(string)
	
