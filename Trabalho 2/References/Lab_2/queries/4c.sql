--------------------------------------------------------
------------- GET_PARTIDO_VENCEDOR_CONCELHO ------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE GET_PARTIDO_VENCEDOR_CONCELHO
IS
    sigla partidos.sigla%TYPE;
BEGIN
    FOR C IN (SELECT nome, codigo FROM concelhos)
    LOOP
        
        SELECT x.partido.sigla INTO sigla
        FROM freguesias F, TABLE(F.votacoes) x
        WHERE F.concelho.codigo = C.codigo
        GROUP BY x.partido.sigla
        ORDER BY SUM(x.votos) DESC
        FETCH FIRST ROW ONLY;

        dbms_output.put_line(C.nome||': '|| sigla);
        
    END LOOP;
END;