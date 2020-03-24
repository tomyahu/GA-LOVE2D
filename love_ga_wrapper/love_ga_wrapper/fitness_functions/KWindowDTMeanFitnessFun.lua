local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: KWindowDTMeanFitnessFun
-- param: k:int -> the number of frames of the window
-- A fitness function that calculates total time of a k window of frames
local KWindowDTMeanFitnessFun = extend(FitnessFun, function(self, k)
    self.k = k
    self.step_array = {}
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation
function KWindowDTMeanFitnessFun.initAux(self)
  self.step_array = {}
end

-- mainFun: None -> num
-- The main fitness function, gets the max sum of delta time for the function's window size k
function KWindowDTMeanFitnessFun.mainFun(self)
  local step_array = self.step_array
  
  local step_length = (# step_array)
  local acc = 0
  for i = 1, step_length-self.k do
    local aux = 0
    for j = i, i + self.k - 1 do
      aux = aux + step_array[j]
    end
    acc = math.max(acc, aux / self.k)
  end
  
  return acc / step_length
end

-- stepFun: None -> None
-- The step fitness function, get current delta time of current frame
function KWindowDTMeanFitnessFun.stepFun(self)
  table.insert(self.step_array, self.love_ga_creator:getCurrentFrameDt())
end

return KWindowDTMeanFitnessFun