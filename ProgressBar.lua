local term = require("term")
local component = require("component")
local colors = require("colors")
local hasMonitor = false
local monitor
local ProgressBar = {}
local FillColor = 0xD2691E
local EmptyColor = 0x0000FF
local TextColor = 0x000000

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

  monitor.setBackground(0xFFFFFF)
end
