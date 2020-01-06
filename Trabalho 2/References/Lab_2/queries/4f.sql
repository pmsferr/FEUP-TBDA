--------------------------------------------------------
-------------- GET_PARTIDO_PLENO_DISTRTITO -------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_partido_pleno_distrtito
IS
    sigla partidos.sigla%TYPE;
    pleno BOOLEAN := TRUE;
BEGIN
    FOR P IN (SELECT sigla, mandatos_distrito FROM partidos)
    LOOP

        FOR I IN 1..P.mandatos_distrito.COUNT
        LOOP
            IF (P.mandatos_distrito(I) IS NULL OR P.mandatos_distrito(I) = 0)
            THEN
                pleno := FALSE;
                EXIT;
            END IF;
        END LOOP;    

        IF(pleno = TRUE)
        THEN
            dbms_output.put_line('O ' || P.sigla || ' elegeu deputados em todos os distritos');
        END IF;

        pleno := TRUE;

    END LOOP;
END;