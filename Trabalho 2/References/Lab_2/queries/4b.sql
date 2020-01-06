--------------------------------------------------------
------------- GET_TOTAL_VOTOS_PARTIDOS_DISTR -----------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE GET_TOTAL_VOTOS_PARTIDOS_DISTR
IS
    distrito VARCHAR2(50) := '';
    cod SIMPLE_INTEGER := 1;
BEGIN
    FOR I IN 1..20
    LOOP
        IF(I = 19)
        THEN
            cod := 30;
        ELSIF(I = 20)
        THEN
            cod := 40;
        END IF;
        
        SELECT nome INTO distrito
        FROM distritos
        WHERE codigo = cod;
        
        cod := cod + 1;

        dbms_output.put_line('Distrito: ' || distrito);

        FOR P IN (SELECT * FROM partidos)
        LOOP
            IF NOT(P.votos_distrito(I) IS NULL)
            THEN
                dbms_output.put_line('--'||P.sigla||': '|| P.votos_distrito(I));
            END IF;
        END LOOP;
    END LOOP;
END;