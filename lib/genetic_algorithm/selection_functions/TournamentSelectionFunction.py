import random
from lib.genetic_algorithm.selection_functions.SelectionFunction import SelectionFunction


class TournamentSelectionFunction(SelectionFunction):
    """
    Selection function that selects individuals using the tournament algorithm
    """

    def __init__(self, size, p=0.9):
        """
        :param size: <int> the number of participants in the tournament
        """
        self.size = size
        self.p = p

    def select(self, population):
        """
        Selects an individual, it picks a number (given by self.size) of random individuals of the population and picks
        the best of that set
        :param population: <Population> The population of the genetic algorithm to select an individual from
        :return: <InputIndividual> The selected individual
        """
        individuals = population.get_individuals()
        individuals_fitness = population.get_fitnesses()

        individual_array = list()

        for i in range(self.size):
            random_index = random.randint(0, len(individuals) - 1)
            individual_array.append((individuals[random_index], individuals_fitness[random_index], random_index))

        def sortFitness(individual):
            return individual[1]

        individual_array.sort(key=sortFitness, reverse=True)

        for individual_entry in individual_array:
            if random.random() < self.p:
                return individual_entry[0]

        return individual_array[-1][0]
