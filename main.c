#include <stdio.h>
#include <stdlib.h>

extern void fadetop(void *img, int width, int height, int dist);

int main(int argc, char* argv[])
{
  char* filename = argv[1];
  int dist = atoi(argv[2]);

  int width, height;

  FILE* file = fopen(filename, "rb");
  fseek(file, 18, SEEK_SET);  // przeskok do wartości wysokości i szerokości pliku bmp

  fread(&width, sizeof(int), 1, file);
  fread(&height, sizeof(int), 1, file);

  printf("Parametry obrazu: szerokość - %i, wysokość - %i\n", width, height);
  return 0;
}