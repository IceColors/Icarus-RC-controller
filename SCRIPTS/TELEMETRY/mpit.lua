
local last = -10
local inc_val = 1
local direction = EVT_ROT_LEFT

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

if STATE == nil then
  STATE = "menu"
end

local function displayMenu()
  lcd.clear()
  
  lcd.drawText(1, 21, "Current:", 0)
  lcd.drawText(50, 21, _transmitted_motor_pitch .. "@", 0)
  
  lcd.drawGauge(72, 22, 32, 5, _transmitted_motor_pitch + 90, 190)
  
  lcd.drawPixmap(LCD_W-64, 0, "/SCRIPTS/TELEMETRY/bmp/motor_" .. math.floor(_new_motor_pitch) .. ".bmp")

  lcd.drawText(1, 31, "New:", 0)
  lcd.drawText(50, 31, _new_motor_pitch .. "@", 0)
  
  lcd.drawGauge(72, 32, 32, 5, _new_motor_pitch + 90, 190)
  
  lcd.drawScreenTitle("Motor pitch adjustment", 1, 1)
  return false
end

local function motor_pitch_left()
  _new_motor_pitch = _new_motor_pitch + inc_val
  return true
end

local function motor_pitch_right()
  _new_motor_pitch = _new_motor_pitch - inc_val
  return true
end

local function motor_pitch_clamp()
  if _new_motor_pitch < -90 then
    _new_motor_pitch = -90
  elseif _new_motor_pitch > 90 then
    _new_motor_pitch = 90
  else 
    _motor_pitch_changed = true
  end
  return true
end


-- finite state machine
local function FSM(t)
  local state = {}
  for _, v in ipairs(t) do
    local old, event, new, action = v[1], v[2], v[3], v[4]
    if state[old] == nil then state[old] = {} end
    state[old][event] = {new = new, action = action}
  end
  return state
end

local fsm = FSM{
  {"menu", "rot_left", "clamp",  motor_pitch_left},
  {"menu", "rot_right", "clamp", motor_pitch_right},
  {"clamp", "", "menu", motor_pitch_clamp},
  {"menu", "", "menu", displayMenu}
}


local function init_func()
end

-- called in the background even when screen is visible
local function bg_func()
end

-- called periodically when screen is visible
local function run_func(e)
  local EVENT = ""

  -- scroll speed
  if e == EVT_ROT_LEFT or e == EVT_ROT_RIGHT then
    local currTime = getTime()
    if currTime - last < 10 and direction == e then
      inc_val = 5
    else
      inc_val = 1
      direction = e
    end
    last = currTime
  end
  
  if e == EVT_ROT_LEFT then
    EVENT = "rot_left"
  elseif e == EVT_ROT_RIGHT then
    EVENT = "rot_right"
  end
  
  local transition = fsm[STATE][EVENT]
  if transition ~= nil then
    -- multiple transitions
    while transition.action() == true do
      STATE = transition.new
      EVENT = ""
      transition = fsm[STATE][EVENT]
    end
  end
 
end

return { run = run_func, background = bg_func, init = init_func }