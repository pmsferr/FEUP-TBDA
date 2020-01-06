--------------------------------------------------------
---------------- CHECK_NUMERO_VOTANTES -----------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE check_numero_votantes
IS
    numvotos NUMBER(10);
    numinscritos distritos.participacoes.inscritos%TYPE;
    numabsbrancosnulos distritos.participacoes.inscritos%TYPE;
BEGIN
    FOR D IN (SELECT codigo, nome FROM distritos)
    LOOP

        SELECT SUM(x.votos) INTO numvotos
        FROM freguesias F, TABLE(F.votacoes) x
        WHERE F.concelho.codigo IN
        (SELECT codigo
        FROM concelhos C
        WHERE C.distrito.codigo = D.codigo);

        SELECT dist.participacoes.inscritos, (dist.participacoes.abstencoes + dist.participacoes.brancos + dist.participacoes.nulos)
        INTO numinscritos, numabsbrancosnulos
        FROM distritos dist
        WHERE dist.codigo = D.codigo;

        IF NOT(numvotos + numabsbrancosnulos = numinscritos)
        THEN
            dbms_output.put_line('No distrito de ' || D.nome || chr(10) || ' não se verifica a restrição de o número de inscritos ser igual ao número de votantes mais o número de abstenções mais o número de votos brancos e nulos');
        END IF;

    END LOOP;
END;