import math
from lib.genetic_algorithm.population.managers.CrossoverManager import CrossoverManager
from lib.genetic_algorithm.population.managers.MutationManager import MutationManager
from lib.genetic_algorithm.population.managers.SelectionManager import SelectionManager
from lib.genetic_algorithm.population.managers.TesterManager import TesterManager


class Population:
    """
    The population of a genetic algorithm, implements all the methods that make the population reproduce
    """

    def __init__(self, individuals, tester_manager, elitism_ratio):
        """
        :param individuals: <list(InputIndividual)> the initial population for the genetic algorithm
        :param tester_manager: <TesterManager> the tester manager to test and assign fitness values to the individuals
        :param elitism_ratio: <float> the ratio of elitism of the genetic algorithm
        """
        self.individuals = individuals
        self.tester_manager = tester_manager
        self.elitism_ratio = elitism_ratio

        self.crossover_manager = CrossoverManager()
        self.mutation_manager = MutationManager()
        self.selection_manager = SelectionManager()

        self.individuals_fitness = list()

        for _ in self.individuals:
            self.individuals_fitness.append(0)

        self.best_fitness = 0
        self.worst_fitness = 0
        self.best_individual = self.individuals[0]
        self.worst_individual = self.individuals[0]

    def rank_individuals(self):
        """
        Calculates the fitness of all individuals of the population and also saves the best and worst individuals with
        their respective fitnesses
        """
        self.tester_manager.test_population(self)

        self.best_fitness = self.individuals_fitness[0]
        self.worst_fitness = self.individuals_fitness[0]
        self.best_individual = self.individuals[0]
        self.worst_individual = self.individuals[0]

        for i in range(len(self.individuals)):
            if self.individuals_fitness[i] > self.best_fitness:
                self.best_fitness = self.individuals_fitness[i]
                self.best_individual = self.individuals[i]

            if self.individuals_fitness[i] < self.worst_fitness:
                self.worst_fitness = self.individuals_fitness[i]
                self.worst_individual = self.individuals[i]

    def reset_fitness_calculation(self):
        """
        Resets the individual fitnesses and the best and worst individual and their fitnesses
        """
        for _ in self.individuals:
            self.individuals_fitness.append(0)

        self.best_fitness = 0
        self.worst_fitness = 0
        self.best_individual = self.individuals[0]
        self.worst_individual = self.individuals[0]

    def reproduce(self):
        """
        Reproduces the population based on the calculated fitnesses and updates the current population with the
        individuals of the next generation
        """
        new_population = list()

        elitism_parents = self.get_best_n_individuals(math.floor(len(self.individuals) * self.elitism_ratio))

        for individual in elitism_parents:
            new_population.append(individual)

        while len(new_population) < len(self.individuals):
            p1 = self.selection_manager.select(self)
            p2 = self.selection_manager.select(self)

            child = self.crossover_manager.cross_over(p1, p2)

            self.mutation_manager.mutate(child)

            new_population.append(child)

        self.individuals = new_population

    def get_best_n_individuals(self, n):
        """
        Gets the n individuals with the most fitness in a list
        :param n: <int> the number of individuals to get in order
        :return: <list(InputIndividual)> the list of the n individuals with the best fitness in the population
        """
        ordered_individuals = list()
        for i in range(len(self.individuals)):
            ordered_individuals.append([self.individuals[i], self.individuals_fitness[i]])

        def sort_second(val):
            return val[1]

        ordered_individuals.sort(key=sort_second, reverse=True)

        best_n_individuals = list()
        for i in range(min(n, len(self.individuals))):
            best_n_individuals.append(ordered_individuals[i][0])

        return best_n_individuals

    def get_best_individual(self):
        """
        getter
        """
        return self.best_individual

    def get_mutation_manager(self):
        """
        getter
        """
        return self.mutation_manager

    def get_crossover_manager(self):
        """
        getter
        """
        return self.crossover_manager

    def get_selection_manager(self):
        """
        getter
        """
        return self.selection_manager

    def get_best_fitness(self):
        """
        getter
        """
        return self.best_fitness

    def get_worst_fitness(self):
        """
        getter
        """
        return self.worst_fitness

    def get_individuals(self):
        """
        getter
        """
        return self.individuals

    def get_fitnesses(self):
        """
        getter
        """
        return self.individuals_fitness
