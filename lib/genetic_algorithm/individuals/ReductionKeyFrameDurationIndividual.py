import random

from lib.genetic_algorithm.individuals.InputKeyFrameDurationIndividual import InputKeyFrameDurationIndividual


class ReductionKeyFrameDurationIndividual(InputKeyFrameDurationIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame duration
    genomes. Used for reduction of input sequences.
    """

    def __init__(self, genomes):
        """
        :param genomes: <list(InputKeyFrameDurationGenome)> The list of genomes of the current individual
        """
        InputKeyFrameDurationIndividual.__init__(self, genomes)

    def mutate(self):
        """
        Deletes a random gene of the gene list
        """
        random_genome_index = random.randint(0, len(self.genomes) - 1)
        self.genomes.pop(random_genome_index)
