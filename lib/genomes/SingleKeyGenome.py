from ga_settings.word_list import word_list
from random import random, randint


# param: input:str -> the input key to press
# A single input key genome, represents a key press for one frame
class SingleKeyGenome():

    def __init__(self, input):
        self.input = input

    # crossOver: SingleKeyGenome -> SingleKeyGenome
    # Returns a new Int Genome with the mean of the both
    def cross_over(self, genome):
        new_input = ''

        if random() < 0.5:
            new_input = self.input
        else:
            new_input = genome.input

        return SingleKeyGenome(new_input)

    # mutate: None -> None
    # Mutates the current genome
    def mutate(self):
        self.input = word_list[randint(0, len(word_list) - 1)]

    # mutateWithMaxFrame: int -> None
    # Performs a regular mutation
    def mutate_with_max_frame(self, max_frame):
        self.mutate()

    # getter
    def get_frames(self):
        return 1