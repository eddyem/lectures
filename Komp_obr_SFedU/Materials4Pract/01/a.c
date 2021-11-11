//usr/bin/gcc $0 && exec ./a.out "$@"

#include <stdio.h>

int main(int argc, char **argv){
  for(int x = 1; x < argc; ++x)
  printf("arg %d is %s\n", x, argv[x]);
  printf("Done\n");
  return 0;
}
