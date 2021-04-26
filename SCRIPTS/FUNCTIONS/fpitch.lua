if _new_motor_pitch == nil then
  _new_motor_pitch = 0
end

if _transmitted_motor_pitch == nil then
  _transmitted_motor_pitch = 0
end

if _motor_pitch_changed == nil then
  _motor_pitch_changed = false
end

local function init_func()
end

local function run_func()
  if _motor_pitch_changed == false then
    return
  end
  
  playFile("nmp6.wav")
  playNumber(_new_motor_pitch, 20, 0)
  
  _transmitted_motor_pitch = _new_motor_pitch
  _motor_pitch_changed = false
end

return { run=run_func, init=init_func }