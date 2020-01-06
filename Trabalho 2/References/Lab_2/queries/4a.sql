--------------------------------------------------------
-------------- GET_TOTAL_MANDATOS_PARTIDOS -------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE GET_TOTAL_MANDATOS_PARTIDOS
IS
    rowpartido partidos%ROWTYPE;
    CURSOR c1 IS SELECT value(p) FROM partidos p;
BEGIN
    OPEN c1;

    LOOP
        FETCH c1 INTO rowpartido;
        EXIT WHEN c1%NOTFOUND;

            dbms_output.put_line(rowpartido.get_sigla() || ': ' || rowpartido.get_total_mandatos());
    END LOOP;

    CLOSE c1;
END;