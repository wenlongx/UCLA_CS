/*
 * CS 111 Lab 1
 * Eggert Winter 2016
 *
 * Michael Xiong (404463570)
 * Wenlong Xiong (204407085)
 *
 * Currently updated to Lab 1b specs
 *
 * Lab 1b Design Project
 * Extra option included (--waitsingle N) allows user to wait for specific command
 * README contains documentation on -- waitsingle
 *
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <getopt.h>
#include <unistd.h>

#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h>

#include <sys/time.h>
#include <sys/resource.h>

#include <unistd.h>

#include "constants.h"

/* Should be the same as option_index, once we've implemented everything
 * Each option is mapped to an integer for the return value of getopt_long:
 * 0	--append
 * 1	--cloexec
 * 2	--creat
 * 3	--directory
 * 4	--dsync
 * 5	--excl
 * 6	--nofollow
 * 7	--nonblock
 * 8	--rsync
 * 9	--sync
 * 10	--trunc
 * 11	--rdonly f
 * 12	--rdwr f
 * 13	--wronly f
 * 14	--pipe
 * 15	--command i o e cmd args
 * 16	--wait
 * 17   --close
 * 18	--verbose
 * 19	--profile
 * 20	--abort
 * 21	--catch N
 * 22	--ignore N
 * 23	--default N
 * 24	--pause
 */

int add_oflag(int, int*);
int check_missing_operand(char** argv, int optind, int argc);
int check_has_operand(char** argv, int optind, int argc);
int check_multiple_operand(char** argv, int optind, int argc);
int check_command_arguments(char** argv, int argc, int optind);
char** parse_cmd_args(int* argno_ptr, char** argv, int* optind_ptr, int argc);
int is_number(char* optarg);
int realloc_fd(int* file_descriptors, int fd_arr_size);
static void catch_handler(int signum);
void do_profile(struct rusage *start_usage, struct rusage *end_usage);
int timeval_subtract (struct timeval *result, struct timeval *x, struct timeval *y);


