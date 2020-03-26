import math

from ga_settings.word_list import word_list
from lib.genetic_algorithm.genomes.EphemeralKeyGenome import EphemeralKeyGenome
from lib.genetic_algorithm.genomes.factories.InputGenomeFactory import InputGenomeFactory
from lib.genetic_algorithm.individuals.InputKeyIndividual import InputKeyIndividual
from lib.genetic_algorithm.individuals.InputKeyFrameIndividual import InputKeyFrameIndividual
from lib.genetic_algorithm.individuals.InputKeyFrameDurationIndividual import InputKeyFrameDurationIndividual
from lib.genetic_algorithm.individuals.EphemeralKeyIndividual import EphemeralKeyIndividual
from lib.genetic_algorithm.individuals.MultiInputEphemeralKeyIndividual import MultiInputEphemeralKeyIndividual


class InputIndividualFactory:
    """
    a factory class to create individuals that represent input scripts
    """

    @staticmethod
    def get_random_input_single_key_individual(size):
        """
        creates a new input key individual with a number of random genomes equal to size (number of frames to test)
        :param size: <int> the amount of genes the individual has
        :return: <InputKeyIndividual> the new random input key individual
        """
        genomes = list()
        for i in range(size):
            random_genome = InputGenomeFactory.get_random_single_key_genome()
            genomes.append(random_genome)

        return InputKeyIndividual(genomes)

    @staticmethod
    def get_random_key_frame_individual(size, max_frame):
        """
        creates a new key frame individual with a number of random genomes equal to size and a max frame of max_frame
        :param size: <int> the amount of genes the individual as
        :param max_frame: <int> the maximum frame
        :return: <InputKeyFrameIndividual> the new random input key frame individual
        """
        genomes = list()
        for i in range(size):
            random_genome = InputGenomeFactory.get_random_key_frame_genome(max_frame)
            genomes.append(random_genome)

        return InputKeyFrameIndividual(genomes)

    @staticmethod
    def get_random_key_frame_duration_individual(size, max_frame, max_duration):
        """
        creates a new key frame duration individual with a number of random genomes equal to size, a max initial frame
        of max_frame and a max frame duration of max_duration.
        :param size: <int> the amount of genes the individual as
        :param max_frame: <int> the maximum frame
        :param max_duration: <int> the maximum duration of each gene
        :return: <InputKeyFrameDurationIndividual> the new random input key frame duration individual
        """
        genomes = list()
        for i in range(size):
            random_genome = InputGenomeFactory.get_random_key_frame_duration_genome(max_frame, max_duration)
            genomes.append(random_genome)

        return InputKeyFrameDurationIndividual(genomes)

    @staticmethod
    def get_random_ephemeral_key_individual(size, max_frames):
        """
        Creates a new ephemeral key individual with a number of random genes equal to size. The number of frames of the
        ephemeral genes are limited by max_frames
        :param size: <int> the amount of genes the individual has
        :param max_frames: <int> the maximum frame
        :return: <EphemeralKeyIndividual> the new random ephemeral key individual
        """
        genomes = list()
        for i in range(size):
            random_genome = InputGenomeFactory.get_random_ephemeral_key_genome(max_frames)
            genomes.append(random_genome)

        return EphemeralKeyIndividual(genomes)

    @staticmethod
    def get_random_ephemeral_individual_with_frames_to_test(size, frames_to_test):
        """
        Creates a new ephemeral key individual with a number of random genomes equal to size. This method in particular
        tweaks the maximum number of frames a gene can last acording to the frames to test, so the expected value of
        frames the individual created used is equeal to the frames to test.
        :param size: <int> the amount of genes the individual has
        :param frames_to_test: <int> the amount of frames that are to be tested
        :return: <EphemeralKeyIndividual> the new random ephemeral key individual
        """
        return InputIndividualFactory.get_random_ephemeral_key_individual(size, math.floor(2*frames_to_test/size) + 1)

    @staticmethod
    def get_random_multi_input_ephemeral_key_individual(frames_to_test, avg_inputs, input_no_input_ratio):
        """
        Creates a new multi ephemeral key individual
        :param frames_to_test:
        :param input_no_input_ratio:
        :return:
        """
        genomes = list()

        for word in word_list:
            current_frame = 1

            aux_bool = True
            while current_frame < frames_to_test:
                max_genome_duration = int((frames_to_test / avg_inputs) / (1 + input_no_input_ratio))
                if aux_bool:
                    aux_bool = False
                else:
                    max_genome_duration = int(max_genome_duration * input_no_input_ratio)
                    aux_bool = True

                new_genome = InputGenomeFactory.get_random_duration_ephemeral_key_genomes(word, max_genome_duration)

                current_frame += new_genome.get_frames()
                if current_frame < frames_to_test:
                    genomes.append(new_genome)
                else:
                    genomes.append(EphemeralKeyGenome(word, frames_to_test - (current_frame - new_genome.get_frames())))

        return MultiInputEphemeralKeyIndividual(genomes)
