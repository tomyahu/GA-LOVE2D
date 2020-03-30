import os
import sys

from lib.genetic_algorithm.population.PopulationFactory import PopulationFactory
from lib.genetic_algorithm.testers.LoveTester import LoveTester
from ga_settings.consts import generations, individual_num, frames_to_test, mutation_prob, elitism_ratio, frames_to_skip
from lib.genetic_algorithm.individuals.factories.InputIndividualFactory import InputIndividualFactory
from lib.input_scripts.InputScript import InputScript

directory_path = "individuals/" + sys.argv[4]
skip_input_script = InputScript("individuals/" + sys.argv[3])

try:
    # Create target Directory
    os.mkdir(directory_path)
    print("Directory " , directory_path ,  " Created ")
except FileExistsError:
    print("Directory " , directory_path ,  " already exists")



individuals = list()

for i in range(individual_num):
    individuals.append(InputIndividualFactory.get_random_ephemeral_individual_with_frames_to_test(80, frames_to_test))

tester = LoveTester(sys.argv[1], sys.argv[2], sys.argv[3])

population = PopulationFactory.get_classic_population(individuals, tester, mutation_prob, elitism_ratio)

print("Generation #1")
population.rank_individuals()
print("Fitness:", population.get_best_fitness())
print("")
for i in range(1, generations):
    best_individual = population.get_best_individual()
    original_input_script = best_individual.get_inputs()
    shifted_input_script = original_input_script.shift_frames(frames_to_skip)

    input_script = shifted_input_script + skip_input_script
    input_script.save_to_file(directory_path + "/gen_" + str(i))

    file = open(directory_path + "/gen_" + str(i) + "_data", "w+")
    file.write(str(population.get_best_fitness()))
    file.close()

    population.reproduce()

    print("Generation #" + str(i + 1))
    population.reset_fitness_calculation()
    population.rank_individuals()

    print("Fitness:", population.get_best_fitness())
    print("")


i = 30
best_individual = population.get_best_individual()
original_input_script = best_individual.get_inputs()
shifted_input_script = original_input_script.shift_frames(frames_to_skip)

input_script = shifted_input_script + skip_input_script
input_script.save_to_file(directory_path + "/gen_" + str(i))