SELECT reg.designation, COUNT(*) as num_facilities
FROM facilities f
JOIN roomtypes r
ON f.roomtype = r.roomtype
JOIN municipalities m
ON f.municipality = m.cod
JOIN regions reg
ON m.region = reg.cod
WHERE r.description LIKE '%touros%'
GROUP BY reg.designation
ORDER BY reg.designation;