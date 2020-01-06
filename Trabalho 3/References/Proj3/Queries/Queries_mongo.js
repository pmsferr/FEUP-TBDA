//a)
//Calculate the total number of students enrolled 
//in each program, in each year, after 1991.
db.alus.aggregate([
	{ $match : { a_lect_matricula : {$gt: 1991}}},
	{ $group : {_id : {curso: "$curso", ano: "$a_lect_matricula"}, num : {$sum : 1}}},
	{ $sort: { "_id.ano": 1 } }
])

//b)
//Obtain the BI and the student number of the 
//students with a final grade (med_final) higher 
//than the application grade (media).
db.alus.aggregate( [
    { $project: { 
        bi: 1, 
        numero: 1,
        med_final: 1,
        med_cand: 1,
        eq: { $cond: [ { $and : [
                            {$ne : [ "$med_cand" , null ]},   
                            {$ne : [ "$med_final" , null ]},
                            {$gt : [ "$med_final", "$med_cand" ]}
                        ]}, 1, 0 ] } 
    } },
    { $match: { eq: 1 } }
] )

//c)
//Find the average of the final grades of all the 
//students finishing their program in a certain 
//number of years, 5 years, 6 years, 
db.alus.aggregate([
    { $match: { a_lect_conclusao: { $ne: 'null' } }},
    { $project: {
        "time": { $subtract: [ "$a_lect_conclusao", "$a_lect_matricula" ] },
        "med_final" : "$med_final"
    }},
   	{ $match: { "time": { $gt: 4 } }},
    { $group : {_id : {diff : "$time"}, avg : { $avg : "$med_final"} }},
    { $sort :{ "_id.diff": 1 } }
])
