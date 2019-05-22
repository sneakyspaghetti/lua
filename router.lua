local component = require("component")
local event = require("event")
local m = component.modem

local filepath = "hosts.txt"

function readNames()
  local Hostnames = {}
  local file = io.open(filepath,"r")
  for line in file:lines() do
    local name, addr = line:match("(%S+):(%S+)")
    local arr = {name, addr}
    table.insert(Hostnames, arr)
  end
  file:close()
  return Hostnames
end

function findAddr(host, Hostnames)
  local address = nil
  for _, j in ipairs(Hostnames) do
    for i,_ in pairs(j) do
      if j[i] == host then
        address = j[i+1]
      end
    end
  end
  return address
end

function splitMessage(message)
  local host, msg = message:match("(%S+):(%S+)")
  return host, msg
end

while true do

local Hostnames = readNames()
local _, _, from, port, _, message = event.pull("modem_message")
local host, msg = splitMessage(message)
local address = findAddr(host, Hostnames)
if address and msg then
  m.send(address, port, msg)
  m.send(from, port, "Message sent")
end

end
