#ifndef win_compat_h
#define win_compat_h

#include <sys/types.h>
#include <sys/stat.h>

#define PATH_MAX 512

typedef int ssize_t;

#define stat _stat
#define fstat _fstat
#define lstat _stat

#define S_IFLNK 0x0000

#endif
