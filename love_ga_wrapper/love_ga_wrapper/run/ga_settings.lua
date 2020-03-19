local FitnessFun = require("love_ga_wrapper.fitness_functions.MemoryFitnessFun")
--------------------------------------------------------------------------------------------------------

local ga_settings = {}

ga_settings.setted_seed = 1
ga_settings.setted_dt = 1/12

ga_settings.fitness_fun = FitnessFun.new()

ga_settings.frames_to_skip = 570
ga_settings.frames_to_test = 200
ga_settings.generations = 100
ga_settings.population_num = 100
ga_settings.mutation_prob = 0.05
ga_settings.elitism_ratio = 0.05

return ga_settings