-- Unable to render TABLE DDL for object GTD8.TIPOS with DBMS_METADATA attempting internal generator.
CREATE TABLE GTD8.TIPOS 
(
  TIPO NUMBER(4, 0) 
, DESCRICAO VARCHAR2(50 BYTE) 
) 
LOGGING 
TABLESPACE USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOCOMPRESS 
NOPARALLEL
