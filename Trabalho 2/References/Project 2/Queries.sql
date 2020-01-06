--3.1) Devolve a lista de actividades numa string de um recinto.
create or replace function list_activities(facility in facility_t)
return varchar2 as

cursor activity_cursor is (select value(t).activity as activity from table(facility.activities) t);
actList varchar2(200) := '';
fst number := 0;
begin
    for i in activity_cursor
    loop
        if fst = 0 then
            actList := i.activity;
            fst := 1;
        else
            actList := actList || ', ' || i.activity;
        end if;    
    end loop;
    return(actList);
end;
/

--3.2) Verifica se o recinto(facility) tem a capacidade (users) e a actividade (activity) de entrada.
-- Retorna 1 se verifica estas condições, -1 caso contrário
create or replace function supports_activity(facility in facility_t, users in number, activity in activity_t)
return number as
found number := 0;
begin
    select count(*) into found from table(facility.activities) t where value(t).ref = activity.ref;
    if found > 0 and facility.capacity >= users then
        return(1);       
    else
        return(-1);
    end if;    
end;
/

--4.a)
SELECT f.id as id, f.name as name, f.roomtype.description as description, value(act).activity as activity 
FROM facilities f, table(f.activities) act
WHERE value(act).activity = 'teatro' and f.roomtype.description Like '%touros%'
ORDER BY f.id;
/
--4.b)
SELECT f.municipality.region.designation as Region, count(f.id) as Count
FROM facilities f
WHERE f.roomtype.description Like '%touros%'
GROUP by f.municipality.region.designation;
/
--4.c)
SELECT count(*) as "Municipalities without cinema"
FROM municipalities m
WHERE ref(m) NOT IN (SELECT DISTINCT f.municipality
FROM facilities f, table(f.activities) a
WHERE value(a).activity = 'cinema');
/
--4.d)
with a1 as(  
    select f.municipality.designation as municipality, value(a).activity as activity, count(value(f)) as ammount
    from facilities f, table(f.activities) a 
    group by f.municipality, value(a).activity
), a2 as(
    select activity, max(ammount) as ammount from a1 group by activity
) select a1.municipality, a1.activity, a1.ammount
from a1 inner join a2 on a1.ammount = a2.ammount and a1.activity = a2.activity;
/
--4.e)
with a1 as (
    -- Facility -> Municipality, District
    select
        f.id as facility,
        f.municipality as municipality,
        f.municipality.district as district
    from facilities f
), a2 as (
    -- Number of Facilities per Municipality/District
    select 
        count(facility) as facilities, 
        municipality, 
        district 
    from a1
    group by municipality, district
), a3 as ( 
    -- Number of Municipalities with Facilities per District
    select 
        district, 
        count(municipality) as mwfacilities 
    from a2
    group by district
), a4 as ( 
    -- Number of Municipalities per District
    select 
        m.district,
        count(m.cod) as municipalities       
    from municipalities m
    group by m.district
)  
select 
    q.district.cod as code,
    q.district.designation as designation
from a3 q
where exists(select * from a4)
order by code;
/
--4.f)
-- Facilities with 200 or more capacity, that include 'cinema' as an activity
select f.id, f.name, f.capacity, list_activities(value(f)) as activities 
from facilities f
where supports_activity(
    value(f), 
    250, 
    (select value(a) from activities a where a.activity = 'cinema')
) > 0
order by f.id;
/