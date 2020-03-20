import random

from lib.genetic_algorithm.genomes.SingleKeyGenome import SingleKeyGenome


class EphemeralKeyGenome(SingleKeyGenome):
    """
    A genome that represents a certain key that was pressed for a number of frames
    """

    def __init__(self, key_input, frames):
        """
        :param key_input: <str> the input key to press
        :param frames: <int> the number of frames the actions will last
        """
        SingleKeyGenome.__init__(self, key_input)
        self.frames = frames

    def get_copy(self):
        """
        Returns a copy of the current genome
        :return: <EphemeralKeyGenome> a copy of the current genome
        """
        return EphemeralKeyGenome(self.key_input, self.frames)

    def get_frames(self):
        """
        getter
        """
        return self.frames

    def mutate_with_max_frame(self, max_frame):
        """
        Mutates the frame of the individual and changes it to a random frame from 1 to the max frame
        :param max_frame: <int> the max frame for the genome to mutate
        """
        self.frames = random.randint(1,max_frame)
        SingleKeyGenome.mutate(self)
