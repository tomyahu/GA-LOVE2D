import random
from lib.genetic_algorithm.mutation_functions.MutationFunction import MutationFunction


class RegularMutationFunction(MutationFunction):
    """
    Mutation Function class that mutates an individual given a mutation probability
    """

    def __init__(self, mutation_prob):
        """
        :param mutation_prob: <float> the probability of any indivual to mutate
        """
        self.mutation_prob = mutation_prob

    def mutate(self, individual):
        """
        mutates an individual, given the probability
        :param individual: <InputIndividual> the individual to perform mutation on
        """
        if random.random() < self.mutation_prob:
            individual.mutate()
