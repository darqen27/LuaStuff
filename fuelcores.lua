local component = require("component")
local term = require("term")
local keyboard = require("keyboard")
local computer = require("computer")
local event = require("event")
--ProgressBarAPI
local hasMonitor = false
local monitor
local ProgressBar = {}
local FillColor = 0xD2691E
local EmptyColor = 0x0000FF
local TextColor = 0xFFFFFF

function SetPeripheral()
  screen = component.screen.isOn()
  if screen then
    monitor = component.gpu
    hasMonitor = true
  end
end

function SetTable(name, maxVal, curVal, xmin, xmax, y)
  ProgressBar[name] = {}
  ProgressBar[name]["Max"] = maxVal
  ProgressBar[name]["Current"] = curVal
  ProgressBar[name]["XMin"] = xmin
  ProgressBar[name]["XMax"] = xmax
  ProgressBar[name]["YVal"] = y
end

function ClearTable()
  if (hasMonitor) then
    ProgressBar = {}
  end
end

function SetFillColor(color)
  if color then  
    FillColor = color
  end
end

function SetEmptyColor(color)
  if color then
    EmptyColor = color
  end
end

function SetTextColor(color)
  if color then
    TextColor = color
  end
end

function SetMaxValue(name, intVal)
  if (ProgressBar[name]) then
    ProgressBar[name]["Max"] = intVal
  end
end

function SetCurValue(name, intVal)
  if (ProgressBar[name]) then
    ProgressBar[name]["Current"] = intVal
  end
end

function DrawToPeripheral()
  if (hasMonitor) then
    for name, data in pairs(ProgressBar) do
      DrawBar(name, data)
    end
  end
end

function DrawBar(name, arr)
  local y = arr["YVal"]
  local fill = math.floor((arr["XMax"] - arr["XMin"]) * (arr["Current"] / arr["Max"]))

  monitor.setBackground(FillColor)
  monitor.setForeground(TextColor)

  for x = arr["XMin"], arr["XMax"] do
    local num = math.floor(x - arr["XMin"])
    term.setCursor(x,y)

    if (num > fill) then
      monitor.setBackground(EmptyColor)
    end

    if (num == 0) then
      term.write("[")
    end
    if (x == arr["XMax"]) then
      term.write("]")
    else
      term.write(" ")
    end
  end

  monitor.setBackground(0x000000)
end


-- FuelcoresAPI
function getAddresslist(coretype) -- Too many identical names, must set proxies to be able to interact with all of the different core's.
	local function fissioncores()
		term.clear()
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
	os.sleep(1)
	end
	local function breedercores()
		term.clear()
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
	os.sleep(1)
	end

	local function pebblecores()
		term.clear()
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
	os.sleep(1)
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
	coretemp.pebblecore = {}
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
	local function pebblecores()
		local n=1
		for i=1, #pebblecore do
		coretemp.pebblecore[n] = pebblecore[n].getTemperature()
		print("Pebble bed core #" .. n .. " temperature is " .. coretemp.pebblecore[n])
		n=n+1
		end
	end
fissioncores()
breedercores()
pebblecores()
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
		local yCur=2
		monitor.setBackground(EmptyColor)
		term.setCursor(22,1)
		term.write("0%");term.setCursor(77,1);term.write("100%")
		monitor.setBackground(0x000000)
		for i=1, #fissioncore do
			local corename = ("Fission Core #" .. n)
			local name = n
			corefuel.fissioncore[n] = fissioncore[n].checkFuel()
			corefuel.fissioncore[n] = tonumber(string.match(corefuel.fissioncore[n], "%d.%d+")) * 100
--		print("Fission Core #" .. n .. " fuel level is ".. corefuel.fissioncore[n] .. "%")
			SetTable(name, 100, corefuel.fissioncore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		os.sleep(3)
		ClearTable()
		term.clear()
	end
	
	local function breedercores()
		local n=1
		local yCur=2
		monitor.setBackground(EmptyColor)
		term.setCursor(22,1)
		term.write("0%");term.setCursor(77,1);term.write("100%")
		monitor.setBackground(0x000000)
		for i=1, #breedercore do
			local corename = ("Breeder Core #".. n)
			local name = n
			corefuel.breedercore[n] = breedercore[n].checkFuel()
			corefuel.breedercore[n] = tonumber(string.match(corefuel.breedercore[n], "%d.%d+")) * 100
--		print("Breeder Core #" .. n .. " fuel level is ".. corefuel.breedercore[n] .. "%")
			SetTable(name, 100, corefuel.breedercore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		os.sleep(3)
		ClearTable()
		term.clear()
	end
	local function pebblecores()
		local n=1
		local yCur=2
		monitor.setBackground(EmptyColor)
		term.setCursor(22,1)
		term.write("0%");term.setCursor(77,1);term.write("100%")
		monitor.setBackground(0x000000)
		for i=1, #pebblecore do
			local corename = ("Pebble bed core #".. n)
			local name = n
			corefuel.pebblecore[n] = pebblecore[n].checkPebbleLevel()
			corefuel.pebblecore[n] = tonumber(string.match(corefuel.pebblecore[n], "%d.%d+")) * 100
--		print("Pebble Bed Core #" .. n .. " fuel level is ".. corefuel.pebblecore[n] .. "%")
			SetTable(name, 100, corefuel.pebblecore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		os.sleep(3)
		ClearTable()
		term.clear()
	end
term.clear()
fissioncores()
breedercores()
pebblecores()
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
os.sleep(1)
term.clear()
setCoordsAll("breeder")
setCoordsAll("fission")
setCoordsAll("pebble")
os.sleep(1)
event.listen("key_down", handleEvent)
SetPeripheral()

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

