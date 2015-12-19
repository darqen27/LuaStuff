
local component = require("component")
local term = require("term")
local keyboard = require("keyboard")
local computer = require("computer")
-- local event = require("events") Future use with component.modem()


function getAddresslist() -- Too many identical names, must set proxies to be able to interact with all of the Fuel Core's.
	local function fissioncores()
		print("Getting fisson core addresses")
		local compaddresslist = {}
		fissioncore = {}
		local n = 1
		for k,v in pairs(component.list("FuelCore")) do
		compaddresslist[n] = k
		fissioncore[n] = component.proxy(compaddresslist[n])
		print("Fission core #" .. n .." address assigned.") 
		n = n+1
		end
	end
	local function breedercores()
		print("Getting breeder core addresses")
		local compaddresslist = {}
		breedercore = {}
		local n=1
		for k,v in pairs(component.list("Breeder")) do
		if k == nil then 
			return false
			else
			compaddresslist[n]=k
			breedercore[n] = component.proxy(compaddresslist[n])
			print("Breeder core #" .. n .." address assigned.") 
			n=n+1
			end
		end
	end
fissioncores()
breedercores()
end



function getTempall()
	coretemp={}
	term.clear()
	local n=1
	for i=1, #fissioncore do
	coretemp[n] = fissioncore[n].getTemperature()
	print("Core #" .. n .. " temperature is ".. coretemp[n])
	n=n+1
	end
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
	term.clear()
	local n=1
	for i=1, #fissioncore do
	corefuel[n] = fissioncore[n].checkFuel()
	print("Core #" .. n .. " fuel level is ".. corefuel[n])
	n=n+1
	end
end

function setCoordsAll()
	corecoords = {}
	local n=1
	for i=1, #fissioncore do
	corecoords[n]={x=0, y=0, z=0}
	corecoords[n].x, corecoords[n].y, corecoords[n].z = fissioncore[n].getCoords()
	print("Core #" .. n .. " coordinates are ".. corecoords[n].x .. ", " .. corecoords[n].y .. ", " .. corecoords[n].z)
	n=n+1
	end
end

function wait(ticks) -- This actually is based on in game ticks(20 per second) 
  local start = os.time()
  while os.time() < start + ticks do
  os.sleep(0)
  end
end


	
getAddresslist()
setCoordsAll()
wait(200)
-- Basic repeat giving some information, showing the basic functions of this program.
repeat
term.clear()
getTempall()
checkFuelall()
wait(30)
until keyboard.isKeyDown(keyboard.keys.q)


