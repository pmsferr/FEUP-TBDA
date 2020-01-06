-- Original Relational Data

-- Wipe Existing Tables
drop table rl_activities cascade constraints;
drop table rl_uses cascade constraints;
drop table rl_facilities cascade constraints;
drop table rl_roomtypes cascade constraints;
drop table rl_districts cascade constraints;
drop table rl_municipalities cascade constraints;
drop table rl_regions cascade constraints;

-- Clone Relational Table Structure + Data
create table rl_activities  as (select * from gtd8.activities);
create table rl_uses  as (select * from gtd8.uses);
create table rl_facilities  as (select * from gtd8.facilities);
create table rl_roomtypes  as (select * from gtd8.roomtypes);
create table rl_districts  as (select * from gtd8.districts);
create table rl_municipalities  as (select * from gtd8.municipalities);
create table rl_regions  as (select * from gtd8.regions);

-- Install Constraints
alter table rl_activities add constraint pk_rl_activities primary key(ref);
alter table rl_uses add constraint pk_rl_uses primary key(id, ref);
alter table rl_facilities add constraint pk_rl_facilities primary key(id);
alter table rl_roomtypes add constraint pk_rl_roomtypes primary key(roomtype);
alter table rl_municipalities add constraint pk_rl_municipalities primary key(cod);
alter table rl_districts add constraint pk_rl_districts primary key(cod);
alter table rl_regions add constraint pk_rl_regions primary key(cod);

alter table rl_uses add constraint fk_rl_uses_activities foreign key(ref) references rl_activities(ref);
alter table rl_uses add constraint fk_rl_uses_facilities foreign key(id) references rl_facilities(id);
alter table rl_facilities add constraint fk_rl_facilities_roomt foreign key(roomtype) references rl_roomtypes(roomtype);
alter table rl_facilities add constraint fk_rl_facilities_munip foreign key(municipality) references rl_municipalities(cod);
alter table rl_municipalities add constraint fk_rl_municipalities_dist foreign key(district) references rl_districts(cod);
alter table rl_municipalities add constraint fk_rl_municipalities_reg foreign key(region) references rl_regions(cod);
alter table rl_districts add constraint fk_rl_districts_reg foreign key(region) references rl_regions(cod);