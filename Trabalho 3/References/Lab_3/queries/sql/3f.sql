SELECT m.designation, f.name, f.capacity, r.description as roomtype, f.address
FROM facilities f
JOIN municipalities m
ON f.municipality = m.cod
JOIN uses u
ON f.id = u.id
JOIN activities a
ON u.ref = a.ref
JOIN regions reg
ON m.region = reg.cod
JOIN roomtypes r
ON r.roomtype = f.roomtype
WHERE reg.designation = 'Algarve' AND a.activity = 'cinema'
ORDER BY m.designation, f.name;