#! /usr/bin/env python

from subprocess import check_output
from isodate import parse_duration


def get_dom(elm):
    cmd = ["timew", "get", elm]
    return check_output(cmd, encoding="utf-8").strip()


def main():
    """
    Print the currently elapsed time, or the day's total time.
    """
    running = get_dom("dom.active")

    if running == "1":
        elapsed = parse_duration(get_dom("dom.active.duration"))
        print(f"{elapsed}\n\n#e5c07b")
    else:
        logged_time_cmd = ["timew", "summary", "day", "$"]
        lines = check_output(logged_time_cmd, encoding="utf-8").split("\n")

        # The total time will be the last substantial line of the daily
        # summary,
        for line in reversed(lines):
            time = line.strip()
            if time != "" and not time.startswith("No filtered data"):
                print(f"{time}\n\n#56b6c2")
                break


main()

