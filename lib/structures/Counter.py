from threading import Lock


class Counter:
    """
    A class that maintains a counter. It supports parallel access.
    """

    def __init__(self):
        self.count = 0
        self.mutex = Lock()

    def increase_count(self):
        """
        Increases the counter in one and returns the new value
        :return: The new increased value of the counter
        """
        self.mutex.acquire()
        self.count += 1
        count = self.count
        self.mutex.release()

        return count

    def get_count(self):
        """
        getter
        """
        self.mutex.acquire()
        count = self.count
        self.mutex.release()

        return count
