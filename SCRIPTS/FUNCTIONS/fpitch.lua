if _new_motor_pitch == nil then
  _new_motor_pitch = 0
end

if _transmitted_motor_pitch == nil then
  _transmitted_motor_pitch = 0
end

if _new_aoa == nil then
  _new_aoa = 0
end

if _transmitted_aoa == nil then
  _transmitted_aoa = 0
end


local function init_func()
end

local function run_func()
  if _new_motor_pitch == _transmitted_motor_pitch and _new_aoa == _transmitted_aoa then
    return
  end
  
  if _new_motor_pitch ~= _transmitted_motor_pitch then
    playFile("nmp6.wav")
    playNumber(_new_motor_pitch, 20, 0)
  end
  if _new_aoa ~= _transmitted_aoa then
    playNumber(_new_aoa, 20, 0)
  end
  
  _transmitted_motor_pitch = _new_motor_pitch
  _transmitted_aoa = _new_aoa
end

return { run=run_func, init=init_func }