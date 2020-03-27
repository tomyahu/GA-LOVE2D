import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript
from lib.genetic_algorithm.genomes.EphemeralKeyGenome import EphemeralKeyGenome


class MultiInputEphemeralKeyIndividual(InputIndividual):
    """
    An individual composed of only ephemeral key genomes
    Can represent two or more inputs at a time
    """

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
                    aux_bool = False
                else:
                    inputs.add_input(genome_input, current_frame, current_frame + genome_duration)
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

    def single_point_cross_over(self, individual):
        """
        TODO: Refactor this
        Single point crossover method
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        self_max_frame = self.get_max_frame()
        other_individual_max_frame = individual.get_max_frame()

        if self_max_frame != other_individual_max_frame:
            raise RuntimeError("This individual's max frame is not the same as the other individual max frame")

        new_genomes = list()
        random_cut = random.randint(1, self_max_frame)
        for key in self.genome_list_dict.keys():
            self_genome_list = self.genome_list_dict[key]
            individual_genome_list = individual.genome_list_dict[key]

            current_frame = 1
            self_genome_list_index = 0
            while current_frame < random_cut:
                genome = self_genome_list[self_genome_list_index]
                current_frame += genome.get_frames()

                if current_frame < random_cut:
                    new_genomes.append(genome.get_copy())
                else:
                    new_genomes.append(EphemeralKeyGenome(key, random_cut - (current_frame - genome.get_frames())))
                    current_frame = random_cut

                self_genome_list_index += 1

            current_frame = 1
            individual_genome_list_index = 0
            while current_frame < random_cut:
                genome = individual_genome_list[individual_genome_list_index]
                current_frame += genome.get_frames()

                if current_frame > random_cut:
                    new_genomes.append(EphemeralKeyGenome(key, current_frame - random_cut))

                individual_genome_list_index += 1

            while individual_genome_list_index < len(individual_genome_list):
                genome = individual_genome_list[individual_genome_list_index]
                new_genomes.append(genome.get_copy())
                individual_genome_list_index += 1

        return MultiInputEphemeralKeyIndividual(new_genomes)

    def single_point_by_input_cross_over(self, individual):
        """
        TODO: Refactor this
        Single point crossover method by every input
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        self_max_frame = self.get_max_frame()
        other_individual_max_frame = individual.get_max_frame()

        if self_max_frame != other_individual_max_frame:
            raise RuntimeError("This individual's max frame is not the same as the other individual max frame")

        new_genomes = list()
        for key in self.genome_list_dict.keys():
            random_cut = random.randint(1, self_max_frame)
            self_genome_list = self.genome_list_dict[key]
            individual_genome_list = individual.genome_list_dict[key]

            current_frame = 1
            self_genome_list_index = 0
            while current_frame < random_cut:
                genome = self_genome_list[self_genome_list_index]
                current_frame += genome.get_frames()

                if current_frame < random_cut:
                    new_genomes.append(genome.get_copy())
                else:
                    new_genomes.append(EphemeralKeyGenome(key, random_cut - (current_frame - genome.get_frames())))
                    current_frame = random_cut

                self_genome_list_index += 1

            current_frame = 1
            individual_genome_list_index = 0
            while current_frame < random_cut:
                genome = individual_genome_list[individual_genome_list_index]
                current_frame += genome.get_frames()

                if current_frame > random_cut:
                    new_genomes.append(EphemeralKeyGenome(key, current_frame - random_cut))

                individual_genome_list_index += 1

            while individual_genome_list_index < len(individual_genome_list):
                genome = individual_genome_list[individual_genome_list_index]
                new_genomes.append(genome.get_copy())
                individual_genome_list_index += 1

        return MultiInputEphemeralKeyIndividual(new_genomes)

    def k_point_cross_over(self, individual, k):
        """
        TODO: Document this
        TODO: Implement this
        :param individual:
        :param k:
        :return:
        """
        self_max_frame = self.get_max_frame()
        other_individual_max_frame = individual.get_max_frame()

        if self_max_frame != other_individual_max_frame:
            raise RuntimeError("This individual's max frame is not the same as the other individual max frame")

        new_genomes = list()
        random_cuts = list()
        for i in range(k):
            random_cuts.append(random.randint(2, self_max_frame - 1))
        random_cuts.sort()
        for key in self.genome_list_dict.keys():
            genomes1 = self.genome_list_dict[key]
            genomes2 = individual.genome_list_dict[key]

            genomes1_frames = [1]
            genomes2_frames = [1]
            new_genomes_frames = [1]

            for genome in genomes1:
                genomes1_frames.append(genome.get_frames() + genomes1_frames[-1])

            for genome in genomes2:
                genomes2_frames.append(genome.get_frames() + genomes2_frames[-1])

            genomes1_index = 1
            genomes2_index = 1
            for random_cut in random_cuts:
                while (genomes1_index < len(genomes1)) and (genomes1[genomes1_index] < random_cut):
                    new_genomes_frames.append(genomes1_index)
                    genomes1_index += 1

                while (genomes2_index < len(genomes2)) and (genomes2[genomes1_index] < random_cut):
                    genomes2_index += 1

                if (genomes1_index % 2) != (genomes2_index % 2):
                    if genomes2[genomes2_index] == random_cut:
                        genomes2_index += 1
                    else:
                        new_genomes_frames.append(random_cut)

                # swap genomes1 with genomes2
                aux_genomes = genomes1
                aux_genomes_index = genomes1_index
                aux_genomes_frames = genomes1_frames

                genomes1 = genomes2
                genomes1_index = genomes2_index
                genomes1_frames = genomes2_frames

                genomes2 = aux_genomes
                genomes2_index = aux_genomes_index
                genomes2_frames = aux_genomes_frames

            while genomes1_index < len(genomes1):
                new_genomes_frames.append(genomes1_index)
                genomes1_index += 1

        return MultiInputEphemeralKeyIndividual(new_genomes)

    def get_max_frame(self):
        """
        getter
        """
        return self.max_frame