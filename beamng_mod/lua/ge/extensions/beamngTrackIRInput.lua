local M = {}

local logTag = "beamngTrackIRInput"
local listenPort = 4447
local udpSocket = nil
local deviceInst = nil
local lastPacketTime = 0
local last = {0, 0, 0}

local function clamp(value, low, high)
  if value < low then return low end
  if value > high then return high end
  return value
end

local function createDevice()
  if deviceInst ~= nil then return end
  if not extensions.core_input_virtualInput then
    log("E", logTag, "core_input_virtualInput extension is not available")
    return
  end

  deviceInst = extensions.core_input_virtualInput.createDevice("SpaceMouse Pro", "c62b046d", 6, 2, 0)
  if deviceInst then
    log("I", logTag, "registered virtual SpaceMouse Pro as vinput" .. tostring(deviceInst))
  end
end

local function emitAxis(index, value)
  if not deviceInst then return end
  extensions.core_input_virtualInput.emit(deviceInst, "axis", index, "change", clamp(value, -1, 1))
end

local function emitPose(yaw, pitch, roll)
  -- Axis order follows BeamNG's virtual device axis indices:
  -- 0=xaxis, 1=yaxis, 2=zaxis, 3=rxaxis, 4=ryaxis, 5=rzaxis.
  emitAxis(0, 0)
  emitAxis(1, 0)
  emitAxis(2, 0)
  emitAxis(3, pitch)
  emitAxis(4, roll)
  emitAxis(5, yaw)
end

local function parsePacket(data)
  local yaw, pitch, roll = data:match("^BTR1%s+([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)")
  if not yaw then return end
  return tonumber(yaw), tonumber(pitch), tonumber(roll)
end

local function onExtensionLoaded()
  createDevice()

  udpSocket = socket.udp()
  if not udpSocket then
    log("E", logTag, "unable to create UDP socket")
    return
  end

  if udpSocket:setsockname("*", listenPort) == nil then
    log("E", logTag, "unable to bind UDP port " .. tostring(listenPort))
    udpSocket = nil
    return
  end

  udpSocket:settimeout(0)
  log("I", logTag, "listening for TrackIR pose packets on UDP " .. tostring(listenPort))
end

local function onExtensionUnloaded()
  if deviceInst and extensions.core_input_virtualInput then
    extensions.core_input_virtualInput.deleteDevice(deviceInst)
  end
  deviceInst = nil
  udpSocket = nil
end

local function onUpdate()
  if not udpSocket then return end

  while true do
    local data = udpSocket:receive(128)
    if not data then break end

    local yaw, pitch, roll = parsePacket(data)
    if yaw then
      last[1], last[2], last[3] = yaw, pitch, roll
      lastPacketTime = Engine.Platform.getSystemTimeMS()
      emitPose(yaw, pitch, roll)
    end
  end

  if lastPacketTime ~= 0 and Engine.Platform.getSystemTimeMS() - lastPacketTime > 500 then
    emitPose(0, 0, 0)
    lastPacketTime = 0
  end
end

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded
M.onUpdate = onUpdate

return M
