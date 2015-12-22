
local component = require("component")
local term = require("term")
local keyboard = require("keyboard")
local computer = require("computer")
local event = require("event")


function getAddresslist(coretype) -- Too many identical names, must set proxies to be able to interact with all of the different core's.
	local function fissioncores()
		print("Getting fission core addresses.")
		local compaddresslist = {}
		fissioncore = {}
		local n = 1
			for k,v in pairs(component.list("FuelCore")) do
			compaddresslist[n] = k
			fissioncore[n] = component.proxy(compaddresslist[n])
			print("Fission core #" .. n .." address assigned.") 
			n = n+1
			
		end
	if fissioncore[1] == nil then print("No fission cores detected!") end
	end
	local function breedercores()
		print("Getting breeder core addresses.")
		local compaddresslist = {}
		breedercore = {}
		local n=1
			for k,v in pairs(component.list("Breeder")) do				
			compaddresslist[n]=k
			breedercore[n] = component.proxy(compaddresslist[n])
			print("Breeder core #" .. n .." address assigned.") 
			n=n+1
				
		end
	if breedercore[1] == nil then print("No breeder cores detected!") end
	end

	local function pebblecores()
		print("Getting pebble bed core addresses.")
		local compaddresslist = {}
		pebblecore = {}
		local n=1
			for k,v in pairs(component.list("Pebble")) do
			compaddresslist[n]=k
			pebblecore[n] = component.proxy(compaddresslist[n])
			print("Pebble bed core #" .. n .." address assigned.") 
			n=n+1
			
		end
	if pebblecore[1] == nil then print("No pebble bed cores detected!") end
	end

	if coretype == "breeder" then breedercores()
	elseif coretype == "fission" then fissioncores()
	elseif coretype == "pebble" then pebblecores()
	else print("Invalid selection"); return
	end
end



function getTempall()
	coretemp = {}
	coretemp.fissioncore = {}
	coretemp.breedercore = {}
	local function fissioncores()
		local n=1
		for i=1, #fissioncore do
		coretemp.fissioncore[n] = fissioncore[n].getTemperature()
		print("Fission Core #" .. n .. " temperature is ".. coretemp.fissioncore[n])
		n=n+1
		end
	end
	local function breedercores()
		local n=1
		for i=1, #breedercore do
		coretemp.breedercore[n] = breedercore[n].getTemperature()
		print("Breeder Core #" .. n .. " temperature is ".. coretemp.breedercore[n])
		n=n+1
		end
	end
fissioncores()
breedercores()
end

function getTemp(n)
	coretemp={}
	term.clear()
	if not n then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end
	if n<=0 or n>(#fissioncore) then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end 
	coretemp[n] = fissioncore[n].getTemperature()
	print("Core #" .. n .. " temperature is ".. coretemp[n])	
end


	
function checkFuel(n)
	corefuel={}
	term.clear()
	if not n then return print("Please enter a number between 1 and " .. #fissioncore) end
	if n<=0 or n>(#fissioncore) then return print("Please enter a number between 1 and " .. #fissioncore) end 
	corefuel[n] = fissioncore[n].checkFuel()
	print("Core #" .. n .. " fuel level is ".. corefuel[n])
end

	
function checkFuelall()
	corefuel = {}
	corefuel.fissioncore = {}
	corefuel.breedercore = {}
	corefuel.pebblecore = {}
	local function fissioncores()
		local n=1
		for i=1, #fissioncore do
		corefuel.fissioncore[n] = fissioncore[n].checkFuel()
		print("Fission Core #" .. n .. " fuel level is ".. corefuel.fissioncore[n])
		n=n+1
		end
	end
	
	local function breedercores()
		local n=1
		for i=1, #breedercore do
		corefuel.breedercore[n] = breedercore[n].checkFuel()
		print("Breeder Core #" .. n .. " fuel level is ".. corefuel.breedercore[n])
		n=n+1
		end
	end
	local function pebblecores()
		local n=1
		for i=1, #pebblecore do
		corefuel.pebblecore[n] = pebblecore[n].checkFuel()
		print("Pebble Bed Core #" .. n .. " fuel level is ".. corefuel.pebblecore[n])
		n=n+1
		end
	end
term.clear()
fissioncores()
breedercores()
end

function setCoordsAll(coretype)
	corecoords = {}
	local function fissioncoords()
		corecoords.fissioncore = {}
		local n=1
		for i=1, #fissioncore do
			corecoords.fissioncore[n]={x=0, y=0, z=0}
			corecoords.fissioncore[n].x, corecoords.fissioncore[n].y, corecoords.fissioncore[n].z = fissioncore[n].getCoords()
			print("Fission Core #" .. n .. " coordinates are ".. corecoords.fissioncore[n].x .. ", " .. corecoords.fissioncore[n].y .. ", " .. corecoords.fissioncore[n].z)
			n=n+1
		end
	end
	local function breedercoords()
		corecoords.breedercore = {}
		local n=1
		for i=1, #breedercore do
			corecoords.breedercore[n]={x=0, y=0, z=0}
			corecoords.breedercore[n].x, corecoords.breedercore[n].y, corecoords.breedercore[n].z = breedercore[n].getCoords()
			print("Breeder Core #" .. n .. " coordinates are ".. corecoords.breedercore[n].x .. ", " .. corecoords.breedercore[n].y .. ", " .. corecoords.breedercore[n].z)
			n=n+1
		end
	end
	local function pebblecoords()
		corecoords.pebblecore = {}
		local n=1
		for i=1, #pebblecore do
			corecoords.pebblecore[n]={x=0, y=0, z=0}
			corecoords.pebblecore[n].x, corecoords.pebblecore[n].y, corecoords.pebblecore[n].z = pebblecore[n].getCoords()
			print("Pebble Bed Core #" .. n .. " coordinates are ".. corecoords.pebblecore[n].x .. ", " .. corecoords.pebblecore[n].y .. ", " .. corecoords.pebblecore[n].z)
			n=n+1
		end
	end

	if coretype == "breeder" then breedercoords()
	elseif coretype == "fission" then fissioncoords()
	elseif coretype == "pebble" then pebblecoords()
	else print("Invalid selection"); return
	end
	
end

-- local function wait(ticks) -- This actually is based on in game ticks(20 per second) 
-- local start = os.time() -- os.time() is based on in game ticks as well
--  while os.time() < start + ticks do -- Somehow this is broken, will use os.sleep() for less precise control for now
--  os.sleep(0)
--  end
-- end

local quitkey = string.byte("q")
local running = true
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
local checkAddress = {}
function unknownEvent()

end

function myEventHandlers.key_down(address, keypress, code, name)
	if (keypress == quitkey) then
	running = false
	end
end
function handleEvent(eventID, ...)
	if (eventID) then
		myEventHandlers[eventID](...)
	end
end


getAddresslist("fission")
getAddresslist("breeder")
getAddresslist("pebble")
os.sleep(3)
term.clear()
setCoordsAll("breeder")
setCoordsAll("fission")
setCoordsAll("pebble")
os.sleep(3)
event.listen("key_down", handleEvent)
-- Basic repeat giving some information, showing the basic functions of this program.
while running do
		term.clear()
		getTempall()
		os.sleep(2)
		term.clear()
		checkFuelall()
		print("Press q to quit")
		os.sleep(2)
end

