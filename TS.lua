local component = require("component")
local event = require("event")
local term = require("term")
local unicode = require("unicode")
local gpu = component.gpu
local m = component.modem
m.open(776)

--Set resolution
local oldW, oldH = gpu.getResolution()
gpu.setResolution(41,10)
term.clear()

--Display screen, vars: buttonSelected
local selection = "Auto"
gpu.set(5,1,"Void Miner")
gpu.set(5,2,"Current State: " .. selection)

m.send(ADDR, 776, tostring(selection))

--a = width, b = depth
local x1 = 5
local x2 = 17
local x3 = 29
local y = 7
local a = 9
local b = 3

function drawBox(x,y,a,b,selection)
	--Draw border
	gpu.set(x,y,tostring(unicode.char(0x2554)))
	gpu.fill(x+1,y,a-2,1,tostring(unicode.char(0x2550)))
	gpu.set(x+a-1,y,tostring(unicode.char(0x2557)))
	gpu.set(x,y+1,tostring(unicode.char(0x2551)))
	gpu.set(x+a-1,y+1,tostring(unicode.char(0x2551)))
	gpu.set(x,y+b-1,tostring(unicode.char(0x255A)))
	gpu.fill(x,y+b-1,a-2,1,tostring(unicode.char(0x2550)))
	gpu.set(x+a-1,y+b-1,tostring(unicode.char(0x255D)))
	
	--Place text
	if selection == "Auto" then
		gpu.set(x+math.floor(b/2)-2,y+math.floor(a/2),"Auto")
	elseif selection == "On" then
		gpu.set(x+math.floor(b/2)-1,y+math.floor(a/2),"On")
	elseif selection == "Off" then
		gpu.set(x+math.floor(b/2)-2,y+math.floor(a/2),"Off")
	end
end

function buttons(selection)
	local oldColor = gpu.getBackground(false)
	if selection == "Auto" then
		gpu.setBackground(0x2575DD,false)
		gpu.fill(x1,y,a,b," ")
		drawBox(x1,y,a,b,selection)
	else
		gpu.setBackground(0xC9D7E9,false)
		gpu.fill(x1,y,a,b," ")
		drawBox(x1,y,a,b,selection)
	end
	if selection == "On" then
		gpu.setBackground(0x2ECC71,false)
		gpu.fill(x2,y,a,b," ")
		drawBox(x2,y,a,b,selection)
	else	
		gpu.setBackground(0xCAECC6,false)
		gpu.fill(x2,y,a,b," ")
		drawBox(x2,y,a,b,selection)
	end
	if selection == "Off" then
		gpu.setBackground(0xE41C19,false)
		gpu.fill(x3,y,a,b," ")
		drawBox(x3,y,a,b,selection)
	else
		gpu.setBackground(0xEEBDBD,false)
		gpu.fill(x3,y,a,b," ")
		drawBox(x3,y,a,b,selection)
	end
	gpu.setBackground(oldColor,false)
end

buttons(selection)

--while true do

--Wait for input: event.pull("touch", x, y, "playerName") 
local _, xtouch, ytouch = event.pull("touch", nil, nil)
if xtouch >= x1 and xtouch <= x1+a-1 then
	if ytouch >= y and ytouch <= y+b-1 then
	  selection = "Auto"
	end
elseif xtouch >= x2 and xtouch <= x2+a-1 then
	if ytouch >= y and ytouch <= y+b-1 then
		selection = "On"
	end
elseif xtouch >= x3 and xtouch <= x3+a-1 then
	if ytouch >= y and ytouch <= y+b-1 then
		selection = "Off"
	end
end

--Refresh screen
buttons(selection)

--Send signal: m.send(addr, port, "message") 
m.send(ADDR, 776, tostring(selection))

os.sleep(5)
gpu.setResolution(oldW,oldH)
--end
