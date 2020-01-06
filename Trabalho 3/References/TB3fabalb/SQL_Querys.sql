
/*
-- create tables with data from teacher
SELECT * FROM gtd10.xdocentes;
SELECT * FROM gtd10.xdsd;
SELECT * FROM gtd10.xocorrencias;
SELECT * FROM gtd10.xtiposaula;
SELECT * FROM gtd10.xucs;
*/

-- 3.a)
SELECT gtd10.xtiposaula.tipo, sum(gtd10.xtiposaula.n_aulas * gtd10.xtiposaula.horas_turno) as total_horas
FROM gtd10.xtiposaula
JOIN gtd10.xucs on gtd10.xucs.codigo = gtd10.xtiposaula.codigo 
WHERE gtd10.xtiposaula.ano_letivo = '2004/2005' and gtd10.xucs.curso = 233
GROUP BY gtd10.xtiposaula.tipo;

-- 3.b)
with valores as(SELECT gtd10.xocorrencias.codigo, gtd10.xocorrencias.periodo, sum(gtd10.xdsd.horas) as atribuidas, 
sum(gtd10.xtiposaula.turnos * gtd10.xtiposaula.horas_turno) as necessarias
FROM gtd10.xocorrencias
JOIN gtd10.xtiposaula on (gtd10.xtiposaula.ano_letivo = gtd10.xocorrencias.ano_letivo and 
gtd10.xtiposaula.periodo = gtd10.xocorrencias.periodo and
gtd10.xtiposaula.codigo = gtd10.xocorrencias.codigo)
JOIN gtd10.xdsd on gtd10.xdsd.id = gtd10.xtiposaula.id
WHERE gtd10.xocorrencias.ano_letivo = '2003/2004'
GROUP BY gtd10.xocorrencias.codigo, gtd10.xocorrencias.periodo
ORDER BY gtd10.xocorrencias.codigo
), diferentes as(
    SELECT atribuidas, necessarias from valores where atribuidas != necessarias
)
SELECT DISTINCT valores.codigo, valores.periodo, valores.atribuidas, valores.necessarias
FROM valores
INNER JOIN diferentes ON valores.atribuidas = diferentes.atribuidas and valores.necessarias = diferentes.necessarias
ORDER BY valores.codigo;

-- 3.c) 
with soma_horas as(
    SELECT gtd10.xdocentes.nr, gtd10.xdocentes.nome, gtd10.xtiposaula.tipo, sum(gtd10.xdsd.horas)as horas
    FROM gtd10.xdocentes
    JOIN gtd10.xdsd on gtd10.xdsd.nr = gtd10.xdocentes.nr
    JOIN gtd10.xtiposaula on gtd10.xtiposaula.id = gtd10.xdsd.id
    WHERE gtd10.xtiposaula.ano_letivo = '2003/2004'
    GROUP BY gtd10.xtiposaula.tipo, gtd10.xdocentes.nr, gtd10.xdocentes.nome
), media_horas as (
    SELECT tipo, max(horas) as horas from soma_horas group by tipo
)
select soma_horas.nr, soma_horas.nome, soma_horas.tipo, soma_horas.horas
from soma_horas
inner join media_horas on media_horas.tipo = soma_horas.tipo and media_horas.horas = soma_horas.horas;

-- 3.d)
SELECT gtd10.xdocentes.nome, gtd10.xdocentes.categoria, avg(gtd10.xdsd.horas) as horas, gtd10.xtiposaula.ano_letivo
FROM gtd10.xdocentes
JOIN gtd10.xdsd ON gtd10.xdsd.nr = gtd10.xdocentes.nr
JOIN gtd10.xtiposaula ON gtd10.xtiposaula.id = gtd10.xdsd.id
WHERE gtd10.xtiposaula.ano_letivo IN ('2001/2002', '2002/2003', '2003/2004', '2004/2005')
group by gtd10.xdocentes.nome, gtd10.xdocentes.categoria, gtd10.xtiposaula.ano_letivo
ORDER BY gtd10.xtiposaula.ano_letivo desc, gtd10.xdocentes.categoria desc;

-- 3.e)
SELECT gtd10.xucs.curso, gtd10.xtiposaula.periodo, gtd10.xtiposaula.ano_letivo, sum(gtd10.xtiposaula.horas_turno * gtd10.xtiposaula.turnos) as horas
FROM gtd10.xtiposaula
JOIN gtd10.xocorrencias on (gtd10.xtiposaula.ano_letivo = gtd10.xocorrencias.ano_letivo and 
gtd10.xtiposaula.periodo = gtd10.xocorrencias.periodo and
gtd10.xtiposaula.codigo = gtd10.xocorrencias.codigo)
JOIN gtd10.xucs on gtd10.xucs.codigo = gtd10.xocorrencias.codigo
group by gtd10.xucs.curso, gtd10.xtiposaula.periodo, gtd10.xtiposaula.ano_letivo
ORDER BY gtd10.xucs.curso, gtd10.xtiposaula.periodo, gtd10.xtiposaula.ano_letivo;

-- 3.f)
with todos as(
    SELECT gtd10.xucs.sigla_uc, gtd10.xocorrencias.ano_letivo, gtd10.xocorrencias.inscritos
    FROM gtd10.xocorrencias
    JOIN gtd10.xucs on gtd10.xucs.codigo = gtd10.xocorrencias.codigo
    WHERE gtd10.xocorrencias.inscritos > 0
    ORDER BY gtd10.xucs.sigla_uc
), maximo_todos as(
    SELECT sigla_uc, max(inscritos) as inscritos from todos group by sigla_uc
)
select todos.sigla_uc, todos.ano_letivo, todos.inscritos
from todos
inner join maximo_todos on maximo_todos.sigla_uc = todos.sigla_uc and maximo_todos.inscritos = todos.inscritos
ORDER BY todos.sigla_uc;