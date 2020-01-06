SELECT COUNT(*)
FROM
(
    SELECT d.designation, m.designation
    FROM municipalities m 
    JOIN districts d 
    ON d.cod = m.district
    MINUS
        (SELECT distinct d.designation, m.designation
        FROM facilities f
        JOIN municipalities m
        ON f.municipality = m.cod
        JOIN districts d 
        ON d.cod = m.district
        JOIN uses u
        ON f.id = u.id
        JOIN activities a
        ON a.ref = u.ref
        WHERE activity = 'cinema'
        )
);