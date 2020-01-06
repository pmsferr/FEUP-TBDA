const mongoose = require("mongoose");

function DatabaseParser(host, port, username, password, authDb, database, callback){
    var url = "mongodb://";

    if(
        username == "" || username == null ||
        password == "" || password == null ||
        authDb == "" || authDb == null
    ){
        url += `${host}:${port}/${database}`;
    }else{
        url += `${username}:${password}@${host}:${port}/${database}?authSource=${authDb}`;
    }

    // Mongoose : Define Schema
    var ocorrenciaSchema = mongoose.Schema({
        // Dados Ocorrencia
        codigo: String,
        ano_lectivo: String,
        periodo: String,
        inscritos: Number,
        com_frequencia: Number,
        aprovados: Number,
        objectivos: String,
        conteudo: String,
        departamento: String,
	
        // Unidade Curricular
        uc : {		
            designacao: String,
            sigla: String,
            curso: Number
        },
	
        // Docentes
        docentes : [
            {
                nr : Number,
                nome: String,
                sigla: String,
                categoria: Number,
                proprio: String,
                apelido: String,
                estado: String,
			
                // Aulas
                aulas : [
                    {
                        dsd: {
                            horas: Number,
                            fator: Number,
                            ordem: Number
                        },
                        tipo: String,
                        turnos: Number,
                        n_aulas: Number,
                        horas_turno: Number,
                    }
                ]
            }
        ]	
    });  

    ocorrenciaSchema.index({codigo: 1, ano_lectivo: 1, periodo: 1}, { unique: true });

    // Mongoose : Declare Model
    var Ocorrencia = mongoose.model("ocorrencia", ocorrenciaSchema);

    mongoose.connect(url);
    var db = mongoose.connection;

    db.on("error", console.error.bind(console, "connection error:"));
    db.once("open", function() {
        console.log("Mongoose connected to %s on %s:%s", database, host, port);
        callback();
    });

    this.db = db;
    this.Ocorrencia = Ocorrencia;
}

module.exports = DatabaseParser;