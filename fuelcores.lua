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
local quitkey = string.byte("q")
local numone = string.byte("1")
local running = true
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
--local checkAddress = {}
function unknownEvent()

end

function myEventHandlers.key_down(address, keypress, code, name)
	if (keypress == quitkey) then running = false
	elseif (keypress == numone) then 
	end
end


function handleEvent(eventID, ...)
	if (eventID) then
		myEventHandlers[eventID](...)
	end
end


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
		term.setCursor(50,1)
		monitor.setForeground(0x0000FF)
		print("Getting fission core addresses.")
		monitor.setForeground(0xFFFFFF)
		local compaddresslist = {}
		fissioncore = {}
		local n=1
		local yCur=2
			for k,v in pairs(component.list("FuelCore")) do
			compaddresslist[n] = k
			fissioncore[n] = component.proxy(compaddresslist[n])
			term.setCursor(50,yCur)
			monitor.setForeground(0xFF0000)
			print("Fission core #" .. n .." address assigned.")
			monitor.setForeground(0xFFFFFF) 
			n = n+1
			yCur=yCur+1							
		end
	if fissioncore[1] == nil then print("No fission cores detected!") end
	handleEvent(event.pull(1))
	end
	local function breedercores()
		term.clear()
		term.setCursor(50,1)
		monitor.setForeground(0x0000FF)
		print("Getting breeder core addresses.")
		monitor.setForeground(0xFFFFFF)
		local compaddresslist = {}
		breedercore = {}
		local n=1
		local yCur=2
			for k,v in pairs(component.list("Breeder")) do				
			compaddresslist[n]=k
			breedercore[n] = component.proxy(compaddresslist[n])
			term.setCursor(50,yCur)
			monitor.setForeground(0xFF0000)
			print("Breeder core #" .. n .." address assigned.") 
			monitor.setForeground(0xFFFFFF) 
			n=n+1
			yCur=yCur+1				
		end
	if breedercore[1] == nil then print("No breeder cores detected!") end
	handleEvent(event.pull(1))
	end

	local function pebblecores()
		term.clear()
		term.setCursor(50,1)
		monitor.setForeground(0x0000FF)
		print("Getting pebble bed core addresses.")
		monitor.setForeground(0xFFFFFF)
		local compaddresslist = {}
		pebblecore = {}
		local n=1
		local yCur=2
			for k,v in pairs(component.list("Pebble")) do
			compaddresslist[n]=k
			pebblecore[n] = component.proxy(compaddresslist[n])
			term.setCursor(50,yCur)
			monitor.setForeground(0xFF0000)
			print("Pebble bed core #" .. n .." address assigned.") 
			monitor.setForeground(0xFFFFFF)
			n=n+1
			yCur=yCur+1					
		end
	if pebblecore[1] == nil then print("No pebble bed cores detected!") end
	handleEvent(event.pull(1))
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

--function getTemp(n)
--	coretemp={}
--	term.clear()
--	if not n then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end
--	if n<=0 or n>(#fissioncore) then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end 
--	coretemp[n] = fissioncore[n].getTemperature()
--	print("Core #" .. n .. " temperature is ".. coretemp[n])	
--end


	
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
	local function header()
		term.setCursor(1,1)
		term.write("Fuel in percent.")
		monitor.setBackground(EmptyColor)
		term.setCursor(23,1)
		term.write("0% ")
		term.setCursor(25,1)
		monitor.setBackground(FillColor)
		term.write("[                                                 ")
		term.setCursor(75,1)
		monitor.setBackground(EmptyColor)
		term.write("] 100%")
		monitor.setBackground(0x000000)
	end

	local function fissioncores()
		local cna = #fissioncore
		local n=1
		local yCur=2
		header()
		for i=1, cna do
			local corename = ("Fission Core #" .. n)
			local name = n
			corefuel.fissioncore[n] = fissioncore[n].checkFuel()
			corefuel.fissioncore[n] = tonumber(string.match(corefuel.fissioncore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.fissioncore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		handleEvent(event.pull(3))
		ClearTable()
		term.clear()
	end
	
	local function breedercores()
		local cna = #breedercore
		local n=1
		local yCur=2
		header()
		for i=1, cna do
			local corename = ("Breeder Core #".. n)
			local name = n
			corefuel.breedercore[n] = breedercore[n].checkFuel()
			corefuel.breedercore[n] = tonumber(string.match(corefuel.breedercore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.breedercore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		handleEvent(event.pull(3))
		ClearTable()
		term.clear()
	end
	local function pebblecores()
		local cna = #pebblecore
		local n=1
		local yCur=2
		header()
		for i=1, cna do
			local corename = ("Pebble bed core #".. n)
			local name = n
			corefuel.pebblecore[n] = pebblecore[n].checkPebbleLevel()
			corefuel.pebblecore[n] = tonumber(string.match(corefuel.pebblecore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.pebblecore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			DrawToPeripheral()
			n=n+1
			yCur=yCur+1
		end
		handleEvent(event.pull(3))
		ClearTable()
		term.clear()
	end
term.clear()
fissioncores()
breedercores()
pebblecores()
end

function setCoords(coretype)
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
function colorRed(x,y,length,string)
	term.setCursor(x,y)
	monitor.setForeground(0xFF0000)
	for i=1, length do
		term.write(string, false)
	end
	monitor.setForeground(0xFFFFFF)		
end
function colorBlue(x,y,length,string)
	term.setCursor(x,y)
	monitor.setForeground(0x0000FF)
	for i=1, length do
		term.write(string, false)
	end
	monitor.setForeground(0xFFFFFF)		
end

function rcsTopMenu()
	local yCur=10
	for i=10,17,1 do 
	colorBlue(60,yCur,6,"R")
	yCur=yCur+1
	end	
end
SetPeripheral()
rcsTopMenu()
--getAddresslist("fission")
--getAddresslist("breeder")
--getAddresslist("pebble")
--handleEvent(event.pull(1))
--term.clear()
--setCoords("breeder")
--setCoords("fission")
--setCoords("pebble")
handleEvent(event.pull(3))
-- event.listen("key_down", handleEvent) This only works after the loop ends

-- Basic repeat giving some information, showing the basic functions of this program.
--while running do
--		term.clear()
--		getTempall()
--		print("Press q to quit")
--		handleEvent(event.pull(2))
--		checkFuelall()
--		print("Press q to quit")
--		handleEvent(event.pull(2))
--end

