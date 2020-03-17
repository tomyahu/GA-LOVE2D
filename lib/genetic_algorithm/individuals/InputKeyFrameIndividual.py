from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual

class InputKeyFrameIndividual(InputIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame genomes.
    """

    def __init__(self, genomes):
        """
        :param genomes: <list(KeyFrameGenome)> The list of genomes of the current individual
        """
        InputIndividual.__init__(self, genomes)

        def sort_second(val):
            return val[1]

        self.genomes.sort(key = sort_second)

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = dict()
        for i in range(1, self.genomes+1):
            for frame, key in self.genomes[i].get_inputs():
                if not inputs[frame]:
                    inputs[frame] = dict

                if not inputs[frame + self.genomes[i].get_duration()]:
                    inputs[frame + self.genomes[i].get_duration()] = {}

                inputs[frame][key] = True
                inputs[frame + self.genomes[i].get_duration()][key] = False
        return inputs
