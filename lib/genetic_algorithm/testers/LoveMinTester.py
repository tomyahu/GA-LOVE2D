from lib.genetic_algorithm.testers.LoveTester import LoveTester


class LoveMinTester(LoveTester):
    """
    Tester class for testing individuals and get their fitness. Runs the game and returns the resulting fitness.
    """

    def test(self, individual):
        """
        Test an individual and returns the additive inverse of their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the additive inverse of the fitness of the individual
        """
        return - LoveTester.test(self, individual)