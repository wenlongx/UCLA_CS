#define FD_INITIAL_ARRAY_SIZE 10
#define PID_INITIAL_ARRAY_SIZE 10
#define ARGUMENTS_INITIAL_ARRAY_SIZE 10 
#define CMD_INITIAL_ARRAY_SIZE 10
#define NUM_OPTIONS 26

const char* options_list[] = {
	"--append", "--cloexec", "--creat", "--directory",
	"--dsync", "--excl", "--nofollow", "--nonblock",
	"--rsync", "--sync", "--trunc", "--rdonly", "--rdwr",
	"--wronly", "--pipe", "--command", "--wait",
	"--close", "--verbose", "--profile", "--abort",
	"--catch", "--ignore", "--default", "--pause", "--waitsingle"
};
