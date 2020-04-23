import os
import sys

from lib.genetic_algorithm.population.PopulationFactory import PopulationFactory
from lib.genetic_algorithm.testers.LoveHawkthornTester import LoveHawkthornTester
from lib.genetic_algorithm.testers.LoveTester import LoveTester
from ga_settings.consts import generations, individual_num, frames_to_test, mutation_prob, elitism_ratio, \
    frames_to_skip, frames_to_clean, absolute_path
from lib.genetic_algorithm.individuals.factories.InputIndividualFactory import InputIndividualFactory
from lib.input_scripts.InputScript import InputScript

# Create target Directory
directory_path = absolute_path + "/individuals/" + sys.argv[4]

try:
    os.mkdir(directory_path)
    print("Directory " + directory_path + " Created ")
except FileExistsError:
    print("Directory " + directory_path + " already exists")


# Create population
individuals = list()
for i in range(individual_num):
    individuals.append(InputIndividualFactory.get_random_multi_input_ephemeral_key_individual(frames_to_test, 10, 0.2))

# tester = LoveTester(aux_path=sys.argv[1], clean_script=sys.argv[2], skip_script=sys.argv[3])

testers = list()
for i in range(5):
    testers.append(LoveTester(aux_path=sys.argv[1], clean_script=sys.argv[2], skip_script=sys.argv[3]))

population = PopulationFactory.get_classic_parallel_population(individuals, testers, mutation_prob, elitism_ratio)


# Rank first generation of the population
print("Generation #1")
population.rank_individuals()
print("Fitness:", population.get_best_fitness())
print("")


# Import input script
skip_input_script = InputScript(absolute_path + "/individuals/" + sys.argv[3])


# Generate data dict with the experiment data and space for results
data_dict = dict()
data_dict["generations"] = generations
data_dict["individual_num"] = individual_num
data_dict["mutation_prob"] = mutation_prob
data_dict["elitism_ratio"] = elitism_ratio
data_dict["frames_to_clean"] = frames_to_clean
data_dict["frames_to_skip"] = frames_to_skip
data_dict["frames_to_test"] = frames_to_test

data_dict["fitness"] = list()
for metric_key in population.get_best_individual().get_metrics().keys():
    data_dict[metric_key] = list


# Run the rest of the generations
for i in range(1, generations + 1):
    # Save the best individual of the generation's input script
    best_individual = population.get_best_individual()
    original_input_script = best_individual.get_inputs()
    shifted_input_script = original_input_script.shift_frames(frames_to_skip)

    input_script = shifted_input_script + skip_input_script
    input_script.save_to_file(directory_path + "/gen_" + str(i))

    # Add results to output dictionary
    data_dict["fitness"].append(population.get_best_fitness())
    for metric_key in best_individual.get_metrics().keys():
        data_dict[metric_key].append(best_individual.get_metrics()[metric_key])

    # Reproduce and rank only if there are generations left
    if i < generations:
        population.reproduce()

        print("Generation #" + str(i + 1))
        population.reset_fitness_calculation()
        population.rank_individuals()

        print("Fitness:", population.get_best_fitness())
        print("")


# Save results
file = open(directory_path + "/data", "w+")
for data_key in data_dict.keys():
    file.write(data_key + ": " + str(data_dict[data_key]) + "\n")
file.close()