int main(int argc, char **argv) {
	int exit_code = 0;
	int print_verbose = 0;
	int print_profile = 0;
	int oflag = 0;
	int* oflag_ptr = &oflag;
	
	static int getopt_return = -1;
	static struct option long_options[] = {
		{ "append", no_argument, &getopt_return, 0 },
		{ "cloexec", no_argument, &getopt_return, 1 },
		{ "creat", no_argument, &getopt_return, 2 },
		{ "directory", no_argument, &getopt_return, 3 },
		{ "dsync", no_argument, &getopt_return, 4 },
		{ "excl", no_argument, &getopt_return, 5 },
		{ "nofollow", no_argument, &getopt_return, 6 },
		{ "nonblock", no_argument, &getopt_return, 7 },
		{ "rsync", no_argument, &getopt_return, 8 },
		{ "sync", no_argument, &getopt_return, 9 },
		{ "trunc", no_argument, &getopt_return, 10 },
		{ "rdonly", required_argument, &getopt_return, 11 },
		{ "rdwr", required_argument, &getopt_return, 12 },
		{ "wronly", required_argument, &getopt_return, 13 },
		{ "pipe", no_argument, &getopt_return, 14 },
		{ "command", required_argument, &getopt_return, 15 },
		{ "wait", no_argument, &getopt_return, 16 },
		{ "close", required_argument, &getopt_return, 17 },
		{ "verbose", no_argument, &getopt_return, 18 },
		{ "profile", no_argument, &getopt_return, 19 },
		{ "abort", no_argument, &getopt_return, 20 },
		{ "catch", required_argument, &getopt_return, 21 },
		{ "ignore", required_argument, &getopt_return, 22 },
		{ "default", required_argument, &getopt_return, 23 },
		{ "pause", no_argument, &getopt_return, 24 },
		{ "waitsingle", required_argument, &getopt_return, 25 },
		{ 0, 0, 0, 0 }
	};
	
	// create array of open file descriptors
	int * file_descriptors = (int *) malloc(sizeof(int) * FD_INITIAL_ARRAY_SIZE);
	if (file_descriptors == NULL){
		fprintf(stderr, "malloc failed");
	}
	int num_fd = 0;
	int fd_arr_size = FD_INITIAL_ARRAY_SIZE;

	// create an array of PIDs
	pid_t *pids = (pid_t *) malloc(sizeof(pid_t) * PID_INITIAL_ARRAY_SIZE);
	if (pids == NULL){
		fprintf(stderr, "malloc failed");
	}
	int num_children = 0;
	int pid_arr_size = PID_INITIAL_ARRAY_SIZE;
	int actual_children = 0;

	// create an array of command arguments
	char *** cmd_args = (char ***) malloc(sizeof(char**) * CMD_INITIAL_ARRAY_SIZE);
	if (cmd_args == NULL){
		fprintf(stderr, "malloc failed");
	}
	int num_cmd = 0;
	int cmd_arr_size = CMD_INITIAL_ARRAY_SIZE;

	
	while(1) {
		int option_index = 0; // should be the same as getopt_return, dw about it
		getopt_return = -1; // -1 if no options left -> should contain option number
		
		if (optind >= argc) break;
		
		getopt_long(argc, argv, "", long_options, &option_index);
		
		if (getopt_return == -1) {
			break;
		}
		
		struct rusage start_usage, end_usage;
		
		if(print_profile){
			getrusage(RUSAGE_SELF, &start_usage);
		}

		/*
		 * For cases 0-10, keep a variable, set to 0 initially, and bitwise 
		 * or | each new file flag to be opened with.
 		 */
		switch (getopt_return) {
			// file options
			case 0:
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
				// verbose option
				if(check_has_operand(argv, optind, argc)){
					fprintf(stderr, "Expect no operands.\n");
					fflush(stderr);
					break;
				}
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}

				if (add_oflag(getopt_return, oflag_ptr) == -1) {
					fprintf(stderr, "Invalid File Flag");
					fflush(stderr);
				}
				
				break;

			// file opening options
			case 11:
			case 12:
			case 13:
				// check operands
				if (check_missing_operand(argv, optind, argc))
                    break;
                if (check_multiple_operand(argv, optind, argc))
                    break;				

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}

				if (num_fd >= fd_arr_size) {
					fd_arr_size = realloc_fd(file_descriptors, fd_arr_size);
				}
				add_oflag(getopt_return, oflag_ptr);
				file_descriptors[num_fd] = open(optarg, oflag, 0777);
				num_fd++;
				add_oflag(99, oflag_ptr); // resets oflags
	
				break;
			
			// pipe
			case 14:
				// check operands
				if(check_has_operand(argv, optind, argc)){
                    fprintf(stderr, "Expect no operands.\n");
               	    fflush(stderr);
               	    break;
               	}

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}
				
				int fd[2];
				int ret = pipe(fd);

				if(ret){
					fprintf(stderr, "Piping failed.\n");
					fflush(stderr);
					break;
				}
			
				if (num_fd+2 >= fd_arr_size) {
					fd_arr_size = realloc_fd(file_descriptors, fd_arr_size);
				}
				file_descriptors[num_fd] = fd[0]; 
				num_fd++;
				file_descriptors[num_fd] = fd[1]; 
				num_fd++;

				break;
			
			// command
			case 15: {
				// check arguments
				if (check_command_arguments(argv, argc, optind)) {
                    fprintf(stderr, "Command arguments invalid.\n");
                    fflush(stderr);
                    break;
                }

				int argno = 0;
				int* argno_ptr = &argno;
				// get arguments
				int temp_optind = optind;
                char** arguments = parse_cmd_args(argno_ptr, argv, &optind, argc);

				int in = atoi(argv[temp_optind-1]);
				int out = atoi(argv[temp_optind]);
				int err = atoi(argv[temp_optind+1]);
				char* cmd = argv[temp_optind+2];

				// verbose option
				if (print_verbose) {
					printf("--command %i %i %i", in, out, err);
					for (int k = 0; k < argno; k++) {
						printf(" %s", arguments[k]);
					}
					printf("\n");
					fflush(stdout);
				}

				// add arguments to the cmd_args array
				if (num_cmd >= cmd_arr_size) {
					cmd_args = (char ***) realloc(cmd_args, cmd_arr_size * 2 * sizeof(char**));
					if (cmd_args == NULL){
						fprintf(stderr, "realloc failed");
					}
					cmd_arr_size = cmd_arr_size * 2;
				}
				cmd_args[num_cmd] = arguments;
				num_cmd++;

				if(num_children >= pid_arr_size){
					pids = (pid_t*) realloc(pids, pid_arr_size * 2 * sizeof(pid_t));
					if (pids == NULL){
						fprintf(stderr, "realloc failed");
					}
					pid_arr_size *= 2;
				}

				pids[num_children] = fork();
	
				//in child process
				if(pids[num_children] == 0){
					//dup stdin, stdout, and stderr	
					dup2(file_descriptors[in], STDIN_FILENO);
					dup2(file_descriptors[out], STDOUT_FILENO);
					dup2(file_descriptors[err], STDERR_FILENO);

					for (int index = 0; index < num_fd; index++) {
						if ((file_descriptors[index] != -1) && (index != in)
							&& (index != out) && (index != err)) {
							close(file_descriptors[index]);
						}
					}
					//execvp
					int exit_status = execvp(cmd, arguments);
					fflush(stderr);
					//die w/ error code 1 if execvp fails
					exit(exit_status);
				}
				
				close(file_descriptors[in]);
				close(file_descriptors[out]);
				close(file_descriptors[err]);
				
				//parent
				num_children++;
				actual_children++;

				break;
			}
			// wait
            case 16:
				// check arguments
				if(optind < argc){
					if(check_has_operand(argv, optind, argc)){
                	    fprintf(stderr, "Expect no operands.\n");
                	    fflush(stderr);
                	    break;
                	}
				}

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}

				// wait for commands to finish
                int status;
                int returned_pid;
                int index = 0;
                int children_remaining = actual_children;
                
                while(children_remaining > 0) {
					returned_pid = waitpid(-1, &status, 0);
                    if (returned_pid < 0) {
                        printf("waitpid failed");
                        fflush(stdout);
                        continue;
                    }
                    for (int k = 0; k < num_children; k++) {
                        if (returned_pid == pids[k]) {
                            index = k;
                            break;
                        }
                    }	// for loop should always end via a break

                    exit_code = status > exit_code ? status : exit_code; 
                    printf("%i ", status);
                    int counter = 0;
                    while(cmd_args[index][counter] != NULL) {
                        printf("%s ", cmd_args[index][counter]);
                        counter++;
                    }
                    printf("\n");
                    children_remaining--;

					pids[index] = -1;

					actual_children = 0;
                }

				if(print_profile){
					struct rusage usage;

					getrusage(RUSAGE_CHILDREN, &usage);

					struct timeval user = usage.ru_utime;
					struct timeval system  = usage.ru_stime;
					printf("%s timing: ", options_list[getopt_return]);
					printf("Children User/System time: %ld.%06lds/%ld.%06lds  ",
						 user.tv_sec, user.tv_usec, system.tv_sec, system.tv_usec);
					fflush(stdout);
				}
                break;

			// close
            case 17:
                //check number of arguments (should be 1)
                if (check_missing_operand(argv, optind, argc))
                    break;
                if (check_multiple_operand(argv, optind, argc))
                    break;
                
                // check that fd is a number
                if(!is_number(optarg)){
                    fprintf(stderr, "Operand must be number.\n");
                    fflush(stderr);
                    break;
                }
				
				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}
                    
                close(file_descriptors[atoi(optarg)]);
				file_descriptors[atoi(optarg)] = -1;
				break;
     
			// verbose           
            case 18:
				// check for invalid arguments
				if(check_has_operand(argv, optind, argc))
				{
					fprintf(stderr, "Expect no operands.\n");
					fflush(stderr);
					break;
				}
				else
					print_verbose = 1;
                break;

			// profile
			case 19:
				// check for invalid arguments
				if(check_has_operand(argv, optind, argc))
				{
					fprintf(stderr, "Expect no operands.\n");
					fflush(stderr);
					break;
				}

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}
				
				print_profile = 1;
				break;

			// abort
			case 20:
				// check for invalid arguments
				if(check_has_operand(argv, optind, argc))
				{
					fprintf(stderr, "Expect no operands.\n");
					fflush(stderr);
					break;
				}

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}

				raise(SIGSEGV);
				break;

			// catch
			case 21:
				// check operands
				if (check_missing_operand(argv, optind, argc))
                    break;
                if (check_multiple_operand(argv, optind, argc))
                    break;				

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}
				struct sigaction catch_sa;
				catch_sa.sa_handler = catch_handler;
				sigaction(atoi(optarg), &catch_sa, NULL);
				break;

			// ignore
			case 22:
				// check operands
				if (check_missing_operand(argv, optind, argc))
                    break;
                if (check_multiple_operand(argv, optind, argc))
                    break;				

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}
				struct sigaction ignore_sa;
				ignore_sa.sa_handler = SIG_IGN;
				sigaction(atoi(optarg), &ignore_sa, NULL);
				break;

			// default
			case 23:
				// check operands
				if (check_missing_operand(argv, optind, argc))
                    break;
                if (check_multiple_operand(argv, optind, argc))
                    break;				

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}
				struct sigaction default_sa;
				default_sa.sa_handler = SIG_DFL;
				sigaction(atoi(optarg), &default_sa, NULL);
				break;
			
			// pause
			case 24:
				// check for invalid arguments
				if(check_has_operand(argv, optind, argc))
				{
					fprintf(stderr, "Expect no operands.\n");
					fflush(stderr);
					break;
				}

				// verbose option
				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s\n", option_name);
					fflush(stdout);
				}

				pause();
				break;

			//waitsingle
			case 25: {
				// wait for a specific # of process run				
				if (check_missing_operand(argv, optind, argc))
                    break;
                if (!(optind >= argc)){
					if (check_multiple_operand(argv, optind, argc))
                    	break;				
				}
				if(!is_number(optarg)){
					fprintf(stderr, "Argument must be a number.\n");
					fflush(stderr);
					break;
				}

				if(atoi(optarg) >= num_children){
					fprintf(stderr, "Process has not been run yet.\n");
					fflush(stderr);
					break;
				}

				if (print_verbose) {
					const char* option_name = options_list[getopt_return];
					printf("%s %s\n", option_name, optarg);
					fflush(stdout);
				}

				int status;
				int pid = pids[atoi(optarg)];
				int returned_pid;
				int index = 0;
				if (pid < 0) break;

				returned_pid = waitpid(pid, &status, 0); 	
                    
				if (returned_pid < 0 || returned_pid != pid) {
                    printf("waitpid failed");
                    fflush(stdout);
                    continue;
                }
                    
                for (int k = 0; k < num_children; k++) {
                    if (returned_pid == pids[k]) {
                        index = k;
                        break;
                    }
                }	// for loop should always end via a break

                exit_code = status > exit_code ? status : exit_code; 
                printf("%i ", status);
               	int counter = 0;
				while(cmd_args[index][counter] != NULL) {
                    printf("%s ", cmd_args[index][counter]);
                    counter++;
                }
                printf("\n");
				actual_children--;
				pids[atoi(optarg)] = -1;
				break;
			}			
				//otherwise, wait for everything to finish
			default:
				break;
		}

		if(print_profile && getopt_return != 19 && (getopt_return > 10)){
			if (getopt_return != 16) {
				printf("%s timing: ", options_list[getopt_return]);
				fflush(stdout);
			}
			getrusage(RUSAGE_SELF, &end_usage);
			do_profile(&start_usage, &end_usage);
		}
	}

	
	// free memory allocation
	free(file_descriptors);
	free(pids);
	for (int k = 0; k < num_cmd; k++) {
		free(cmd_args[k]);
	}
	free(cmd_args);
	exit(exit_code);
}


