from lib.genetic_algorithm.population.PopulationFactory import PopulationFactory
from lib.genetic_algorithm.testers.LoveTester import LoveTester
from ga_settings.consts import generations, individual_num, frames_to_test, mutation_prob, elitism_ratio
from lib.genetic_algorithm.individuals.factories.InputIndividualFactory import InputIndividualFactory

individuals = list()

for i in range(individual_num):
    individuals.append(InputIndividualFactory.get_random_ephemeral_individual_with_frames_to_test(80, frames_to_test))

tester = LoveTester()

population = PopulationFactory.get_classic_population(individuals, tester, mutation_prob, elitism_ratio)

print("Generation #1")
population.rank_individuals()
print("Fitness:", population.get_best_fitness())