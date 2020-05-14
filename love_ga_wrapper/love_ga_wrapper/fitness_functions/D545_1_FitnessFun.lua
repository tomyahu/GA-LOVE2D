local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: D545_1_FitnessFun
local D545_1_FitnessFun = extend(FitnessFun, function(self)
    self.triggered_special_dash = 0
    self.landed_special_dash = 0

    self.frames_in_special_dash_check = 0
    self.special_dash_shout = 0
    self.dash_attacks = 0
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the height array
function D545_1_FitnessFun.initAux(self)
    fitness_var_special_dash_check = false
    self.frames_in_special_dash_check = 0

    fitness_var_special_dash = false
    fitness_var_damage_special_dash = true

    self.first_part_damages = {}
    damage_done_this_frame = 0

    self.special_dash_shout = 0

    fitness_var_triggered_dash = false
    self.triggered_special_dash = 0
    self.landed_special_dash = 0

    self.dash_attacks = 0
    fitness_var_dash_attack = false
end

-- mainFun: None -> num
-- The main fitness function
function D545_1_FitnessFun.mainFun(self)
    local dash_attack_points = self.dash_attacks / 8
    local special_dash_points = self.triggered_special_dash + self.landed_special_dash*10*(1 + (self.special_dash_shout - self.landed_special_dash) * 9)

    return dash_attack_points + special_dash_points
end

-- stepFun: None -> None
-- The step fitness function, updates the height array
function D545_1_FitnessFun.stepFun(self)
    if fitness_var_triggered_dash then
        self.triggered_special_dash = self.triggered_special_dash + 1
    end
    fitness_var_triggered_dash = false

    if fitness_var_special_dash_check then
        self.frames_in_special_dash_check = self.frames_in_special_dash_check + 1
    end
    fitness_var_special_dash_check = false

    if fitness_var_damage_special_dash then
        table.insert(self.first_part_damages, damage_done_this_frame)
        damage_done_this_frame = 0
    end
    fitness_var_damage_special_dash = false

    if fitness_var_special_dash then
        self.landed_special_dash = self.landed_special_dash + 1
    end
    fitness_var_special_dash = false

    if fitness_var_special_dash_shout then
        self.special_dash_shout = self.special_dash_shout + 1
    end
    fitness_var_special_dash_shout = false

    if fitness_var_dash_attack then
        self.dash_attacks = self.dash_attacks + 1
    end
    fitness_var_dash_attack = false

end

return D545_1_FitnessFun
