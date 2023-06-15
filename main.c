#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

extern void fadetop(void *img, int width, int height, int dist);


const int bit_per_pix = 24;


int main(int argc, char* argv[])
{
  char* filename = argv[1];
  int dist = atoi(argv[2]);

  int width, height, actual_bit_per_pix;

  FILE* file = fopen(filename, "rb");

  // wczytanie wielkości pliku
  fseek(file, 0, SEEK_END); // kursor na koniec
  long file_size = ftell(file);   // numer bajta od początku pliku
  rewind(file); // kursor z powrotem na początek

  // czytanie wysokości i szerokości obrazu
  fseek(file, 18, SEEK_SET);  // przeskok do wartości wysokości i szerokości pliku bmp
  fread(&width, sizeof(int), 1, file);
  fread(&height, sizeof(int), 1, file);

  fseek(file, 28, SEEK_SET);
  fread(&actual_bit_per_pix, sizeof(int), 1, file);
  if (actual_bit_per_pix != bit_per_pix)
  {
    printf("Wrong bits per pixel parameter!\n");
    return 0;
  }

  int headerSize = 54; // Assuming a standard BMP header size of 54 bytes
  int pixelDataOffset;
  fseek(file, 10, SEEK_SET);
  fread(&pixelDataOffset, sizeof(int), 1, file);


  // Liczenie szerokości tabeli pixeli
  int bytesPerPixel = bit_per_pix / 8;
  int padding = (4 - (width * bytesPerPixel) % 4) % 4;
  int rowSize = (width * bytesPerPixel + padding);

  // tworzenie bufora na tablicę pixeli
  int img_size = rowSize * height;
  uint8_t *image = malloc(img_size);

  printf("Parametry obrazu: szerokość - %i px, wysokość - %i px\n", width, height);
  printf("Szerokość wiersza: %iB\n", rowSize);
  printf("Wielkość tabeli pixeli: %iB\n", img_size);
  printf("Pixel data offset: %i\n", pixelDataOffset);

  // wczytanie tablicy pixeli
  fseek(file, pixelDataOffset, SEEK_SET);
  fread(image, sizeof(uint8_t), img_size, file);

  // fadetop(image, rowSize, height, dist);

  FILE* output_file = fopen("output.bmp", "wb");

  // przepisanie nagłówka z dostarczonego pliku
  rewind(file);
  uint8_t* buffer = malloc(54);
  fread(buffer, sizeof(uint8_t), 54, file);
  fwrite(buffer, sizeof(uint8_t), 54, output_file);
  free(buffer);

  // wpisanie zmodyfikowanej tablicy pikseli
  fseek(output_file, pixelDataOffset, SEEK_SET);
  fwrite(image, sizeof(uint8_t), img_size, output_file);

  fclose(file);
  fclose(output_file);
  free(image);
  return 0;
}