// ///////////////////////////////////////////
// Helper Functions
// ///////////////////////////////////////////

static void catch_handler(int signum) {
	fprintf(stderr, "%i caught\n", signum);
	fflush(stderr);
	exit(signum);
}

int add_oflag(int option, int* flag_ptr) {
	switch(option) {
		case 0:
			*flag_ptr = (*flag_ptr | O_APPEND);
			break;
		case 1:
			*flag_ptr = (*flag_ptr | O_CLOEXEC);
			break;
		case 2:
			*flag_ptr = (*flag_ptr | O_CREAT);
			break;
		case 3:
			*flag_ptr = (*flag_ptr | O_DIRECTORY);
			break;
		case 4:
			*flag_ptr = (*flag_ptr | O_DSYNC);
			break;
		case 5:
			*flag_ptr = (*flag_ptr | O_EXCL);
			break;
		case 6:
			*flag_ptr = (*flag_ptr | O_NOFOLLOW);
			break;
		case 7:
			*flag_ptr = (*flag_ptr | O_NONBLOCK);
			break;
		case 8:
			*flag_ptr = (*flag_ptr | O_RSYNC);
			break;
		case 9:
			*flag_ptr = (*flag_ptr | O_SYNC);
			break;
		case 10:
			*flag_ptr = (*flag_ptr | O_TRUNC);
			break;
		case 11:
			*flag_ptr = (*flag_ptr | O_RDONLY);
			break;
		case 12:
			*flag_ptr = (*flag_ptr | O_RDWR);
			break;
		case 13:
			*flag_ptr = (*flag_ptr | O_WRONLY);
			break;
		case 99:
			*flag_ptr = 0;
			return 0;
			break;
		default:
			return -1;
	}
	return 1;
}

