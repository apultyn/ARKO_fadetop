# Algorytm do fadetop

* pętla po rzędach
    * sprawdzenie, czy obecny rząd jest mniejszy od wysokość - dist
        * jeśli jest, to przeskakujemy do kolejnego rzędu
    * tutaj zaczynamy rozjaśnianie
    * znajdujemy procent odległości od góry: obecny rząd / 100
    * znajdujemy wartość skalującą dla rzędu: procent * 255 / 100
    * pętla po pikselach:
        * mnożymy wartość piksela przez wartość skalującą
        * dzielimy przez 256
