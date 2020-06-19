import json
from subprocess import Popen, PIPE, TimeoutExpired

from ga_settings.consts import love_path, frames_interval, frames_to_test, frames_to_skip, absolute_path
from lib.genetic_algorithm.testers.LoveTester import LoveTester
from lib.os_lib.cd import cd


### DEPRECATED ###
class LoveHawkthornTester(LoveTester):
    """
    Tester class for testing individuals and get their fitness.
    This tester was created exclusively to run 'Journey to the Center of Hawkthorn' and takes advantage of the debug
    tools the game posseses.
    It sets a level and position for the character to spawn.
    """

    def __init__(self, aux_path="out", clean_script="clean", skip_script="skip", x_pos=0, y_pos=0, level=""):
        """
        :param aux_path: <str> the path of the temporary file to create and use on the game
        :param clean_script: <str> the path of the script made to clean the game data before another test
        :param skip_script: <str> the script that runs at the beginning of each test to skip unimportant parts of the
                                    game like menus and tutorials
        :param x_pos: <int> the in-game x position for the player character to be
        :param y_pos: <int> the in-game y position for the player character to be
        :param level: <str> the internal name of the level
        """
        LoveTester.__init__(self, aux_path=aux_path, clean_script=clean_script, skip_script=skip_script)
        self.x_pos = x_pos
        self.y_pos = y_pos
        self.level = level

    def test(self, individual):
        """
        Test an individual and returns their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the fitness of the individual
        """

        # Get input script and save it as out
        input_script = individual.get_inputs()
        input_script.save_to_file(absolute_path + "/individuals/" + self.aux_path)

        with cd(absolute_path + "/love_ga_wrapper"):
            p = Popen(
                [love_path, ".", "run_tas", self.aux_path, str(frames_to_test),
                 str(frames_to_skip), str(frames_interval),
                 "--level=" + self.level, "--position=" + str(self.x_pos) + "," + str(self.y_pos)
                 ],
                stdin=PIPE, stdout=PIPE, stderr=PIPE)

            try:
                out, err = p.communicate()
            except TimeoutExpired:
                p.kill()
                out, err = p.communicate()

            if err != b'':
                raise RuntimeError("Game Crashed.\nError: " + err.decode())

            out = json.loads(out.decode())

            fitness = out["fitness"]
            metrics = out["metrics"]
            for metric_key in metrics.keys():
                individual.add_metric(metric_key, metrics[metric_key])

            return float(fitness)
