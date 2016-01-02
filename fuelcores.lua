--Local requirements for OpenComputers API
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
local curmenu = "TopMenu"

function unknownEvent() -- I handle mystery events and do nothing... Like my ex!

end

function myEventHandlers.key_down(address, keypress, code, name) --Handles key_down menu navigation
	if curmenu == "quitmenu" then
		if (keypress == quitkey) then running = false end
	end
end


function handleEvent(eventID, ...) -- I will mow your lawn for 5 dollars
	if (eventID) then
		myEventHandlers[eventID](...)
	end
end


function SetPeripheral() -- Why do I have this here?
  screen = component.screen.isOn() -- Is the screen on? How the hell did you get here?
  if screen then
    monitor = component.gpu
    hasMonitor = true -- Oh well, you have a screen. I guess you can do things now.
  end
end

function SetTable(name, maxVal, curVal, xmin, xmax, y)
  ProgressBar[name] = {}
  ProgressBar[name]["Max"] = maxVal -- End of the bar
  ProgressBar[name]["Current"] = curVal -- Unable to determine this value(Current value maybe?)
  ProgressBar[name]["XMin"] = xmin -- This is the location of the start of the bar
  ProgressBar[name]["XMax"] = xmax -- End of the bar
  ProgressBar[name]["YVal"] = y -- How far down from the top
end

function ClearTable() -- Please clean up your messes!
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
	handleEvent(event.pull(1.5))
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
	handleEvent(event.pull(1.5))
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
	handleEvent(event.pull(1.5))
	end

	if coretype == "breeder" then breedercores()
		elseif coretype == "fission" then fissioncores()
		elseif coretype == "pebble" then pebblecores()
		else print("Invalid selection")
	end
end



