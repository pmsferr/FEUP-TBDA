create table lics as (select * from GTD2.lics);
create table cands as (select * from GTD2.cands);
create table alus as (select * from GTD2.alus);
create table anos as (select * from GTD2.anos);

-- a)
--Calculate the total number of students enrolled 
--in each program, in each year, after 1991.
select a.A_LECT_MATRICULA year, l.nome, count(*) as numAlus 
from alus a, lics l
where a.curso = l.codigo
and a.A_LECT_MATRICULA > 1991
group by l.nome, a.a_lect_matricula
order by year;

-- b)
--Obtain the BI and the student number of the 
--students with a final grade (med_final) higher 
--than the application grade (media).
select a.bi, a.numero
from alus a, cands c
where a.bi = c.bi
and a.med_final > c.media;

-- c)
--Find the average of the final grades of all the 
--students finishing their program in a certain 
--number of years, 5 years, 6 years, 

select (a_lect_conclusao - a_lect_matricula) as diff, avg(med_final)
from alus
where (a_lect_conclusao - a_lect_matricula) > 4
group by (a_lect_conclusao - a_lect_matricula)
order by (a_lect_conclusao - a_lect_matricula);
