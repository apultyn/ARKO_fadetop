#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern void fadetop(void *img, int width, int height, int dist);

int main(int argc, char* argv[])
{
  char* filename = argv[1];
  int dist = atoi(argv[2]);

  int width, height;

  FILE* file = fopen(filename, "rb");

  // wczytanie wielkości pliku
  fseek(file, 0, SEEK_END); // kursor na koniec
  long file_size = ftell(file);   // numer bajta od początku pliku
  rewind(file); // kursor z powrotem na początek

  // czytanie wysokości i szerokości obrazu
  fseek(file, 18, SEEK_SET);  // przeskok do wartości wysokości i szerokości pliku bmp
  fread(&width, sizeof(int), 1, file);
  fread(&height, sizeof(int), 1, file);

  printf("Parametry obrazu: szerokość - %i, wysokość - %i\n", width, height);

  // tworzenie bufora na tablicę pixeli
  int img_size = width * height * 3;
  uint8_t *image = malloc(img_size);

  // wczytanie tablicy pixeli
  fseek(file, 54, SEEK_SET);
  fread(image, sizeof(uint8_t), img_size, file);

  fadetop(image, width, height, dist);

  FILE* output_file = fopen("output.bmp", "wb");

  // przepisanie nagłówka z dostarczonego pliku
  rewind(file);
  uint8_t* buffer = malloc(54);
  fread(buffer, sizeof(uint8_t), 54, file);
  fwrite(buffer, sizeof(uint8_t), 54, output_file);
  free(buffer);

  // wpisanie zmodyfikowanej tablicy pikseli
  fwrite(image, sizeof(uint8_t), img_size, output_file);

  fclose(file);
  fclose(output_file);
  free(image);
  return 0;
}