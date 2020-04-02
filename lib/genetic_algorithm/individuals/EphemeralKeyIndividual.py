import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript


class EphemeralKeyIndividual(InputIndividual):
    """
    An individual composed of single key genomes and ephemeral key genomes
    Can't represent two or more inputs at a time
    """

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
        inputs = InputScript()

        current_frame = 1
        for genome in self.genomes:
            genome_input = genome.get_key_input()
            genome_duration = genome.get_frames()
            inputs.add_input(genome_input, current_frame, current_frame + genome_duration)
            current_frame += genome_duration

        return inputs

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
