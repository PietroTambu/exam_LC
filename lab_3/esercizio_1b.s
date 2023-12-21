BEGIN
  read R1;
  R2 := 0;
  R3 := 0;

  while R2 < R1 do
    write R3;
    R3 := R3 + 2;
    R2 := R2 + 1;
  done;
END
