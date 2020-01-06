create or replace PACKAGE BODY WEB_XML AS
PROCEDURE list_facilities IS 
    v_sqlselect varchar2(6000);
    v_queryctx DBMS_XMLQuery.ctxType;
    v_clob_par clob;
    v_offset number default 1;
    v_chunk_size number := 10000;
BEGIN 
    v_sqlselect := 
    'SELECT d.cod, d.designation, reg.designation as region, reg.nut1, 
        CURSOR(
           SELECT m.cod, m.designation, r.designation as region, r.nut1, 
            CURSOR(
                SELECT a.activity, 
                CURSOR(
                    SELECT f1.name, f1.capacity, rt.description as roomtype, f1.address
                    FROM facilities f1
                    JOIN uses u1
                    ON f1.id = u1.id
                    JOIN roomtypes rt
                    ON rt.roomtype = f1.roomtype
                    WHERE a.ref = u1.ref and f1.municipality = m.cod
                    ORDER BY f1.name
                ) as facilities
                FROM activities a
                JOIN uses u
                ON u.ref = a.ref
                JOIN facilities f
                ON f.id = u.id 
                WHERE f.municipality = m.cod
                AND u.id IN (SELECT min(u2.id) 
                            FROM activities a2 
                            JOIN uses u2 
                            ON u2.ref = a2.ref 
                            JOIN facilities f2 ON f2.id = u2.id 
                            WHERE f2.municipality = m.cod AND a2.activity=a.activity)
                ORDER BY a.activity
                ) as activities
            FROM municipalities m
            JOIN regions r
            ON r.cod = m.region
            WHERE m.district = d.cod
            ) as municipalities
    FROM districts d
    LEFT JOIN regions reg
    ON reg.cod = d.region
    ORDER BY d.cod';

    v_queryctx := DBMS_XMLQuery.newContext(v_sqlselect);

    DBMS_XMLQuery.setEncodingTag(v_queryctx, 'ISO-8859-1');
    
    DBMS_XMLQuery.setRowSetTag(v_queryctx, UPPER('FACILITIES'));

    DBMS_XMLQuery.setRowTag(v_queryctx, UPPER('DISTRICT')); 

    v_clob_par := DBMS_XMLQuery.getXML(v_queryctx); 

    DBMS_XMLQuery.closeContext(v_queryctx); 
    
    loop
   
      exit when v_offset > dbms_lob.getlength(v_clob_par);
      
      htp.p( dbms_lob.substr( v_clob_par, v_chunk_size, v_offset ) );
      
      htp.para;
      
      v_offset := v_offset +  v_chunk_size;
   
    end loop;
            
    EXCEPTION
        WHEN OTHERS THEN
            htp.p(SQLERRM); 
            
END list_facilities;
END WEB_XML;