function getTemp(coretype)
	running = true
	curmenu="quitmenu"
	coretemp = {}
	coretemp.fissioncore = {}
	coretemp.breedercore = {}
	coretemp.pebblecore = {}
	local function header()
		term.setCursor(1,1)
		term.write("Temp. in Celcius")
		monitor.setBackground(EmptyColor)
		term.setCursor(23,1)
		term.write("0C ")
		term.setCursor(25,1)
		monitor.setBackground(FillColor)
		term.write("[                                                 ")
		term.setCursor(75,1)
		monitor.setBackground(EmptyColor)
		term.write("] 1800C")
		monitor.setBackground(0x000000)
	end
	local function fissioncores()
		local n=1
		local yCur=2
		local name = n
		term.clear()
		header()
		for i=1, #fissioncore do
			local corename = ("Fission Core #" .. n)
			coretemp.fissioncore[n] = fissioncore[n].getTemperature()
			SetTable(name,1800,coretemp.fissioncore[n],25,75,yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
	--		print("Fission Core #" .. n .. " temperature is ".. coretemp.fissioncore[n])
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		while running do
			local n=1
			local yCur=2
			term.clear()
			header()
			for i=1, #fissioncore do
				local name=n
				local corename=("Fission core #"..n)
				coretemp.fissioncore[n]=fissioncore[n].getTemperature()
				SetCurValue(name,coretemp.fissioncore[n])
				term.setCursor(1, yCur)
				term.write(corename, false)
				n=n+1
				yCur=yCur+1
			end
			DrawToPeripheral()
			handleEvent(event.pull(2))	
		end
		ClearTable()
		term.clear()
		topMenu()
	end
	local function breedercores()
		local n=1
		local yCur=2
		term.clear()
		header()
		for i=1, #breedercore do
			local name=n
			local corename=("Breeder core #"..n)
			coretemp.breedercore[n] = breedercore[n].getTemperature()
			SetTable(name,1800,coretemp.breedercore[n],25,75,yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		while running do
			local n=1
			local yCur=2
			term.clear()
			header()
			for i=1, #breedercore do
				local corename=("Breeder core #"..n)
				coretemp.breedercore[n]=breedercore[n].getTemperature()
				local name=n
				SetCurValue(name,coretemp.breedercore[n])
				term.setCursor(1, yCur)
				term.write(corename, false)
				n=n+1
				yCur=yCur+1
			end
			DrawToPeripheral()
			handleEvent(event.pull(2))	
		end
		ClearTable()
		term.clear()
		topMenu()
	end
	local function pebblecores()
		local yCur=2
		local n=1
		term.clear()
		header()
		for i=1, #pebblecore do
			local name=n
			local corename=("Pebble bed core #"..n)
			coretemp.pebblecore[n] = pebblecore[n].getTemperature()
			SetTable(name,1800,coretemp.pebblecore[n],25,75,yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)		
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		while running do
			local n=1
			local yCur=2
			header()
			for i=1, #pebblecore do
				local corename=("Pebble bed core #"..n)
				coretemp.pebblecore[n] = pebblecore[n].getTemperature()
				local name=n
				SetCurValue(name,coretemp.pebblecore[n])
				term.setCursor(1, yCur)
				term.write(corename, false)
				n=n+1
				yCur=yCur+1
			end
			DrawToPeripheral()
			handleEvent(event.pull(2))		
		end
		ClearTable()
		term.clear()
		topMenu()
	end
	if coretype == "fission" then fissioncores()
		elseif coretype == "breeder" then breedercores()
		elseif coretype == "pebble" then pebblecores()
		else print("Invalid")
	end
end

--function getTemp(n)
--	coretemp={}
--	term.clear()
--	if not n then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end
--	if n<=0 or n>(#fissioncore) then return print("Please enter a number between " .. n .. " and " .. #fissioncore) end 
--	coretemp[n] = fissioncore[n].getTemperature()
--	print("Core #" .. n .. " temperature is ".. coretemp[n])	
--end


	
--function checkFuel(n)
--	corefuel={}
--	term.clear()
--	if not n then return print("Please enter a number between 1 and " .. #fissioncore) end
--	if n<=0 or n>(#fissioncore) then return print("Please enter a number between 1 and " .. #fissioncore) end 
--	corefuel[n] = fissioncore[n].checkFuel()
--	print("Core #" .. n .. " fuel level is ".. corefuel[n])
--end

	
function checkFuel(coretype)
	running = true
	curmenu="quitmenu"
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
	while running do
		local n=1
		local yCur=2
		header()
		for i=1, #fissioncore do
			local corename = ("Fission Core #" .. n)
			local name = n
			corefuel.fissioncore[n] = fissioncore[n].checkFuel()
			corefuel.fissioncore[n] = tonumber(string.match(corefuel.fissioncore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.fissioncore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		handleEvent(event.pull(3))
	end
	ClearTable()
	term.clear()
	topMenu()
	end
	
	local function breedercores()
	while running do
		local n=1
		local yCur=2
		header()
		for i=1, #breedercore do
			local corename = ("Breeder Core #".. n)
			local name = n
			corefuel.breedercore[n] = breedercore[n].checkFuel()
			corefuel.breedercore[n] = tonumber(string.match(corefuel.breedercore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.breedercore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		handleEvent(event.pull(3))
	end
	ClearTable()
	term.clear()
	topMenu()
	end
	local function pebblecores()
	while running do
		local n=1
		local yCur=2
		header()
		for i=1, #pebblecore do
			local corename = ("Pebble bed core #".. n)
			local name = n
			corefuel.pebblecore[n] = pebblecore[n].checkPebbleLevel()
			corefuel.pebblecore[n] = tonumber(string.match(corefuel.pebblecore[n], "%d.%d+")) * 100
			SetTable(name, 100, corefuel.pebblecore[n], 25, 75, yCur)
			term.setCursor(1, yCur)
			term.write(corename, false)
			n=n+1
			yCur=yCur+1
		end
		DrawToPeripheral()
		handleEvent(event.pull(3))
	end
	ClearTable()
	term.clear()
	topMenu()	
	end
term.clear()
if coretype == "fission" then fissioncores()
	elseif coretype == "breeder" then breedercores()
	elseif coretype == "pebble" then pebblecores()
	else print("Invalid")
end
end
function setCoords(coretype)
	corecoords = {}
	local function fissioncoords()
		corecoords.fissioncore = {}
		local n=1
		for i=1, #fissioncore do
			corecoords.fissioncore[n]={x=0, y=0, z=0}
			corecoords.fissioncore[n].x, corecoords.fissioncore[n].y, corecoords.fissioncore[n].z = fissioncore[n].getCoords()
			term.setCursor(55,1)
			term.write("Fission Core #" .. n .. " coordinates are ")
			monitor.setForeground(0xFF0000)
			term.write(corecoords.fissioncore[n].x)
			term.write(",")
			term.write(corecoords.fissioncore[n].y)
			term.write(", ")
			term.write(corecoords.fissioncore[n].z)
			monitor.setForeground(0xFFFFFF)
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
function adress()
	getAddresslist("fission")
	getAddresslist("breeder")
	getAddresslist("pebble")
	handleEvent(event.pull(1))
end
function coords()
	setCoords("fission")
	setCoords("breeder")
	setCoords("pebble")
	handleEvent(event.pull(1))
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
function colorGreen(x,y,length,string)
	term.setCursor(x,y)
	monitor.setForeground(0x006400)
	for i=1, length do
		term.write(string,false)
	end
	monitor.setForeground(0xFFFFFF)
end

function rcsTopMenuSplash()
	local rcsmenuvarR = {[1]={55,10,6,"R"},[2]={55,11,6,"R"},[3]={55,12,2,"R"},[4]={57,12,3," "},[5]={60,12,1,"R"},[6]={55,13,2,"R"},[7]={57,13,3," "},[8]={60,13,1,"R"},[9]={55,14,6,"R"},[10]={55,15,2,"R"},[11]={57,15,1," "},[12]={58,15,1,"R"},[13]={55,16,2,"R"},[14]={57,16,2," "},[15]={59,16,1,"R"},[16]={55,17,2,"R"},[17]={57,17,3," "},[18]={60,17,1,"R"}
	}
	local rcsmenuvarC = {[1]={62,10,6,"C"},[2]={62,11,6,"C"},[3]={62,12,2,"C"},[4]={62,13,2,"C"},[5]={62,14,2,"C"},[6]={62,15,2,"C"},[7]={62,16,6,"C"},[8]={62,17,6,"C"}}
	local rcsmenuvarS = {[1]={69,10,6,"S"},[2]={69,11,6,"S"},[3]={69,12,2,"S"},[4]={69,13,6,"S"},[5]={69,14,6,"S"},[6]={73,15,2,"S"},[7]={69,16,6,"S"},[8]={69,17,6,"S"}}
	local yCur=1
	term.clear()
	for i=1, #rcsmenuvarR do 
		colorBlue(table.unpack(rcsmenuvarR[yCur]))
		yCur=yCur+1
	end
	local yCur=1	
	for i=1, #rcsmenuvarC do
		colorRed(table.unpack(rcsmenuvarC[yCur]))
		yCur=yCur+1
	end
	local yCur=1
	for i=1, #rcsmenuvarS do
		colorGreen(table.unpack(rcsmenuvarS[yCur]))
		yCur=yCur+1
	end
	term.setCursor(55,19)
	print("Reactor Control System")
	term.setCursor(45,20)
	for i=1, 40 do
		term.write("_")
	end
end

function topMenu()
	curmenu="topMenu"
	rcsTopMenuSplash()
	term.setCursor(55,21)
	term.write("1.")
	term.write(" Temperature monitor submenu")
	term.setCursor(55,22)
	term.write("2.")
	term.write(" Remaining fuel submenu")
	term.setCursor(55,23)
	term.write("3.")
	term.write(" Misc. submenu")
	term.setCursor(57,27)
	term.setCursorBlink(true)
	readstr = tonumber(string.match(io.read(),"%d"))
	if readstr == 1 then subMenuOne() 
		elseif readstr == 2 then subMenuTwo() 
		elseif readstr == 3 then miscMenu() 
		else print("Invalid") 
		os.sleep(1) 
		term.clear() 
		topMenu() 
	end
end

function subMenuOne()
	curmenu="subMenuOne"
	rcsTopMenuSplash()
	term.setCursor(55,21)
	term.write("1.")
	term.write(" Hybrid reactor temperature monitoring")
	term.setCursor(55,22)
	term.write("2.")
	term.write(" Breeder reactor temperature monitoring")
	term.setCursor(55,23)
	term.write("3.")
	term.write(" Pebble bed reactor temperature monitoring")
	term.setCursor(57,27)
	term.setCursorBlink(true)
	readstr = tonumber(string.match(io.read(),"%d"))
	if readstr == 1 then getTemp("fission") 
		elseif readstr == 2 then getTemp("breeder")
		elseif readstr == 3 then getTemp("pebble") 
		else print("Invalid") 
		os.sleep(1)
		term.clear()
		subMenuOne()		
	end
	
end

function subMenuTwo()
	curmenu="subMenuTwo"
	rcsTopMenuSplash()
	term.setCursor(55,21)
	term.write("1.")
	term.write(" Hybrid reactor fuel monitoring")
	term.setCursor(55,22)
	term.write("2.")
	term.write(" Breeder reactor fuel monitoring")
	term.setCursor(55,23)
	term.write("3.")
	term.write(" Pebble bed reactor fuel monitoring")
	term.setCursor(57,27)
	term.setCursorBlink(true)
	readstr = tonumber(string.match(io.read(),"%d"))
	if readstr == 1 then checkFuel("fission")
		elseif readstr == 2 then checkFuel("breeder")
		elseif readstr == 3 then checkFuel("pebble")
		else print("Invalid")
		os.sleep(1)
		term.clear()
		subMenuTwo()
	end
end

function miscMenu()
	curmenu="miscMenu"
	rcsTopMenuSplash()
	term.setCursor(55,21)
	term.write("1.")
	term.setCursor(55,22)
	term.write("2.")
	term.setCursor(55,23)
	term.write("3.")
	term.setCursor(57,27)
	term.setCursorBlink(true)
	readstr=tonumber(string.match(io.read(),"%d"))
	if readstr == 1 then 
		elseif readstr == 2 then
		elseif readstr == 3 then
		else print("Invalid")
		os.sleep(1)
		term.clear()
		topMenu()
	end
end
SetPeripheral()
adress()
topMenu()

--term.clear()
--setCoords("breeder")
--setCoords("fission")
--setCoords("pebble")
--handleEvent(event.pull(3))
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

