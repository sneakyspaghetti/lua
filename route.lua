local component = require("component")
local event = require("event")
local m = component.modem
m.open(80)
local port, message, to

--Make this into a file?
local AddressList = {
  {"voidminer", ADDR, 777}
  {"storemon", ADDR, 777}
  {"storedisplay", ADDR, 777}
  {"touchscreen", ADDR, 777}
}

function listen()
  local _,_,_,_,_,message = event.pull("modem_message")
  return message
end

function send(to,port,message)
  m.open(port)
  m.send(tostring(to),port,tostring(message))
  m.close(port)
end

function findRoute(message,AddressList)
  local addr
  local port
  local to = tonumber(string.sub(message,1,3))
  for i,value in pairs(AddressList[to]) do
    addr = value[2]
    port = value[3]
  end
  message = string.sub(message,4)
  return addr,port,message
end

while true do
  message = listen()
  to,port,message = findRoute(message,AddressList)
  send(to,port,message)
  message = nil
end
