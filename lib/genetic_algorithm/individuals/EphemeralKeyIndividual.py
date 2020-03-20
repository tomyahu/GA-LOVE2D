import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript
from lib.genetic_algorithm.genomes.EphemeralKeyGenome import EphemeralKeyGenome


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
        inputs = InputScript()

        current_frame = 1
        for genome in self.genomes:
            genome_input = genome.get_key_input()
            genome_duration = genome.get_frames()
            inputs.add_input(genome_input, current_frame, current_frame + genome_duration)
            current_frame += genome_duration

        return inputs

    def single_point_cross_over(self, individual):
        """
        Returns the result of a classic crossover between this individual and the passed individual divides the genomes
        of both individuals in 2 and creates a new individual with the first part of the first and the second of the
        second
        :param individual: <EphemeralKeyIndividual> the individual to do crossover with
        :return: <EphemeralKeyIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        new_genomes = list()
        genome_number = len(self.get_genomes())

        random_cut = random.randint(0, genome_number - 1)

        current_frame = 1
        current_index = 0
        while current_frame < random_cut:
            genome = self.genomes[current_index]
            genome_duration = genome.get_frames()

            if current_frame + genome_duration < random_cut:
                copy_genome = genome.get_copy()
                new_genomes.append(copy_genome)
                current_frame += genome_duration
            else:
                new_genome = EphemeralKeyGenome(genome.get_key_input(), random_cut - current_frame)
                new_genomes.append(new_genome)
                current_frame = random_cut

        current_frame = 1
        for genome in individual.get_genomes():
            genome_duration = genome.get_frames()

            if current_frame + genome_duration < random_cut:
                current_frame += genome_duration
            elif current_frame < random_cut:
                new_genome = EphemeralKeyGenome(genome.get_key_input(), current_frame + genome_duration - random_cut)
                new_genomes.append(new_genome)
                current_frame += genome_duration
            else:
                copy_genome = genome.get_copy()
                new_genomes.append(copy_genome)
                current_frame += genome_duration

        return self.__class__(new_genomes)

    # TODO: Implement method
    def k_point_cross_over(self, individual, k):
        new_genomes = list()
        genome_number = len(self.genomes)

        random_cuts = [0]

        for i in range(1, k):
            random_cuts.append(random.randint(1, genome_number))

        random_cuts.sort()
        random_cuts.append(genome_number)

        genomes_1 = self.genomes
        genomes_2 = individual.get_genomes()
        raise(RuntimeError("Not implemented method."))

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