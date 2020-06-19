import math
import random
from ga_settings.word_list import word_list

from lib.genetic_algorithm.genes.SingleKeyGene import SingleKeyGene
from lib.genetic_algorithm.genes.KeyFrameGene import KeyFrameGene
from lib.genetic_algorithm.genes.KeyFrameDurationGene import KeyFrameDurationGene
from lib.genetic_algorithm.genes.EphemeralKeyGene import EphemeralKeyGene


class InputGeneFactory:

    @staticmethod
    def get_random_single_key_gene():
        """
        Returns a random single input key gene
        :return: <SingleKeyGene> a random single input key gene
        """
        random_key_input = random.choice(word_list)
        return SingleKeyGene(random_key_input)

    @staticmethod
    def get_random_key_frame_gene(max_frame):
        """
        Creates a random (in input and frame) key frame gene
        :param max_frame: <int> the maximum frame that the gene created can have
        :return: <KeyFrameGene> a random (in input and frame) key frame gene
        """
        random_key_input = random.choice(word_list)
        random_frame = random.randint(1, max_frame)
        return KeyFrameGene(random_key_input, random_frame)

    @staticmethod
    def get_random_key_frame_duration_gene(max_frame, max_duration):
        """
        Creates a random (in input, frame and duration) key frame duration gene
        :param max_frame: <int> the maximum frame that the gene created can have
        :param max_duration: <int> the maximum frame duration that the gene created can have
        :return: <KeyFrameDurationGene> a random (in input, frame and duration) key frame duration gene
        """
        random_key_input = random.choice(word_list)
        random_frame = random.randint(1, max_frame)
        random_duration = math.min(random.randint(1, max_duration), max_frame - random_frame + 1)
        return KeyFrameDurationGene(random_key_input, random_frame, random_duration)

    @staticmethod
    def get_random_ephemeral_key_gene(max_frames):
        """
        Creates a random (in input and frame number) ephemeral key gene
        :param max_frames: <int> the maximum amount of frames that the gene created can have
        :return: <EphemeralKeyGene> a random (in input and frame number) ephemeral key gene
        """
        random_key_input = random.choice(word_list)
        random_frames = random.randint(1, max_frames)
        return EphemeralKeyGene(random_key_input, random_frames)

    @staticmethod
    def get_random_duration_ephemeral_key_genes(key_input, max_frames):
        """
        Creates a random (in frame number) ephemeral key gene with a predefined key input
        :param key_input: <str> the input the ephemeral individual will have
        :param max_frames: <int> the maximum amount of frames that the gene created can have
        :return: <EphemeralKeyGene> a random (in frame number) ephemeral key gene with a predefined key input
        """
        random_frames = random.randint(1, max_frames)
        return EphemeralKeyGene(key_input, random_frames)
