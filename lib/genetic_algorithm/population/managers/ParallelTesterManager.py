
class ParallelTesterManager:

    def __init__(self, testers):
        self.testers = testers

    def test_population(self, population):
        individuals = population.get_individuals()
        # TODO: For each tester create a thread

        # TODO: Queue all individuals

        # TODO: For each thread if the queue has something the thread takes it.

        # TODO: When queue is empty end all threads and return