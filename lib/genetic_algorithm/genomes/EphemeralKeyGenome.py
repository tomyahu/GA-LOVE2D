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

    def get_frames(self):
        """
        getter
        """
        return self.frames
