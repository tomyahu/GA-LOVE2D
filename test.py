from ga_settings.consts import love_path, frames_to_clean, frames_to_test, frames_to_skip
from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired


individual_path = "crash"

with cd("./love_ga_wrapper"):
    p = Popen([love_path, ".", "run_tas", "clean", str(frames_to_clean), "1"], stdin=PIPE, stdout=PIPE,
              stderr=PIPE)
    p.communicate()

    p = Popen([love_path, ".", "run_tas", individual_path, str(frames_to_test + frames_to_skip), "1"], stdin=PIPE,
              stdout=PIPE, stderr=PIPE)

    try:
        out, err = p.communicate()
    except TimeoutExpired:
        p.kill()
        out, err = p.communicate()

print(out, err)