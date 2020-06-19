from lib.genetic_algorithm.individuals.InputKeyFrameIndividual import InputKeyFrameIndividual


class InputKeyFrameDurationIndividual(InputKeyFrameIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame duration
    genes.
    """

    def __init__(self, genes):
        """
        :param genes: <InputKeyFrameDurationIndividual> The list of genes of the current individual
        """
        InputKeyFrameIndividual.__init__(self, genes)