int check_has_operand(char** argv, int optind, int argc)
{
	if (optind+1 > argc) return 0;
    for (int x = 0; x < NUM_OPTIONS; x++) {
        if (!strcmp(argv[optind-1], options_list[x])) {
            return 0;
        }
    }
    return 1;
}

int check_missing_operand(char** argv, int optind, int argc)
{
	if (optind+1 > argc) return 0;
    for (int x = 0; x < NUM_OPTIONS; x++) {
        if (!strcmp(argv[optind-1], options_list[x])) {
            fprintf(stderr, "Missing Operand\n");
            fflush(stderr);
            return 1;
        }
    }
    return 0;
}

int check_multiple_operand(char** argv, int optind, int argc)
{
	if (optind+1 > argc) return 0;
    for (int x = 0; x < NUM_OPTIONS; x++) {
        if (!strcmp(argv[optind], options_list[x])) {
            return 0;
        }
    }
    fprintf(stderr, "Too Many Operands\n");
    fflush(stderr);
    return 1;
}

//1 for error, 0 for ok
int check_command_arguments(char** argv, int argc, int optind)
{
    //if not enough arguments, cannot be valid, avoids seg fault
    if(optind + 2 >= argc){
        return 1;
    }
    
    for(int x = -1; x < 2; x++){
        if(!is_number(argv[optind + x]))
           return 1;
    }
    
    for (int x = 0; x < NUM_OPTIONS; x++) {
        if (!strcmp(argv[optind+2], options_list[x])) {
            return 1;
        }
    }
    
    return 0;
}

