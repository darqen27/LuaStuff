local component = require("component")
local robot_api = require("robot")
local inet = component.internet
local i_ctrl = component.inventory_controller
local wan = component.modem
local sides = require("sides")



function check_network()
    wan.open



