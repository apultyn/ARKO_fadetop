# Algorytm do fadetop

* pętla po rzędach
    * sprawdzenie, czy obecny rząd jest mniejszy od wysokość - dist
        * jeśli jest, to przeskakujemy do kolejnego rzędu
    * tutaj zaczynamy rozjaśnianie
    * znajdujemy procent odległości od góry: obecny rząd - wysokość + dist / dist
    * pętla po każdym kolorze pixela:
        * liczymy różnicę wartości koloru od maksymalnej (255)
        * mnożymy razy procent odległości od góry
        * dodajemy do wartości koloru

* druga wersja (iteracja od dołu bitmapy, czyli od góry obrazu)
    * sprawdzenie, czy dist nie jest 0 lub mniejsze od niego
        * jak jest to kończymy funckję
    * znajdujemy procent odległości od góry na danym rzędzie: (obecny rząd - wysokość obrazu + dist) / dist
    * pętla po każdym kolorze pixela (zaczynając od szerokość * 3, kończąc na 1):
        * liczymy różnicę wartości koloru od maksymalnej (255)
        * mnożymy razy procent odległości od góry
        * dodajemy do wartości koloru
    * dekrementujemy numer rzędu
    * sprawdzamy czy nie jest 0, lub czy nie jest mniejszy od wysokość - dist
        * jak tak, to kończymy