if _transmitted_motor_pitch == nil then
  _transmitted_motor_pitch = 0
end

if _transmitted_aoa == nil then
  _transmitted_aoa = 0
end


local transmit_value_pitch = 0
local transmit_value_aoa = 0
local timeCheck = false
local lastTime = -1000
local vchg = -1024

local input =
    {
        { "mpitch switch", SOURCE},                -- user selects source (typically slider or knob)
    }

local output = {"mpitch", "vchg", "aoa"}

local function init_func()
end

local function run_func(switch)
  if switch > 0 then
    lastTime = getTime()
    timeCheck = true
    vchg = 1024
  end

  if timeCheck then 
    if getTime() - lastTime > 100 then 
      timeCheck = false
      vchg = -1024
    end
  end
  transmit_value_pitch = (_transmitted_motor_pitch * 2048) / 180
  transmit_value_aoa = (_transmitted_aoa * 2048) / 180
  return transmit_value_pitch, vchg, transmit_value_aoa
end

return { input=input, output=output, run=run_func, init=init_func }