/* SPDX-License-Identifier: GPL-2.0 */
#include <sys/wait.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

#include "utils.h"
#include "namespace.h"


int cmd_particle_exec(const char *cmd, char **argv, bool do_fork,
	     int (*setup)(void *), void *arg)
{
	fflush(stdout);
	if (do_fork) {
		int status;
		pid_t pid;

		pid = fork();
		if (pid < 0) {
			perror("fork");
			exit(1);
		}

		if (pid != 0) {
			/* Parent  */
			if (waitpid(pid, &status, 0) < 0) {
				perror("waitpid");
				exit(1);
			}

			if (WIFEXITED(status)) {
				return WEXITSTATUS(status);
			}

			exit(1);
		}
	}

	if (setup && setup(arg))
		return -1;

    int i = 0;
    char local[10];
    
    for (i=0; i < 1000; i++){
        memset(local,0,sizeof local);
        sprintf(local,"vld%d",i);
        argv[3] = local;

	if (execvp(cmd, argv)  < 0)
		fprintf(stderr, "exec of \"%s\" failed: %s\n",
				cmd, strerror(errno));

    }

	_exit(1);
}


int cmd_exec(const char *cmd, char **argv, bool do_fork,
	     int (*setup)(void *), void *arg)
{
	fflush(stdout);
	if (do_fork) {
		int status;
		pid_t pid;

		pid = fork();
		if (pid < 0) {
			perror("fork");
			exit(1);
		}

		if (pid != 0) {
			/* Parent  */
			if (waitpid(pid, &status, 0) < 0) {
				perror("waitpid");
				exit(1);
			}

			if (WIFEXITED(status)) {
				return WEXITSTATUS(status);
			}

			exit(1);
		}
	}

	if (setup && setup(arg))
		return -1;

	if (execvp(cmd, argv)  < 0)
		fprintf(stderr, "exec of \"%s\" failed: %s\n",
				cmd, strerror(errno));
	_exit(1);
}
