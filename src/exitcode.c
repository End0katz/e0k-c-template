#include "exitcode.h"

#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <stdlib.h>

void excode(
    enum excode code,
    const char* name,
    const char* file,
    const char* func,
    unsigned int line,
    const char* msg,
    ...
) {
    va_list ap;
    va_start(ap, msg);
    fprintf(stderr, "[%s()] ", func);
    vfprintf(stderr, msg, ap);
    fputc('\n', stderr);
    va_end(ap);

    fprintf(stderr, "[%s()] exit code %d (%s)\n", func, code, name);
    fprintf(stderr, "[%s()] %s:%u\n", func, file, line);

    fprintf(stderr, "perror(errno %d): ", errno);
    perror(0);
    exit(code);
}
