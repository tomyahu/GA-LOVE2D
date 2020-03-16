import math
import random
from ga_settings.word_list import word_list

from lib.genetic_algorithm.genomes.SingleKeyGenome import SingleKeyGenome
from lib.genetic_algorithm.genomes.KeyFrameGenome import KeyFrameGenome
from lib.genetic_algorithm.genomes.KeyFrameDurationGenome import KeyFrameDurationGenome
from lib.genetic_algorithm.genomes.EphemeralKeyGenome import EphemeralKeyGenome


class InputGenomeFactory:

    def __init__(self):
        pass

    @staticmethod
    def get_random_single_key_genome():
        """
        Returns a random single input key genome
        :return: <SingleKeyGenome> a random single input key genome
        """
        random_key_input = random.choice(word_list)
        return SingleKeyGenome(random_key_input)

    @staticmethod
    def get_random_key_frame_genome(max_frame):
        """
        Creates a random (in input and frame) key frame genome
        :param max_frame: <int> the maximum frame that the genome created can have
        :return: <KeyFrameGenome> a random (in input and frame) key frame genome
        """
        random_key_input = random.choice(word_list)
        random_frame = random.randint(1, max_frame)
        return KeyFrameGenome(random_key_input, random_frame)

    @staticmethod
    def get_random_key_frame_duration_genome(max_frame, max_duration):
        """
        Creates a random (in input, frame and duration) key frame duration genome
        :param max_frame: <int> the maximum frame that the genome created can have
        :param max_duration: <int> the maximum frame duration that the genome created can have
        :return: <KeyFrameDurationGenome> a random (in input, frame and duration) key frame duration genome
        """
        random_key_input = random.choice(word_list)
        random_frame = random.randint(1, max_frame)
        random_duration = math.min(random.randint(1, max_duration), max_frame - random_frame + 1)
        return KeyFrameDurationGenome(random_key_input, random_frame, random_duration)

    @staticmethod
    def get_random_ephemeral_key_genome(max_frames):
        """
        Creates a random (in input and frame number) ephemeral key genome
        :param max_frames: <int> the maximum amount of frames that the genome created can have
        :return: <EphemeralKeyGenome> a random (in input and frame number) ephemeral key genome
        """
        random_key_input = random.choice(word_list)
        random_frames = random.randint(1, max_frames)
        return EphemeralKeyGenome(random_key_input, random_frames)