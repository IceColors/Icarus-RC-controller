
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

if _new_aoa == nil then
  _new_aoa = 0
end

if _transmitted_aoa == nil then
  _transmitted_aoa = 0
end


if STATE == nil then
  STATE = "menu"
end

local selected = false
local selectedId = 0
local nSelections = 2

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


local function displayMenu()
  lcd.clear()
  

  lcd.drawText(1, 11, "Motor:")
  lcd.drawText(50, 11, _transmitted_motor_pitch .. "@", 0)
  lcd.drawGauge(72, 12, 32, 5, _transmitted_motor_pitch + 90, 190)
  
  if selectedId == 0 and selected then
    lcd.drawText(1, 21, "New:", INVERS + BLINK)
  elseif selectedId == 0 then
    lcd.drawText(1, 21, "New:", INVERS)
  else
    lcd.drawText(1, 21, "New:")
  end
  
  lcd.drawText(50, 21, _new_motor_pitch .. "@", 0)
  lcd.drawGauge(72, 22, 32, 5, _new_motor_pitch + 90, 190)

  lcd.drawPixmap(LCD_W-64, 0, "/SCRIPTS/TELEMETRY/bmp/smotor_" .. math.floor(_new_motor_pitch) .. ".bmp")
  
  
  
  lcd.drawText(1, 41, "AOA:")
  
  lcd.drawText(50, 41, _transmitted_aoa .. "@", 0)
  
  lcd.drawGauge(72, 42, 32, 5, _transmitted_aoa + 90, 190)
  
  if selectedId == 1 and selected then
    lcd.drawText(1, 51, "New:", INVERS + BLINK)
  elseif selectedId == 1 then 
    lcd.drawText(1, 51, "New:", INVERS)
  else
    lcd.drawText(1, 51, "New:")
  end
  lcd.drawText(50, 51, _new_aoa .. "@", 0)
  
  lcd.drawGauge(72, 52, 32, 5, _new_aoa + 90, 190)

  lcd.drawPixmap(LCD_W-64, 32, "/SCRIPTS/TELEMETRY/bmp/drone_" .. math.floor(_new_aoa) .. ".bmp")


  lcd.drawScreenTitle("Pitch adjustment", 1, 1)
  return false
end

local function motor_pitch_clamp()
  if _new_motor_pitch < -90 then
    _new_motor_pitch = -90
  elseif _new_motor_pitch > 90 then
    _new_motor_pitch = 90
  end
  return true
end

local function aoa_clamp()
  if _new_aoa < -90 then
    _new_aoa = -90
  elseif _new_aoa > 90 then
    _new_aoa = 90
  end
  return true
end

local function select_left()
  if selectedId == 0 then
    _new_motor_pitch = _new_motor_pitch + inc_val
    motor_pitch_clamp()
  elseif selectedId == 1 then
    _new_aoa = _new_aoa + inc_val
    aoa_clamp()
  end
  
  return true
end

local function select_right()
  if selectedId == 0 then
    _new_motor_pitch = _new_motor_pitch - inc_val
    motor_pitch_clamp()
  elseif selectedId == 1 then
    _new_aoa = _new_aoa - inc_val
    aoa_clamp()
  end
  return true
end




local function menu_scroll_left()
  selectedId = (selectedId + 1) % nSelections
  return true
end

local function menu_scroll_right()
  selectedId = (selectedId -1 + nSelections) % nSelections
  return true
end

local function menu_select()
  selected = true
  return true
end

local function menu_unselect()
  selected = false
  return true
end

local fsm = FSM{
  {"menu", "rot_left", "menu",  menu_scroll_left},
  {"menu", "rot_right", "menu",  menu_scroll_right},
  {"menu", "select", "menuSelected",  menu_select},
  {"menuSelected", "select", "menu",  menu_unselect},
  {"menuSelected", "rot_left", "menuSelected",  select_left},
  {"menuSelected", "rot_right", "menuSelected", select_right},
  {"menu", "", "menu", displayMenu},
  {"menuSelected", "", "menuSelected", displayMenu}
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
  elseif e == EVT_ROT_BREAK then
    EVENT = "select"
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