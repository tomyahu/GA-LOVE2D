import sys
from ga_settings.consts import love_path, frames_to_test, frames_to_skip, frames_interval
from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired

## Run an input sequence ##
# Gets the input sequence path to run #
individual_path = sys.argv[1]

# Move to the love_ga_wrapper directory #
with cd("./love_ga_wrapper"):

    # Run the input sequence in the games using the parameters in /ga_settings/consts.py #
    p = Popen([love_path, ".", "run_tas", individual_path, str(frames_to_test), str(frames_to_skip), str(frames_interval)], stdin=PIPE,
              stdout=PIPE, stderr=PIPE)

    try:
        out, err = p.communicate()
    except TimeoutExpired:
        p.kill()
        out, err = p.communicate()

# Prints output #
print("Output:")
print(out.decode())
print("")

# Prints error #
print("Error:")
print(err.decode())
