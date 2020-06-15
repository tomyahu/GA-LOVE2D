local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: D545_2_2_FitnessFun
local D545_2_2_FitnessFun = extend(FitnessFun, function(self)
    self.triggered_charge_dash = 0
    self.landed_charge_dash = 0
    self.triggered_charge_dash2 = 0

    self.max_charged = 0
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the height array
function D545_2_2_FitnessFun.initAux(self)
    fitness_var_landed_charge_dash = false
    self.landed_charge_dash = 0

    fitness_var_triggered_charge_dash = false
    self.triggered_charge_dash = 0

    fitness_var_triggered_charge_dash2 = false
    self.triggered_charge_dash2 = 0

    fitness_var_charging_attack = 0
    self.max_charged = 0
end

-- mainFun: None -> num
-- The main fitness function
function D545_2_2_FitnessFun.mainFun(self)
    local charge_points = self.max_charged
    local triggered_charge_dash_points = self.triggered_charge_dash*10
    local landed_charge_dash_points = self.landed_charge_dash*100*(1 + (self.landed_charge_dash - self.triggered_charge_dash2/14) * 9)

    return charge_points + triggered_charge_dash_points + landed_charge_dash_points
end

-- stepFun: None -> None
-- The step fitness function, updates the height array
function D545_2_2_FitnessFun.stepFun(self)
    if fitness_var_landed_charge_dash then
        self.landed_charge_dash = self.landed_charge_dash + 1
    end
    fitness_var_landed_charge_dash = false

    if fitness_var_triggered_charge_dash then
        self.triggered_charge_dash = self.triggered_charge_dash + 1
    end
    fitness_var_triggered_charge_dash = false

    if fitness_var_triggered_charge_dash2 then
        self.triggered_charge_dash2 = self.triggered_charge_dash2 + 1
    end
    fitness_var_triggered_charge_dash2 = false

    self.max_charged = math.max(self.max_charged, fitness_var_charging_attack)
    fitness_var_charging_attack = 0

end

return D545_2_2_FitnessFun
