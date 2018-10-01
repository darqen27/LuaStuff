local component = require("component")
local robot_api = require("robot")
local inet = component.internet
local i_ctrl = component.inventory_controller
local wan = component.modem
local sides = require("sides")



function check_network()
	local event = require("event")
    localip = wan.address
	wan.setStrength(10)
	wan.setWakeMessage("Are you there?")
	print("Opening port " .. tostring(wan.open(001)))
	print("Connecting = " .. tostring(wan.broadcast(001, "Are you there?")))
	local _,_, from, port, _, message = event.pull("modem_message")
	print("Connected to " .. from .. " with test message: " .. tostring(message))
	
end

local chk_net = coroutine.create( check_network()
	if check_network() == nil
		then print("No network found!")
			elseif check_network() == tostring(string)
			print("Network Connected!")
		end
	end)
	
