local component = require("component")
local robot_api = require("robot")
local inet = component.internet
local i_ctrl = component.inventory_controller
local wan = component.modem
local sides = require("sides")



 chk_net = coroutine.create(
 function ()
	local event = require("event")
		localip = wan.address
	wan.setStrength(10)
	wan.setWakeMessage("Wake up!")
	print("Opening port " .. tostring(wan.open(001)))
	print("Sending " .. tostring(wan.broadcast(001, "Are you there?")))
	local _,_, from, port, _, message = event.pull(5, "modem_message")
	print("Test message from " .. from .. " with test message: " .. tostring(message))
	
end

repeat
	conn = coroutine.resume(chk_net)
	if conn ~= nil
		then print("No network found!")
			os.sleep(5)	
			elseif conn ~= tostring(string)
			print("Network Connected!")
		end
until conn ~= tostring(string)
	
