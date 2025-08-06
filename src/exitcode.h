#ifndef IGUARD_EXITCODE_H
#define IGUARD_EXITCODE_H
enum excode {
    EXCODE_OK = 0, // good
    EXCODE_NOK = 1, // misc bad

};

#define EXCODE(code, msg, ...)      \
        excode(                     \
    code,                           \
    # code,                         \
    __FILE__,                       \
    __func__,                       \
    __LINE__,                       \
    msg __VA_OPT__( , ) __VA_ARGS__ \
        )

void excode(
    enum excode code,
    const char* name,
    const char* file,
    const char* func,
    unsigned int line,
    const char* msg,
    ...
);

#endif
