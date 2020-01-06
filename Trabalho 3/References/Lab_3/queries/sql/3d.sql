SELECT activity, municipality, num_facilities
FROM
    (SELECT a.activity as activity, m.designation as municipality, count(*) as num_facilities, ROW_NUMBER() OVER (PARTITION BY a.activity ORDER BY COUNT(*) DESC) as seqnum
    FROM facilities f
    JOIN municipalities m
    ON f.municipality = m.cod
    JOIN uses u
    ON f.id = u.id
    JOIN activities a
    ON u.ref = a.ref
    GROUP BY a.activity, m.designation
    )
WHERE seqnum = 1;