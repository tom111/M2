#include "map.h"
int isCheckable(map m);
void checkmaps(int nmaps, struct MAP m[nmaps]);
extern char mapfmt[];
int isStack(map m);
int isDumpable(map m);
void sprintmap(char *s, map m);
void fdprintmap(int fd, map m);
