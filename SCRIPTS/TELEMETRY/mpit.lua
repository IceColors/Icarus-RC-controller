
local last = -10


-- in deg?
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

-- called in the background even when screen is visible
local function bg_func()

end

-- called periodically when screen is visible
local function run_func(event)
  local inc_val = 1
  
  if event == EVT_ROT_LEFT or  event == EVT_ROT_RIGHT then
    local currTime = getTime()
    if currTime - last < 10 then
      inc_val = 5
    end
    last = currTime
    _motor_pitch_changed = true
  end
  
  if event == EVT_ROT_LEFT then
    _new_motor_pitch = _new_motor_pitch + inc_val
  elseif event == EVT_ROT_RIGHT then
   _new_motor_pitch = _new_motor_pitch - inc_val
  end
  
  if _new_motor_pitch < -90 then
    _new_motor_pitch = -90
  elseif _new_motor_pitch > 90 then
    _new_motor_pitch = 90
  end

  lcd.clear()
  
  lcd.drawText(1, 21, "Current:", 0)
  lcd.drawText(50, 21, _transmitted_motor_pitch .. "@", 0)
  
  lcd.drawGauge(72, 22, 32, 5, _transmitted_motor_pitch + 90, 190)
  
  lcd.drawPixmap(LCD_W-64, 0, "SCRIPTS/TELEMETRY/bmp/motor_" .. math.floor(_new_motor_pitch) .. ".bmp")

  lcd.drawText(1, 31, "New:", 0)
  lcd.drawText(50, 31, _new_motor_pitch .. "@", 0)
  
  lcd.drawGauge(72, 32, 32, 5, _new_motor_pitch + 90, 190)
  
  lcd.drawScreenTitle("Motor pitch adjustment", 1, 1)
end

return { run = run_func, background = bg_func, init = init_func }