import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript
from lib.genetic_algorithm.genomes.EphemeralKeyGenome import EphemeralKeyGenome


class MultiInputEphemeralKeyIndividual(InputIndividual):

    def __init__(self, genomes):
        InputIndividual.__init__(self, genomes)

        self.genome_list_dict = dict()

        for genome in genomes:
            genome_input = genome.get_key_input()

            if not (genome_input in self.genome_list_dict.keys()):
                self.genome_list_dict[genome_input] = list()
            self.genome_list_dict[genome_input].append(genome)

        self.max_frame = 0
        for genome in self.genome_list_dict[genomes[0].get_key_input()]:
            self.max_frame += genome.get_frames()

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()

        for genome_input in self.genome_list_dict.keys():
            genome_list = self.genome_list_dict[genome_input]

            current_frame = 1
            aux_bool = True
            for genome in genome_list:
                genome_duration = genome.get_frames()

                if aux_bool:
                    inputs.add_input(genome_input, current_frame, current_frame + genome_duration)
                    aux_bool = False
                else:
                    aux_bool = True

                current_frame += genome_duration

        return inputs

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_key = random.choice(self.genome_list_dict.keys())
        random_genome = random.choice(self.genome_list_dict[random_key])
        random_genome.mutate_with_max_frame(self.get_max_frame())

    def get_max_frame(self):
        """
        getter
        """
        return self.max_frame