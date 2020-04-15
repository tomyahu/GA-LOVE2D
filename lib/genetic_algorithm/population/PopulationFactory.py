from lib.genetic_algorithm.crossover_functions.SinglePointCrossoverFunction import SinglePointCrossoverFunction
from lib.genetic_algorithm.mutation_functions.RegularMutationFunction import RegularMutationFunction
from lib.genetic_algorithm.population.Population import Population
from lib.genetic_algorithm.population.managers.ParallelTesterManager import ParallelTesterManager
from lib.genetic_algorithm.population.managers.TesterManager import TesterManager
from lib.genetic_algorithm.selection_functions.TournamentSelectionFunction import TournamentSelectionFunction


class PopulationFactory:

	@staticmethod
	def get_classic_population(individuals, tester, mutation_prob, elitism_ratio):
		population = Population(individuals, TesterManager(tester), elitism_ratio)

		# Regular Mutation Function
		mutation_manager = population.get_mutation_manager()
		mutation_manager.set_mutation_fun(RegularMutationFunction(mutation_prob))

		# Tournament Selection with tournaments of size 4
		selection_manager = population.get_selection_manager()
		selection_manager.set_selection_fun(TournamentSelectionFunction(4))

		# Single Point Crossover Function
		crossover_manager = population.get_crossover_manager()
		crossover_manager.set_crossover_fun(SinglePointCrossoverFunction())

		return population

	@staticmethod
	def get_classic_parallel_population(individuals, testers, mutation_prob, elitism_ratio):
		parallel_tester_manager = ParallelTesterManager(testers)
		population = Population(individuals, parallel_tester_manager, elitism_ratio)

		# Regular Mutation Function
		mutation_manager = population.get_mutation_manager()
		mutation_manager.set_mutation_fun(RegularMutationFunction(mutation_prob))

		# Tournament Selection with tournaments of size 4
		selection_manager = population.get_selection_manager()
		selection_manager.set_selection_fun(TournamentSelectionFunction(4))

		# Single Point Crossover Function
		crossover_manager = population.get_crossover_manager()
		crossover_manager.set_crossover_fun(SinglePointCrossoverFunction())

		return population