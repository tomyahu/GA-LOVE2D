import random
from lib.genetic_algorithm.mutation_functions.MutationFunction import MutationFunction


class ProbabilisticMutationFunction(MutationFunction):
    """
    Mutation Function class that mutates an individual an amount of times given by a mutation probability
    """

    def __init__(self, mutation_prob):
        """
        :param mutation_prob: <float> this value correspond to the probability that the individual mutates, if may
        mutate again with the same probability.
        """
        self.mutation_prob = mutation_prob

    def mutate(self, individual):
        """
        mutates an individual, given the probability the expected amount of mutations produced in the individual can be
        calculated as p/(1-p) where p represents the mutation probability.

        A guide to set the mutation probability can be the following, if the mutation probability has the form x/x+1
        then the expected amount of mutations will be x. For example p = 5/6 gives us an expected amount of mutations
        of 5.
        :param individual: <InputIndividual> the individual to perform mutation on
        """
        while random.random() < self.mutation_prob:
            individual.mutate()
