local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: AttackFromAboveFitnessFun
local AttackFromAboveFitnessFun = extend(FitnessFun, function(self)
	self.height_array = {}
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the height array
function AttackFromAboveFitnessFun.initAux(self)
	self.height_array = {}
end

-- mainFun: None -> num
-- The main fitness function
function AttackFromAboveFitnessFun.mainFun(self)
	local avg_y = 0
	for _, val in pairs(self.height_array) do
		avg_y = avg_y + val
	end

	avg_y = - avg_y / (# self.height_array)

	return avg_y + player.stomps + player.cherry_bombs
end

-- stepFun: None -> None
-- The step fitness function, updates the height array
function AttackFromAboveFitnessFun.stepFun(self)
	table.insert(self.height_array, player.y)
end

return AttackFromAboveFitnessFun