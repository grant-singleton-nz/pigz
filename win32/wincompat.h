#ifndef win_compat_h
#define win_compat_h

#include <sys/stat.h>
#include <sys/types.h>

#define PATH_MAX 512

typedef int ssize_t;
#define SSIZE_MAX INT_MAX

#define stat _stati64
#define fstat _fstati64
#define lstat _stati64

#define S_IFLNK 0x0000
#define S_IFIFO 0x0000

#endif
