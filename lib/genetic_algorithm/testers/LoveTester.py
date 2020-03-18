from ga_settings.consts import love_path
from lib.genetic_algorithm.testers.Tester import Tester
from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired


class LoveTester(Tester):
    """
    Tester class for testing individuals and get their fitness. Runs the game and returns the resulting fitness.
    """

    def test(self, individual):
        """
        Test an individual and returns their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the fitness of the individual
        """
        with cd("./love_ga_wrapper"):
            p = Popen([love_path, ".", "run_tas"], stdin=PIPE, stdout=PIPE, stderr=PIPE)

            try:
                out, err = p.communicate()
            except TimeoutExpired:
                p.kill()
                out, err = p.communicate()

            if err != b'':
                raise RuntimeError("Game Crashed.")

            return float(out)