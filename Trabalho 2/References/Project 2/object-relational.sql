-- Object Relational Rework
-- Note: OR Statements must be closed with a "/" due to the possible existance of multiple ";"

-- Wipe Existing Data
drop table facilities;
/
drop table activities;
/
drop type activity_tab FORCE;
/
drop type facility_tab FORCE;
/
drop type activity_t;
/
drop type facility_t;
/
drop table municipalities;
/
drop type municipality_t;
/
drop table districts;
/
drop type district_t;
/
drop table regions;
/
drop type region_t;
/
drop table roomtypes;
/
drop type roomtype_t;
/

-- 1) Define Data Models and Import Data
-- Types
create type roomtype_t as object(
    roomtype number(4, 0),
    description varchar2(50)
);    
/
create type region_t as object(
    cod number(4, 0),
    designation varchar2(50),
    nut1 varchar2(50)
);
/
create type district_t as object(
    cod number(4, 0),
    designation varchar2(50),
    region ref region_t
);
/
create type municipality_t as object(
    cod number(4, 0),
    designation varchar2(50),
    district ref district_t,
    region ref region_t
);
/
create type activity_t as object(
    ref varchar2(20),
    activity varchar2(20)
);
/
create type activity_tab as table of ref activity_t;
/
create type facility_t as object(
    id number(4, 0),
    name varchar2(80),
    capacity number(8, 0),
    address varchar2(80),
    roomtype ref roomtype_t,
    municipality ref municipality_t,
    activities activity_tab
);
/
create type facility_tab as table of ref facility_t;
/
alter type activity_t add attribute facilities facility_tab cascade;
/

-- Tables
create table roomtypes of roomtype_t(
    primary key(roomtype)
);
/
create table regions of region_t(
    primary key(cod)
);
/
create table districts of district_t(
    primary key(cod)
);
/
create table municipalities of municipality_t(
    primary key(cod)
);
/
create table activities of activity_t(
    primary key(ref)
) nested table facilities store as facilities_nt;
/
create table facilities of facility_t(
    primary key(id)
) nested table activities store as activities_nt;
/

-- 2) Inserts
insert into roomtypes select roomtype_t(roomtype, description) from rl_roomtypes;
/
insert into regions select region_t(cod, designation, nut1) from rl_regions;
/
insert into districts
with aux1 as (
    select rl_districts.cod, rl_districts.designation, ref(r) as region
    from rl_districts
    left outer join regions r
    on rl_districts.region = r.cod
)
select district_t(cod, designation, region) from aux1;
/
insert into municipalities
with aux1 as (
    select rl_municipalities.cod, rl_municipalities.designation,
    ref(d) as district, rl_municipalities.region
    from rl_municipalities
    left outer join districts d
    on rl_municipalities.district = d.cod
), aux2 as (
    select aux1.cod, aux1.designation, aux1.district, ref(r) as region
    from aux1
    left outer join regions r
    on aux1.region = r.cod
) 
select municipality_t(cod, designation, district, region) from aux2;
/
insert into activities select activity_t(ref, activity, facility_tab()) from rl_activities;
/
insert into facilities
with aux1 as (
    select rl_facilities.id, rl_facilities.name, rl_facilities.capacity, rl_facilities.address,
    ref(rt) as roomtype, rl_facilities.municipality 
    from rl_facilities
    left outer join roomtypes rt
    on rl_facilities.roomtype = rt.roomtype
), aux2 as (
    select id, name, capacity, address, roomtype, ref(m) as municipality
    from aux1
    left outer join municipalities m
    on aux1.municipality = m.cod
) 
select facility_t(id, name, capacity, address, roomtype, municipality, activity_tab()) from aux2;
/
begin
    for u in (select id, ref from rl_uses)
    loop
        insert into table(select f.activities from facilities f where u.id = f.id)
        select ref(a) from activities a where u.ref = a.ref;
        insert into table(Select a.facilities from activities a where u.ref = a.ref)
        select ref(f) from facilities f where u.id = f.id;
    end loop;
end;
/