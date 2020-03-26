import random
from lib.genetic_algorithm.selection_functions.SelectionFunction import SelectionFunction


class TournamentSelectionFunction(SelectionFunction):
    """
    Selection function that selects individuals using the tournament algorithm
    """

    def __init__(self, size):
        """
        :param size: <int> the number of participants in the tournament
        """
        self.size = size

    def select(self, population):
        """
        Selects an individual, it picks a number (given by self.size) of random individuals of the population and picks
        the best of that set
        :param population: <Population> The population of the genetic algorithm to select an individual from
        :return: <InputIndividual> The selected individual
        """
        individuals = population.get_individuals()
        individuals_fitness = population.get_fitnesses()

        individual_indexes = list()

        for i in range(self.size):
            individual_indexes.append( random.randint(0, len(individuals) - 1))

        best_individual = individuals[individual_indexes[0]]
        best_fitness = individuals_fitness[individual_indexes[0]]

        for i in range(1, len(individual_indexes)):
            if individuals_fitness[individual_indexes[i]] > best_fitness:
                best_fitness = individuals_fitness[individual_indexes[i]]
                best_individual = individuals[individual_indexes[i]]

        return best_individual
