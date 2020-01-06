--------------------------------------------------------
----------- GET_TOTAL_MANDATOS_VOTOS_PARTIDOS ----------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE GET_TOTAL_MANDATOS_VOTOS_PARTS
IS
    rowpartido partidos%ROWTYPE;
    CURSOR c1 IS SELECT value(p) FROM partidos p;
    votos number (5,2) := 0;
    mandatos number (5,2) := 0;
    totalVotos number(7) := 0;
    totalMandatos number(3) := 0;
BEGIN
    OPEN c1;
    
    LOOP
        FETCH c1 INTO rowpartido;
        EXIT WHEN c1%NOTFOUND;
            totalVotos := totalVotos + rowpartido.get_total_votos();
            totalMandatos := totalMandatos + rowpartido.get_total_mandatos();
    END LOOP;
    
    CLOSE c1;

    OPEN c1;
    
    LOOP
        FETCH c1 INTO rowpartido;
        EXIT WHEN c1%NOTFOUND;

        votos := rowpartido.get_total_votos()/totalVotos*100; 
        mandatos := rowpartido.get_total_mandatos()/totalMandatos*100;
        dbms_output.put_line(rowpartido.get_sigla() || chr(10) || 'Percentagem votos: ' || TO_CHAR(votos,'90D00') || '%' || chr(10) || 'Percentagem mandatos: ' || TO_CHAR(mandatos,'90D00') || '%' || chr(10) || '----------------------------');
    END LOOP;
    
    CLOSE c1;

END;