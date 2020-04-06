local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
local Gamestate = require 'vendor/gamestate'
-------------------------------------------------------------

-- class: PlayerHighFitnessFun
local PlayerHighFitnessFun = extend(FitnessFun, function(self)
    self.heights = {}
    self.state = ""
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the distances list
function PlayerHighFitnessFun.initAux(self)
  self.heights = {}
  self.state = Gamestate.currentState().name
end

-- mainFun: None -> num
-- The main fitness function
function PlayerHighFitnessFun.mainFun(self)
  local calc = 0

  for _, height in pairs(self.heights) do
    calc = calc + height
  end

  return calc
end

-- stepFun: None -> None
-- The step fitness function
function PlayerHighFitnessFun.stepFun(self)
  local player_x, player_y = self:getPlayerPos()

  table.insert(self.distances, player_y)
end

-- getPlayerPos: None -> num, num
-- Returns the player's position if it applies, otherwise it returns -9999999 for the x and y coordinates
function PlayerHighFitnessFun.getPlayerPos(self)
  if Gamestate.currentState().player ~= nil and Gamestate.currentState().player.position ~= nil and Gamestate.currentState().name == self.state then
    return Gamestate.currentState().player.position.x, Gamestate.currentState().player.position.y
  else
    return -9999999, -9999999
  end
end

return PlayerHighFitnessFun