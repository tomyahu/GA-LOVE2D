local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
local Gamestate = require 'vendor/gamestate'
-------------------------------------------------------------

-- class: PlayerStayInPosFitnessFun
local PlayerStayInPosFitnessFun = extend(FitnessFun, function(self)
    self.distances = {}
    self.x = 0
    self.y = 0
    self.reduction_factor = 0.9954
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the distances list
function PlayerStayInPosFitnessFun.initAux(self)
  self.distances = {}
  local player_x, player_y = self.getPlayerPos()
  self.x = player_x
  self.y = player_y
end

-- mainFun: None -> num
-- The main fitness function
function PlayerStayInPosFitnessFun.mainFun(self)
  local calc = 0
  local factor = 1

  for _, dist in pairs(self.distances) do
    calc = calc + dist*factor
    factor = factor * self.reduction_factor
  end

  return - calc
end

-- stepFun: None -> None
-- The step fitness function
function PlayerStayInPosFitnessFun.stepFun(self)
  local player_x, player_y = self.getPlayerPos()
  local dx = (player_x - self.x)
  local dy = (player_y - self.y)

  local dist = math.sqrt(dx*dx + dy*dy)
  table.insert(self.distances, dist)
end

-- getPlayerPos: None -> num, num
-- Returns the player's position if it applies, otherwise it returns -9999999 for the x and y coordinates
function PlayerStayInPosFitnessFun.getPlayerPos(self)
  if Gamestate.currentState().player ~= nil and Gamestate.currentState().player.position ~= nil then
    return Gamestate.currentState().player.position.x, Gamestate.currentState().player.position.y
  else
    return -9999999, -9999999
  end
end

return PlayerStayInPosFitnessFun