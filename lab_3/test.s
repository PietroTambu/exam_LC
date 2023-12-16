BEGIN
  read R1;
  read R2;

  R2 R1 dual R1 + R2;

  if R2 = R1 then
    write R2;
  fi;
END