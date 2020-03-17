import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual

class EphemeralKeyIndividual(InputIndividual):

    def __init__(self, genomes):
        InputIndividual.__init__(self, genomes)

        self.max_frame = 0
        for genome in genomes:
            self.max_frame += genome.get_frames()

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        current_frame = 1
        inputs = dict()

        for i in range(len(self.genomes)):
            genome_frames = self.genomes[i].get_frames()
            genome_inputs = self.genomes[i].get_inputs()
            inputs[current_frame] = genome_inputs
            inputs[current_frame + genome_frames - 1] = {}
            for input, val in genome_inputs:
                inputs[current_frame + genome_frames - 1][input] = not val

            current_frame = current_frame + genome_frames

        return inputs

    # TODO: Reimplement single point and kpoint crossover

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_genome = random.choice(self.genomes)
        random_genome.mutate_with_max_frame(self.get_max_frame())


    def get_max_frame(self):
        """
        getter
        """
        return self.max_frame