BEGIN
  read R1; // Legge il valore di N
  R2 := 0; // R2 tiene traccia del numero di numeri pari stampati
  R3 := 0; // R3 è il numero pari corrente da stampare

  while R2 < R1 do
    write R3;
    R3 := R3 + 2; // Incrementa R3 di 2 per passare al prossimo numero pari
    R2 := R2 + 1; // Incrementa R2 per tenere traccia del numero di numeri pari stampati
  done;
END
