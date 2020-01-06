SELECT cod, designation
FROM districts
MINUS
    (SELECT DISTINCT d.cod, d.designation
    FROM municipalities m
    JOIN districts d
    ON d.cod = m.district
    LEFT JOIN FACILITIES f
    ON F.MUNICIPALITY = M.COD
    WHERE f.id IS NULL
    );