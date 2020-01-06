SELECT f.id, f.name, r.description, a.activity
FROM facilities f
JOIN roomtypes r
ON f.roomtype = r.roomtype
JOIN uses u
ON f.id = u.id
JOIN activities a
ON a.ref = u.ref
WHERE r.description LIKE '%touros%' AND activity = 'teatro';