char** parse_cmd_args(int* argno_ptr, char** argv, int* optind_ptr, int argc)
{
    // parse arguments
    char* cmd = argv[*optind_ptr + 2];

    int position = *optind_ptr + 3;
    int argno = 0;
    int arguments_arr_size = ARGUMENTS_INITIAL_ARRAY_SIZE;
    char** arguments = (char**) malloc(sizeof(char*) * arguments_arr_size);
    if (arguments == NULL){
        fprintf(stderr, "malloc failed");
    }
    arguments[0] = cmd;
    argno++;

    int should_break = 0;
    while (1) {
        if (position >= argc)
            break;
        
        for (int x = 0; x < NUM_OPTIONS; x++) {
            if (!strcmp(argv[position], options_list[x])) {
                should_break = 1;
                break;
            }
        }
        
        if (should_break)
            break;
        
        if (argno >= arguments_arr_size) {
            arguments = (char **) realloc(arguments, arguments_arr_size * 2 * sizeof(char*));
            if(arguments == NULL){
                fprintf(stderr, "realloc failed");
            }
            else
                arguments_arr_size = arguments_arr_size * 2;
        }
        
        arguments[argno] = argv[position];
        argno++;
        position++;
        
    }
	
	if (position < argc) *optind_ptr = position;
	

    // null terminate arguments array
    arguments = (char **) realloc(arguments, (argno + 1) * sizeof(char*));
	if (arguments == NULL){
        fprintf(stderr, "realloc failed");
    }
    arguments[argno] = '\0';

	*argno_ptr = argno;

    return arguments;
}

