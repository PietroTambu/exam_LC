BEGIN
  read R1;
  read R2;
  read R3;

  if R1 > R2 then
    if R1 > R3 then
      write R1; // R1 è il maggiore

    else
      write R3; // R3 è il maggiore

    fi;

  else
    if R2 > R3 then
      write R2; // R2 è il maggiore

    else
      write R3; // R3 è il maggiore

    fi;

  fi;
END

