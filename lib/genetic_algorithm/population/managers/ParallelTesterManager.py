from queue import Queue
from threading import Thread, Lock
import logging


class ParallelTesterManager:

    def __init__(self, testers):
        self.testers = testers
        self.queue = Queue()
        self.queue_mutex = Lock()

    def test_population(self, population):
        individuals = population.get_individuals()

        # For each tester create a thread
        threads = list()
        for tester in self.testers:
            threads.append(Thread(target=self.run_tester, args=(tester, population,)))

        # Queue all individuals
        for i in range(len(individuals)):
            self.queue.put((individuals[i], i))

        # Start all threads
        for thread in threads:
            thread.start()

        # Join all threads
        for thread in threads:
            thread.join()

    def run_tester(self, tester, population):
        logging.debug(self, tester, population)

        while True:
            self.queue_mutex.acquire()
            if self.queue.empty():
                self.queue_mutex.release()
                return
            else:
                pair = self.queue.get()
                self.queue_mutex.release()

                individual, individual_index = pair[0], pair[1]
                fitness = tester.test(individual)
                population.individuals_fitness[individual_index] = fitness
