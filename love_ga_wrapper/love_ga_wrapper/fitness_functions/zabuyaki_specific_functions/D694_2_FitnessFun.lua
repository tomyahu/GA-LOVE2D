local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: D694_2_FitnessFun
local D694_2_FitnessFun = extend(FitnessFun, function(self)
    self.chai_combo_1_array = {}
    self.chai_combo_2_array = {}
    self.chai_dash_attack_array = {}
    self.chai_dash_attack_hitboxes_array = {}

    self.dash_attack_hitbox_num = 22

    self.max_damage_done_array = {}
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the height array
function D694_2_FitnessFun.initAux(self)
    self.chai_combo_1_array = {}
    self.chai_combo_2_array = {}
    self.chai_dash_attack_array = {}
    self.chai_dash_attack_hitboxes_array = {}

    self.max_damage_done_array = {}

    fitness_var_chai_combo_1 = false
    fitness_var_chai_combo_2 = false
    fitness_var_chai_dash_attack = false
    fitness_var_chai_dash_attack_hitboxes = false
    fitness_var_someone_died = false

    fitness_var_player_damage_made_this_frame = 0
    fitness_var_player_faced_left = false
end

-- mainFun: None -> num
-- The main fitness function
function D694_2_FitnessFun.mainFun(self)
    local damage_done_by_dash_attack_array = {}
    local amount_of_hitboxes_by_dash_attack_array = {}

    local current_dash_attack_index = -1
    for i =1,(# self.chai_combo_1_array) do
        table.insert(damage_done_by_dash_attack_array, 0)
        table.insert(amount_of_hitboxes_by_dash_attack_array, 0)
        if self.chai_dash_attack_array[i] then
            current_dash_attack_index = i
        end

        if current_dash_attack_index > 0 then
            if self.chai_dash_attack_hitboxes_array[i] then
                damage_done_by_dash_attack_array[current_dash_attack_index] = damage_done_by_dash_attack_array[current_dash_attack_index] + self.max_damage_done_array[i]
                amount_of_hitboxes_by_dash_attack_array[current_dash_attack_index] = amount_of_hitboxes_by_dash_attack_array[current_dash_attack_index] + 1
            end
        end
    end


    local combo_1_done = 0
    local combo_2_done = 0
    local combo_3_done = 0

    local last_move_delta_frames = 25

    local last_last_move = -1
    local last_move = -1
    local frames_since_last_combo = 100
    for i = 1, (# self.chai_combo_1_array) do
        local current_move = -1
        if self.chai_combo_1_array[i] then current_move = 0 end
        if self.chai_combo_2_array[i] then current_move = 1 end
        if self.chai_dash_attack_array[i] then current_move = 2 end

        if frames_since_last_combo > last_move_delta_frames then
            if current_move == 0 and self.max_damage_done_array[i] > 0 then
                combo_1_done = math.max(1, combo_1_done)
                frames_since_last_combo = 0
            end
            last_move = -1
            last_last_move = -1
        else
            if last_move == 0 and current_move == 1 then
                if self.max_damage_done_array[i] > 0 then
                    combo_2_done = math.max(1, combo_2_done)
                else
                    current_move = -1
                end
            elseif last_last_move == 0 and last_move == 1 and current_move == 2 then
                if amount_of_hitboxes_by_dash_attack_array[i] == self.dash_attack_hitbox_num then
                    combo_3_done = math.max(combo_3_done, 1 / (1 + damage_done_by_dash_attack_array[i]))
                end
            end
        end

        if current_move >= 0 then
            last_last_move = last_move
            last_move = current_move
            frames_since_last_combo = 0
        end
        frames_since_last_combo = frames_since_last_combo + 1
    end

    --[[if fitness_var_someone_died or fitness_var_player_faced_left then
    if fitness_var_player_faced_left then
        return 0
    else
        return combo_1_done + combo_2_done*0.1 + combo_3_done*100
    end
    ]]--
    return combo_1_done + combo_2_done*0.1 + combo_3_done*100
end

-- stepFun: None -> None
-- The step fitness function, updates the height array
function D694_2_FitnessFun.stepFun(self)
    table.insert(self.chai_combo_1_array, fitness_var_chai_combo_1)
    fitness_var_chai_combo_1 = false

    table.insert(self.chai_combo_2_array, fitness_var_chai_combo_2)
    fitness_var_chai_combo_2 = false

    table.insert(self.chai_dash_attack_array, fitness_var_chai_dash_attack)
    fitness_var_chai_dash_attack = false

    table.insert(self.chai_dash_attack_hitboxes_array, fitness_var_chai_dash_attack_hitboxes)
    fitness_var_chai_dash_attack_hitboxes = false

    table.insert(self.max_damage_done_array, fitness_var_player_damage_made_this_frame)
    --io.stdout:write(fitness_var_player_damage_made_this_frame)
    --io.stdout:write("\n")
    fitness_var_player_damage_made_this_frame = 0
end

return D694_2_FitnessFun
