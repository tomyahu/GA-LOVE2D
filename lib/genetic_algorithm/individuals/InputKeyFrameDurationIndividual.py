from lib.genetic_algorithm.individuals.InputKeyFrameIndividual import InputKeyFrameIndividual


class InputKeyFrameDurationIndividual(InputKeyFrameIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame duration
    genomes.
    """

    def __init__(self, genomes):
        """
        :param genomes: <InputKeyFrameDurationIndividual> The list of genomes of the current individual
        """
        InputKeyFrameIndividual.__init__(self, genomes)
