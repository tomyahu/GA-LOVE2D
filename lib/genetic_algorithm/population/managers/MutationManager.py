from lib.genetic_algorithm.mutation_function.MutationFunction import MutationFunction


class MutationManager():
    """
    Manager class that manages the different mutation functions
    """

    def __init__(self):
        self.mutation_fun = MutationFunction()

    def mutate(self, individual):
        """
        mutates an individual using the mutation function
        :param individual: <InputIndividual> the individual to perform mutation on
        """
        self.mutation_fun.mutate(individual)

    def set_mutation_fun(self, new_mutation_fun):
        """
        setter
        """
        self.mutation_fun = new_mutation_fun
