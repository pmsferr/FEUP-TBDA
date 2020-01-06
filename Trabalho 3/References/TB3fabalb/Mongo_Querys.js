
// a)
db.ocorrencias.aggregate([
	{ $match: {"uc.curso":233 , "ano_lectivo":"2004/2005"}},
	{ "$unwind": "$docentes"},
	{ "$unwind": "$docentes.aulas"},
	{ $project: { _id: { ocorrencia: "$codigo", tipo: "$docentes.aulas.tipo", turnos: "$docentes.aulas.turnos", n_aulas: "$docentes.aulas.n_aulas", horas_turno: "$docentes.aulas.horas_turno" }}},
	{ $group: { _id: "$_id", total: { $first: { $multiply: ["$_id.n_aulas", "$_id.horas_turno"]} }}},
	{ $group: { _id: "$_id.tipo", total: { $sum: "$total" }}},
]);


// b)
db.ocorrencias.aggregate([
    { $match: { "ano_lectivo":"2003/2004" }},
    { $unwind: "$docentes" },
    { $unwind: "$docentes.aulas" },
    { $project: { _id: { codigo: "$codigo", periodo: "$periodo" }, aulas: "$docentes.aulas" }},
    { $group: { _id: { codigo: "$_id", t_aula: "$aulas.tipo" }, sum_dsd: { $sum: "$aulas.dsd.horas" }, sum_horas: { $max: { $multiply: ["$aulas.horas_turno", "$aulas.turnos"] }}}},
    { $group: { _id: "$_id.codigo", atribuidas: { $sum: "$sum_dsd" }, necessarias: { $sum: "$sum_horas" }}},
    { $project: { _id: "$_id", atribuidas: "$atribuidas", necessarias: "$necessarias", diferente: { $cmp: ["$necessarias", "$atribuidas"] }}},
    { $match: { diferente: { $ne : 0 } }},
    { $project: { _id: "$_id", atribuidas: "$atribuidas", necessarias: "$necessarias" }},
    { $sort: { "_id" : 1 } }
]);


// c)
db.ocorrencias.aggregate([
	{ $match: {"ano_lectivo":"2003/2004"}},
	{ "$unwind": "$docentes"},
	{ "$unwind": "$docentes.aulas"},
	{ "$unwind": "$docentes.aulas.dsd"},
	{ $group: {_id: {Tipo_Aula: "$docentes.aulas.tipo", prof_Nome: "$docentes.nome"} , soma_Aulas_Tipo: {$sum:"$docentes.aulas.dsd.horas"} } },
	{ $sort: {"soma_Aulas_Tipo": -1}},
	{ $group: {_id: "$_id.Tipo_Aula", prof_Nome:{$first:"$_id.prof_Nome"}, soma_Aulas_Tipo:{$first:"$soma_Aulas_Tipo"}}}
])

// d)
db.ocorrencias.aggregate([
	{ $match: {"ano_lectivo": { $in : ["2001/2002", "2002/2003", "2003/2004", "2004/2005"]}}},
	{ "$unwind": "$docentes"},
	{ "$unwind": "$docentes.aulas"},
	{ "$unwind": "$docentes.aulas.dsd"},
	{ $group: { _id: { ano: "$ano_lectivo", docente: "$docentes.nome", categoria: "$docentes.categoria" }, horas: { $avg: "$docentes.aulas.dsd.horas" }}},
	{ $group: { _id: { ano: "$_id.ano", categoria: "$_id.categoria" }, professores: { $push: { nome: "$_id.docente", horas: "$horas" }}}},
	{ $sort: { "_id.ano" : -1 , "_id.categoria": -1}}
]);

// e)
db.ocorrencias.aggregate([
    { $unwind: "$docentes" },
    { $unwind: "$docentes.aulas" }, 
    { $project: { _id: { codigo: "$codigo", periodo: "$periodo", curso: "$uc.curso" , ano: "$ano_lectivo" }, aulas: "$docentes.aulas" }},
    { $group: { _id: { codigo: "$_id", t_aula: "$aulas.tipo" }, horas: { $sum: "$aulas.horas_turno" } }},
    { $group: { _id: "$_id.codigo" , horas: { $sum: "$horas" } }},
    { $group: { _id: { curso: "$_id.curso", periodo: "$_id.periodo", ano: "$_id.ano" } , horas: { $sum: "$horas" } }},
    { $sort: {"_id.curso": 1, "_id.periodo": 1, "_id.ano": 1}},
	// Está a separar por anos lectivos/curso/semestre, curriculares não há nada que permita (?)
	// Teria que adicionar essa separação algures, mas acho que não há
]);

// f) para cada uc, qual o ano com mais alunos inscritos! Mostrar a UC, ano e nr de inscritos, ordernado por UC.
db.ocorrencias.aggregate([
	{ $group: {_id: {UC:"$uc.sigla", Ano:"$ano_lectivo", Inscritos:"$inscritos"}} },
	{ $match: { "_id.Inscritos":{$gt:1}, "_id.UC":{$exists:1} }},
	{ $sort: {"_id.Inscritos": -1}},
	{ $group: {_id: "$_id.UC", Inscritos:{$max:"$_id.Inscritos"}, Ano:{$first:"$_id.Ano"}}},
	{ $sort: {"_id": 1}},
])