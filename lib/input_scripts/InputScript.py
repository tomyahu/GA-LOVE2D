# TODO: Document this
class InputScript:

    def __init__(self):
        self.input_dict = {}

    def add_input(self, input_key, start_frame, end_frame):
        self._add_input_aux(input_key, start_frame, True)
        self._add_input_aux(input_key, end_frame, False)

    def _add_input_aux(self, input_key, frame, val):
        if not (frame in self.input_dict):
            self.input_dict[frame] = {}

        self.input_dict[frame][input_key] = val
