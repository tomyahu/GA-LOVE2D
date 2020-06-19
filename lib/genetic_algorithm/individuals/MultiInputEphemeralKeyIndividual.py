import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript
from lib.genetic_algorithm.genes.EphemeralKeyGene import EphemeralKeyGene


class MultiInputEphemeralKeyIndividual(InputIndividual):
    """
    An individual composed of only ephemeral key genes
    Can represent two or more inputs at a time
    """

    def __init__(self, genes):
        InputIndividual.__init__(self, genes)

        self.gene_list_dict = dict()

        for gene in genes:
            gene_input = gene.get_key_input()

            if not (gene_input in self.gene_list_dict.keys()):
                self.gene_list_dict[gene_input] = list()
            self.gene_list_dict[gene_input].append(gene)

        self.max_frame = 0
        for gene in self.gene_list_dict[genes[0].get_key_input()]:
            self.max_frame += gene.get_frames()

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()

        for gene_input in self.gene_list_dict.keys():
            gene_list = self.gene_list_dict[gene_input]

            current_frame = 1
            aux_bool = True
            for gene in gene_list:
                gene_duration = gene.get_frames()

                if aux_bool:
                    aux_bool = False
                else:
                    inputs.add_input(gene_input, current_frame, current_frame + gene_duration)
                    aux_bool = True

                current_frame += gene_duration

        return inputs

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_key = random.choice(list(self.gene_list_dict.keys()))
        random_gene = random.choice(self.gene_list_dict[random_key])
        random_gene.mutate_with_max_frame(random_gene.get_frames() + 10)

        new_genes = list()

        max_frame = 0
        for i in range(len(self.gene_list_dict[random_key])):
            gene = self.gene_list_dict[random_key][i]
            if (max_frame < self.max_frame) and (max_frame + gene.get_frames() > self.max_frame):
                new_genes.append(EphemeralKeyGene(random_key, self.max_frame - max_frame))
                max_frame += self.max_frame - max_frame
            elif (max_frame < self.max_frame):
                new_genes.append(gene)
                max_frame += gene.get_frames()

        if max_frame < self.max_frame:
            new_genes.append(EphemeralKeyGene(random_key, self.max_frame - max_frame))

        self.gene_list_dict[random_key] = new_genes

    def single_point_cross_over(self, individual):
        """
        Single point crossover method
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        return self.k_point_cross_over(individual, 1)

    def single_point_by_input_cross_over(self, individual):
        """
        Single point crossover method by every input
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        return self.k_point_by_input_cross_over(individual, 1)

    def k_point_cross_over(self, individual, k):
        """
        K-point crossover method by every input
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :param k: <int> the number of cuts to iterate in the crossover
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        self_max_frame = self.get_max_frame()
        other_individual_max_frame = individual.get_max_frame()

        if self_max_frame != other_individual_max_frame:
            raise RuntimeError("This individual's max frame is not the same as the other individual max frame")

        new_genes = list()
        random_cuts = list()
        for i in range(k):
            random_cuts.append(random.randint(2, self_max_frame - 1))
        random_cuts.sort()
        random_cuts.append(self_max_frame+1)

        for key in self.gene_list_dict.keys():
            genes1 = self.gene_list_dict[key]
            genes2 = individual.gene_list_dict[key]

            genes1_frames = [1]
            genes2_frames = [1]
            new_genes_frames = [1]

            for gene in genes1:
                genes1_frames.append(gene.get_frames() + genes1_frames[-1])

            for gene in genes2:
                genes2_frames.append(gene.get_frames() + genes2_frames[-1])

            genes1_frames_index = 1
            genes2_frames_index = 1
            for random_cut in random_cuts:
                while (genes1_frames[genes1_frames_index] < random_cut):
                    new_genes_frames.append(genes1_frames[genes1_frames_index])
                    genes1_frames_index += 1

                while (genes2_frames[genes2_frames_index] < random_cut):
                    genes2_frames_index += 1

                if (genes1_frames_index % 2) != (genes2_frames_index % 2):
                    if genes2_frames[genes2_frames_index] == random_cut:
                        genes2_frames_index += 1
                    else:
                        new_genes_frames.append(random_cut)

                # swap genes1 with genes2
                aux_genes = genes1
                aux_genes_index = genes1_frames_index
                aux_genes_frames = genes1_frames

                genes1 = genes2
                genes1_frames_index = genes2_frames_index
                genes1_frames = genes2_frames

                genes2 = aux_genes
                genes2_frames_index = aux_genes_index
                genes2_frames = aux_genes_frames

            new_genes_frames.append(self_max_frame+1)

            for i in range(len(new_genes_frames) - 1):
                new_genes.append(EphemeralKeyGene(key, new_genes_frames[i + 1] - new_genes_frames[i]))

        return MultiInputEphemeralKeyIndividual(new_genes)

    def k_point_by_input_cross_over(self, individual, k):
        """
        K-point crossover method by every input
        :param individual: <MultiInputEphemeralKeyIndividual> the individual whom crossover is performed with
        :param k: <int> the number of cuts to iterate in the crossover
        :return: <MultiInputEphemeralKeyIndividual> the new created individual by the crossover process
        """
        self_max_frame = self.get_max_frame()
        other_individual_max_frame = individual.get_max_frame()

        if self_max_frame != other_individual_max_frame:
            raise RuntimeError("This individual's max frame is not the same as the other individual max frame")

        new_genes = list()

        for key in self.gene_list_dict.keys():
            genes1 = self.gene_list_dict[key]
            genes2 = individual.gene_list_dict[key]

            genes1_frames = [1]
            genes2_frames = [1]
            new_genes_frames = [1]

            for gene in genes1:
                genes1_frames.append(gene.get_frames() + genes1_frames[-1])

            for gene in genes2:
                genes2_frames.append(gene.get_frames() + genes2_frames[-1])

            genes1_frames_index = 1
            genes2_frames_index = 1

            random_cuts = list()
            for i in range(k):
                random_cuts.append(random.randint(2, self_max_frame - 1))
            random_cuts.sort()
            random_cuts.append(self_max_frame + 1)

            for random_cut in random_cuts:
                while (genes1_frames[genes1_frames_index] < random_cut):
                    new_genes_frames.append(genes1_frames[genes1_frames_index])
                    genes1_frames_index += 1

                while (genes2_frames[genes2_frames_index] < random_cut):
                    genes2_frames_index += 1

                if (genes1_frames_index % 2) != (genes2_frames_index % 2):
                    if genes2_frames[genes2_frames_index] == random_cut:
                        genes2_frames_index += 1
                    else:
                        new_genes_frames.append(random_cut)

                # swap genes1 with genes2
                aux_genes = genes1
                aux_genes_index = genes1_frames_index
                aux_genes_frames = genes1_frames

                genes1 = genes2
                genes1_frames_index = genes2_frames_index
                genes1_frames = genes2_frames

                genes2 = aux_genes
                genes2_frames_index = aux_genes_index
                genes2_frames = aux_genes_frames

            new_genes_frames.append(self_max_frame + 1)

            for i in range(len(new_genes_frames) - 1):
                new_genes.append(EphemeralKeyGene(key, new_genes_frames[i + 1] - new_genes_frames[i]))

        return MultiInputEphemeralKeyIndividual(new_genes)

    def get_max_frame(self):
        """
        getter
        """
        return self.max_frame
