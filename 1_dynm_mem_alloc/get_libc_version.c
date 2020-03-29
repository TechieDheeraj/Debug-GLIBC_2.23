#include <stdio.h>
#include <stdlib.h>
#include <gnu/libc-version.h>

int main(int argc, char *argv[]) {
   printf("GNU libc version: %s\n", gnu_get_libc_version());
   printf("sizeof size_t %ld\n" , sizeof(size_t));
   exit(EXIT_SUCCESS);
}
