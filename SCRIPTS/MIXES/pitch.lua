if _transmitted_motor_pitch == nil then
  _transmitted_motor_pitch = 0
end

if _new_motor_pitch == nil then
  _new_motor_pitch = 0
end

if _motor_pitch_changed == nil then
  _motor_pitch_changed = false
end

local transmit_value = 0

local input =
    {
        { "mpitch switch", SOURCE},                -- user selects source (typically slider or knob)
    }

local output = {"mpitch", }

local function init_func()
end

local function run_func(switch)
  transmit_value = (_transmitted_motor_pitch * 2048) / 180  
  return transmit_value
end

return { input=input, output=output, run=run_func, init=init_func }