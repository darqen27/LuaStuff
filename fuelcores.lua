
local component = require("component")
local term = require("term")
local keyboard = require("keyboard")
local computer = require("computer")
local event = require("event")


function getAddresslist(coretype) -- Too many identical names, must set proxies to be able to interact with all of the Fuel Core's.
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
				if k == nil then return false
				else compaddresslist[n]=k
				breedercore[n] = component.proxy(compaddresslist[n])
				print("Breeder core #" .. n .." address assigned.") 
				n=n+1
				end
		end
	end
	if coretype == "breeder" then breedercores()
	elseif coretype == "fission" then fissioncores()
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
	if coretype == "breeder" then breedercoords()
	elseif coretype == "fission" then fissioncoords()
	else print("Invalid selection"); return
	end
	
end

function wait(ticks) -- This actually is based on in game ticks(20 per second) 
  local start = os.time()
  while os.time() < start + ticks do
  os.sleep(0)
  end
end


	
getAddresslist("breeder")
getAddresslist("fission")
wait(200)
term.clear()
setCoordsAll("breeder")
setCoordsAll("fission")
wait(200)
-- Basic repeat giving some information, showing the basic functions of this program.
while true do
		event.listen("key_down", stopme(key))
		local function stopme(key)
			if key ~= keyboard.isKeyDown(keyboard.keys.q) then return end	
		end
		term.clear()
		getTempall()
		wait(100)
		term.clear()
		checkFuelall()
		wait(200)
end
