--------------------------------------------------------
----------------   PL/SQL FUNCTIONS   ------------------   
--------------------------------------------------------

--------------------------------------------------------
---------------- FILL_PARTIDO_MANDATOS -----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE fill_partido_mandatos
IS
    mandatosarray  partido_mandatos := partido_mandatos(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    distritoposarray SIMPLE_INTEGER := 1;
    mandatos VARCHAR2(3) := '';
BEGIN

    FOR P IN (SELECT sigla FROM partidos)
    LOOP
        FOR D IN (SELECT D.codigo, L.mandatos FROM distritos D, TABLE(D.listas) L WHERE L.partido.sigla = P.sigla)
        LOOP
        
            IF(D.codigo <= 18)
            THEN
                distritoposarray := D.codigo;
            ELSIF(D.codigo = 30)
            THEN
                distritoposarray := 19;
            ELSE
                distritoposarray := 20;
            END IF;
            
            mandatosarray(distritoposarray) := D.mandatos;
        
        END LOOP;
        
        UPDATE partidos
        SET mandatos_distrito = mandatosarray
        WHERE partidos.sigla = P.sigla;
        
        mandatosarray := partido_mandatos(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        distritoposarray := 1;
    
    END LOOP;
END;

--------------------------------------------------------
----------------- FILL_PARTIDO_VOTOS -------------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE fill_partido_votos
IS
    votosarray  partido_votos := partido_votos(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    distritoposarray SIMPLE_INTEGER := 1;
    votos VARCHAR2(10) := '';
BEGIN

    FOR P IN (SELECT sigla FROM partidos)
    LOOP
        FOR D IN (SELECT codigo FROM distritos)
        LOOP
        
            BEGIN
                SELECT SUM(x.votos) INTO votos
                FROM freguesias F, TABLE(F.votacoes) x
                WHERE x.partido.sigla = P.sigla AND F.concelho.codigo IN
                (SELECT codigo
                FROM concelhos C
                WHERE C.distrito.codigo = D.codigo)
                GROUP BY x.partido.sigla;
                EXCEPTION
                  WHEN no_data_found THEN
                    votos := NULL;
            END;
            
            IF(D.codigo <= 18)
            THEN
                distritoposarray := D.codigo;
            ELSIF(D.codigo = 30)
            THEN
                distritoposarray := 19;
            ELSE
                distritoposarray := 20;
            END IF;
            
            IF NOT (votos IS NULL)
            THEN
                votosarray(distritoposarray) := to_number(votos);
            END IF;
        
        END LOOP;
        
        UPDATE partidos
        SET votos_distrito = votosarray
        WHERE partidos.sigla = P.sigla;
        
        votosarray := partido_votos(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        distritoposarray := 1;
    
    END LOOP;
END;

--------------------------------------------------------
/*                 STATISTICS FUNCTIONS               */   
--------------------------------------------------------
--------------------------------------------------------
--------------- GET_PARTIDO_MAIS_VOTADO ----------------   
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_PARTIDO_MAIS_VOTADO(codigoDistrito distritos.codigo%TYPE)
RETURN partidos.sigla%TYPE
IS
    Sigla partidos.sigla%TYPE;
BEGIN
    
    SELECT x.partido.sigla INTO Sigla
    FROM freguesias F, TABLE(F.votacoes) x
    WHERE F.concelho.codigo IN
        (SELECT codigo
        FROM concelhos C
        WHERE C.distrito.codigo = codigoDistrito)
    GROUP BY x.partido.sigla
    ORDER BY SUM(x.votos) DESC
    FETCH FIRST ROW ONLY;
    
RETURN Sigla;

END;

--------------------------------------------------------
---------------- GET_DISTRITOS_VENCEDOR ----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_distritos_vencedor(siglapartido partidos.sigla%TYPE)
IS
    sigla partidos.sigla%TYPE := '';
    ret_distritos VARCHAR2(1000) := '';
BEGIN
    FOR D IN (SELECT codigo, nome FROM distritos)
    LOOP
        sigla := get_partido_mais_votado(D.codigo);
    
        IF sigla = siglapartido
        THEN
            ret_distritos := ret_distritos || D.nome || CHR(10);
        END IF;
    
    END LOOP; 
    
    dbms_output.put_line(ret_distritos);
END;

--------------------------------------------------------
---------------- GET_DISTRITOS_MAIORIA -----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_distritos_maioria(siglapartido partidos.sigla%TYPE)
IS
    sigla partidos.sigla%TYPE := '';
    ret_distritos VARCHAR2(1000) := '';
    mandatos_proprio simple_integer := 0;
    mandatos_outros simple_integer := 0;
BEGIN
    FOR D IN (SELECT codigo, nome FROM distritos)
    LOOP

        SELECT L.mandatos INTO mandatos_proprio
        FROM distritos dist, TABLE(dist.listas) L
        WHERE dist.codigo = D.codigo AND L.partido.sigla = siglapartido;
        
        SELECT SUM(L.mandatos) INTO mandatos_outros
        FROM distritos dist, TABLE(dist.listas) L
        WHERE dist.codigo = D.codigo AND L.partido.sigla <> siglapartido;
        
        IF mandatos_proprio > mandatos_outros
        THEN
            ret_distritos := ret_distritos || D.nome || CHR(10);
        END IF;

    END LOOP; 
    
    dbms_output.put_line(ret_distritos);
END;

--------------------------------------------------------
--------------- GET_PARTIDO_MAIS_VOTADO ----------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_partido_mais_votado_distr(nomedistrito distritos.nome%TYPE)
IS
    sigla partidos.sigla%TYPE;
BEGIN

    SELECT x.partido.sigla INTO sigla
    FROM freguesias F, TABLE(F.votacoes) x
    WHERE F.concelho.codigo IN
        (SELECT codigo
        FROM concelhos C
        WHERE C.distrito.nome = nomedistrito)
    GROUP BY x.partido.sigla
    ORDER BY SUM(x.votos) DESC  
    FETCH FIRST ROW ONLY;

    dbms_output.put_line(sigla);

END;

--------------------------------------------------------
----------------- GET_PARTIDO_MAIORIA ------------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_partido_maioria_distr(nomedistrito distritos.nome%TYPE)
IS
    nome distritos.nome%TYPE := '';
    nomePartido VARCHAR2(10) := '';
    mandatos_max SIMPLE_INTEGER := 0;
    mandatos_outros SIMPLE_INTEGER := 0;
BEGIN

    SELECT L.partido.sigla, L.mandatos
    INTO nomePartido, mandatos_max
    FROM distritos dist, TABLE(dist.listas) L
    WHERE dist.nome = nomedistrito
    ORDER BY L.mandatos DESC
    FETCH FIRST ROW ONLY;

    SELECT SUM(L.mandatos) INTO mandatos_outros
    FROM distritos dist, TABLE(dist.listas) L
    WHERE dist.nome = nomedistrito AND L.partido.sigla <> nomePartido;

    IF mandatos_max > mandatos_outros
    THEN
        dbms_output.put_line(nomePartido);
    ELSE
        dbms_output.put_line('Nenhum partido obteve maioria absoluta no distrito de ' || nomedistrito);
    END IF;

END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_INSCRITOS ------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_INSCRITOS
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN

    SELECT D.nome INTO Nome
    FROM distritos D
    ORDER BY D.participacoes.inscritos DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_VOTANTES -------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_VOTANTES
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN
    
    SELECT D.nome INTO Nome
    FROM distritos D
    ORDER BY D.participacoes.votantes DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
------------- GET_DISTRITO_MAIS_ABSTENCOES -------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_ABSTENCOES
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN

    SELECT D.nome INTO Nome
    FROM distritos D
    ORDER BY D.participacoes.abstencoes DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_BRANCOS --------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_BRANCOS
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN

    SELECT D.nome INTO Nome
    FROM distritos D
    ORDER BY D.participacoes.brancos DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
---------------- GET_DISTRITO_MAIS_NULOS ---------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_NULOS
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN

    SELECT D.nome INTO Nome
    FROM distritos D
    ORDER BY D.participacoes.nulos DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
----- GET_DISTRITO_MAIOR_RACIO_VOTANTES_INSCRITOS ------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTR_MAIOR_RACIO_VOT_INSC
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN
    
    SELECT D.nome INTO NOME
    FROM distritos D
    ORDER BY D.participacoes.votantes/D.participacoes.inscritos DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
---- GET_DISTRITO_MAIOR_RACIO_ABSTENCOES_INSCRITOS -----
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTR_MAIOR_RACIO_ABS_INSC
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN
    
    SELECT D.nome INTO NOME
    FROM distritos D
    ORDER BY D.participacoes.abstencoes/D.participacoes.inscritos DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
------ GET_DISTRITO_MAIOR_RACIO_BRANCOS_VOTANTES -------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTR_MAIOR_RACIO_BRNC_VOT
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN
    
    SELECT D.nome INTO NOME
    FROM distritos D
    ORDER BY D.participacoes.brancos/D.participacoes.votantes DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;

--------------------------------------------------------
------- GET_DISTRITO_MAIOR_RACIO_NULOS_VOTANTES --------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTR_MAIOR_RACIO_NUL_VOT
RETURN distritos.nome%TYPE
IS
    Nome distritos.nome%TYPE;
BEGIN
    
    SELECT D.nome INTO NOME
    FROM distritos D
    ORDER BY D.participacoes.nulos/D.participacoes.votantes DESC
    FETCH FIRST ROW ONLY;

RETURN Nome;

END;