int is_number(char* optarg){
    int k = 0;
    while(optarg[k]){
        if(!isdigit(optarg[k]))
            return 0;
        k++;
    }
    return 1;
}

int realloc_fd(int* file_descriptors, int fd_arr_size){
    file_descriptors = (int *) realloc(file_descriptors, fd_arr_size * 2 * sizeof(int));
    if (file_descriptors == NULL){
        fprintf(stderr, "realloc failed");
        exit(1);
    }
    else
        return fd_arr_size * 2;
}

void do_profile(struct rusage *start_usage, struct rusage *end_usage){

	struct timeval user, system;
	
	struct timeval user_start = start_usage->ru_utime;
	struct timeval system_start = start_usage->ru_stime;

	struct timeval user_end = end_usage->ru_utime;
	struct timeval system_end = end_usage->ru_stime;
		
	timeval_subtract(&user, &user_end, &user_start);
	timeval_subtract(&system, &system_end, &system_start);

	//printf("\tSystem started at: %ld.%06ld\n", (long) system_start.tv_sec, (long) system_start.tv_usec);	
	//printf("\tSystem ended at: %ld.%06ld\n", (long) system_end.tv_sec, (long) system_end.tv_usec);
	//printf("\tUser started at: %ld.%06ld\n", (long) user_start.tv_sec, (long) user_start.tv_usec);
	//printf("\tUser ended at: %ld.%06ld\n", (long) user_end.tv_sec, (long) user_end.tv_usec);
	printf("User/System CPU Time: %ld.%06lds/%ld.%06lds  ", (long) user.tv_sec, (long) user.tv_usec, (long) system.tv_sec, (long) system.tv_usec);
	printf("Page Reclaims/Faults: %ld/%ld  ", (end_usage->ru_minflt - start_usage->ru_minflt), (end_usage->ru_majflt - start_usage->ru_majflt));
	printf("Voluntary/Involuntary Context Switches: %ld/%ld  ", (end_usage->ru_nvcsw - start_usage->ru_nvcsw), (end_usage->ru_nivcsw - start_usage->ru_nivcsw));
	printf("\n");
	fflush(stdout);
}

int timeval_subtract (struct timeval *result, struct timeval *x, struct timeval *y)
{
  /* Perform the carry for the later subtraction by updating y. */
  if (x->tv_usec < y->tv_usec) {
    int nsec = (y->tv_usec - x->tv_usec) / 1000000 + 1;
    y->tv_usec -= 1000000 * nsec;
    y->tv_sec += nsec;
  }
  if (x->tv_usec - y->tv_usec > 1000000) {
    int nsec = (x->tv_usec - y->tv_usec) / 1000000;
    y->tv_usec += 1000000 * nsec;
    y->tv_sec -= nsec;
  }

  /* Compute the time remaining to wait.
 *      tv_usec is certainly positive. */
  result->tv_sec = x->tv_sec - y->tv_sec;
  result->tv_usec = x->tv_usec - y->tv_usec;

  /* Return 1 if result is negative. */
  return x->tv_sec < y->tv_sec;
} 
