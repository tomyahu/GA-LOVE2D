local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
local TablesMemoryLib = require("love_ga_wrapper.lib.memory.TablesMemoryLib")
-------------------------------------------------------------

-- class: MinInputsMemoryFitnessFun
-- A fitness function thet calculates total memory at the end of execution
local MinInputsMemoryFitnessFun = extend(FitnessFun, function(self)
    self.last_memory = 0
    self.memory_registrys = {}
    self.inputs = {}
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, gets the current memory used
function MinInputsMemoryFitnessFun.initAux(self)
  self.memory_registrys = {}
  self.inputs = {}

  collectgarbage("collect")
  self.last_memory = collectgarbage("count")
end

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current memory and the initial memory
function MinInputsMemoryFitnessFun.mainFun(self)
  local input_num = 0
  local last_input = ""

  for i, frame_inputs in pairs(self.inputs) do
      for key, bool in pairs(frame_inputs) do
          if key ~= last_input and bool and key ~= "no_input" then
              input_num = input_num + 1
          end
          last_input = key
      end
  end

  local memory_acc = 0
  for _, dmem in pairs(self.memory_registrys) do
      memory_acc = memory_acc + dmem
  end

  return - (memory_acc + 0.2*input_num)
end

-- stepFun: None -> None
-- The step fitness function, does nothing
function MinInputsMemoryFitnessFun.stepFun(self)
  collectgarbage("collect")
  local current_memory = collectgarbage("count")

  table.insert(self.memory_registrys, current_memory - self.last_memory)
  table.insert(self.inputs, TablesMemoryLib.copy(self.love_ga_creator:getCurrentInputs()))

  collectgarbage("collect")
  self.last_memory = collectgarbage("count")
end

return MinInputsMemoryFitnessFun