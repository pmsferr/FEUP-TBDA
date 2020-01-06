SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
set verify off
SET ECHO OFF
spool D:\abc.txt
SELECT JSON_OBJECT( 
		  'nr' VALUE d.nr,
		  'nome' VALUE d.nome,
		  'sigla' VALUE d.sigla,
		  'categoria' VALUE d.categoria,
		  'proprio' VALUE d.proprio,
		  'apelido' VALUE d.apelido,
		  'estado' VALUE d.estado,
		  'dsd' VALUE (
		        SELECT JSON_ARRAYAGG(
				JSON_OBJECT(
				'nr' VALUE ds.nr,
				'id' VALUE ds.id,
				'horas' VALUE ds.horas,
				'fator' VALUE ds.fator,
				'ordem' VALUE ds.ordem)  returning clob)
FROM docentes d, dsd ds 
WHERE d.nr = ds.nr ) returning clob)
FROM docentes d;
spool off


