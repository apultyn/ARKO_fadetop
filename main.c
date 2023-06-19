#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

extern void fadetop(void *img, int width, int height, int dist);


const int bitsPerPixel = 24;
const int headerSize = 54;
const int bytesPerPixel = 3;


int main(int argc, char* argv[])
{
  char* filename = argv[1];
  int dist = atoi(argv[2]);

  if (argc != 3)
  {
    printf("Usage of program: ./fadetop [bmp file location] [dist]\n");
    return 0;
  }

  if (dist < 0)
  {
    printf("Dist parameter can't be negative!\n");
    return 0;
  }

  int width,
      height,
      actual_bitsPerPixel,
      file_size,
      pixelDataOffset,
      padding,
      rowSize,
      img_size;

  FILE* inputFile = fopen(filename, "rb");

  fseek(inputFile, 0, SEEK_END);
  file_size = ftell(inputFile);
  rewind(inputFile);

  fseek(inputFile, 18, SEEK_SET);
  fread(&width, sizeof(int), 1, inputFile);
  fread(&height, sizeof(int), 1, inputFile);

  fseek(inputFile, 28, SEEK_SET);
  fread(&actual_bitsPerPixel, sizeof(int), 1, inputFile);
  if (actual_bitsPerPixel != bitsPerPixel)
  {
    printf("BMP file must be in format 24 bites per pixel!\n");
    fclose(inputFile);
    return 0;
  }

  fseek(inputFile, 10, SEEK_SET);
  fread(&pixelDataOffset, sizeof(int), 1, inputFile);

  padding = (4 - (width * bytesPerPixel) % 4) % 4;
  rowSize = (width * bytesPerPixel + padding);

  // tworzenie bufora na tablicę pixeli
  img_size = rowSize * height;
  uint8_t *image = malloc(img_size);

  printf("Picture dimenshions: width - %i px, height - %i px\n", width, height);

  // wczytanie tablicy pixeli
  fseek(inputFile, pixelDataOffset, SEEK_SET);
  fread(image, sizeof(uint8_t), img_size, inputFile);

  fadetop(image, width, height, dist);

  FILE* outputFile = fopen("output.bmp", "wb");

  // przepisanie nagłówka z dostarczonego pliku
  rewind(inputFile);
  uint8_t* buffer = malloc(54);
  fread(buffer, sizeof(uint8_t), 54, inputFile);
  fwrite(buffer, sizeof(uint8_t), 54, outputFile);
  free(buffer);

  // wpisanie zmodyfikowanej tablicy pikseli
  fseek(outputFile, pixelDataOffset, SEEK_SET);
  fwrite(image, sizeof(uint8_t), img_size, outputFile);

  fclose(inputFile);
  fclose(outputFile);
  free(image);

  printf("Picture modified!\n");
  return 0;
}