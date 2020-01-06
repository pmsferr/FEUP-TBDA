--------------------------------------------------------
---------------------   INSERTS   ----------------------   
--------------------------------------------------------
--------------
-- Partidos --   
--------------

INSERT INTO partidos (sigla,designacao) 
SELECT *
FROM gtd7.partidos;

---------------
-- Distritos --   
---------------

INSERT INTO distritos(codigo, nome, regiao, participacoes, listas) 
SELECT d.codigo, d.nome, d.regiao, participacao_t(p.inscritos, p.votantes, p.abstencoes, p.brancos, p.nulos), cast(multiset(SELECT (SELECT REF(part) from partidos part where sigla = l.partido), l.mandatos 
                                                                                                                            FROM gtd7.listas l WHERE l.distrito = d.codigo) as listas_tab_t)
FROM gtd7.distritos d
JOIN gtd7.participacoes p
ON d.codigo = p.distrito;
                                                                                    
---------------
-- Concelhos --   
---------------

INSERT INTO concelhos(codigo,nome,distrito)
SELECT C.codigo, C.nome, (SELECT REF(dist) FROM distritos dist WHERE dist.codigo = C.distrito)
FROM gtd7.concelhos C;

----------------
-- Freguesias --   
----------------

INSERT INTO freguesias(codigo,nome,concelho,votacoes)
SELECT f.codigo, f.nome, (SELECT REF(conc) FROM concelhos conc WHERE conc.codigo = f.concelho), cast(multiset(SELECT (SELECT REF(part) from partidos part where sigla = v.partido), v.votos
                                                                                                                FROM gtd7.votacoes v WHERE v.freguesia = f.codigo) as votacoes_tab_t)
FROM gtd7.freguesias f;