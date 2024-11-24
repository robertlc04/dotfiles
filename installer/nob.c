#define NOB_IMPLEMENTATION
#include "nob.h"

int main(int argc, char **argv)
{
    NOB_GO_REBUILD_URSELF(argc, argv);
    Nob_Cmd cmd = {0};
    nob_cmd_append(&cmd, "cc", "-Wall", "-Wextra", "-o", "main", "main.c");
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;

    nob_cmd_append(&cmd, "./main");
    if (!nob_cmd_run_sync_and_reset(&cmd)) return 1;

    return 0;
}
