require("rootpath")();
const DatabaseParser = require("DatabaseParser");
const parseString = require("xml2js").parseString;
const fs = require("fs");

var config;
try{
    config = require("config.json");
}catch(ex){
    console.log("Could not find 'config.json', please create one using 'config-example.json' as a template");
    process.exit(0);
}

var dbp = new DatabaseParser(
    config.mongodb.host,
    config.mongodb.port,
    config.mongodb.username,
    config.mongodb.password,
    config.mongodb.authDB,
    config.mongodb.database,
    () => {
        var xml;

        try{
            console.log("Reading exported database data...");
            xml = fs.readFileSync("export.xml");
        }catch(ex){
            console.log("Could not read 'export.xml'");
            console.log("See the readme for instructions on how to export the Oracle DB");
            process.exit(0);
        }

        console.log("Converting data...");
        parseString(xml, (err, result) => {
            var j = result;
            console.log("Converted data sucessfully, processing documents...");

            var rows = j.RESULTS.ROW;
            var totalRows = rows.length - 1;

            var obj = {};
            var obj_d = {};

            for(var i in rows){
                var row = rows[i].COLUMN;
                console.log("Processing row %d / %d", i, totalRows);

                var ocorrencia_codigo          = (row[0]._ || null);
                var ocorrencia_ano_letivo      = (row[1]._ || null);
                var ocorrencia_periodo         = (row[2]._ || null);
                var ocorrencia_inscritos       = (row[3]._ || "").replace(",", ".");
                var ocorrencia_com_frequencia  = (row[4]._ || "").replace(",", ".");
                var ocorrencia_aprovados       = (row[5]._ || "").replace(",", ".");
                var ocorrencia_objetivos       = (row[6]._ || null);
                var ocorrencia_conteudo        = (row[7]._ || null);
                var ocorrencia_departamento    = (row[8]._ || null);
                var uc_designacao              = (row[9]._ || null);
                var uc_sigla_uc                = (row[10]._ || null);
                var uc_curso                   = (row[11]._ || "").replace(",", ".");
                var docente_nome               = (row[12]._ || null);
                var docente_sigla              = (row[13]._ || null);
                var docente_categoria          = (row[14]._ || "").replace(",", ".");
                var docente_proprio            = (row[15]._ || null);
                var docente_apelido            = (row[16]._ || null);
                var docente_estado             = (row[17]._ || null);
                var dsd_horas                  = (row[18]._ || "").replace(",", ".");
                var dsd_fator                  = (row[19]._ || "").replace(",", ".");
                var dsd_ordem                  = (row[20]._ || "").replace(",", ".");
                var aula_tipo                  = (row[21]._ || null);
                var aula_turnos                = (row[22]._ || "").replace(",", ".");
                var aula_n_aulas               = (row[23]._ || "").replace(",", ".");
                var aula_horas_turno           = (row[24]._ || "").replace(",", ".");
                var docente_nr                 = (row[25]._ || "").replace(",", ".");

                var key_oc = ocorrencia_ano_letivo + "::" + ocorrencia_codigo + "::" + ocorrencia_periodo;

                if(obj[key_oc] == null){
                    obj[key_oc] = {
                        "codigo": ocorrencia_codigo,
                        "ano_lectivo": ocorrencia_ano_letivo,
                        "periodo": ocorrencia_periodo,
                        "inscritos": ocorrencia_inscritos,
                        "com_frequencia": ocorrencia_com_frequencia,
                        "aprovados": ocorrencia_aprovados,
                        "objectivos": ocorrencia_objetivos,
                        "conteudo": ocorrencia_conteudo,
                        "departamento": ocorrencia_departamento,

                        "uc" : {
                            "designacao": uc_designacao,
                            "sigla": uc_sigla_uc,
                            "curso": uc_curso
                        },

                        "docentes" : []
                    };
                }

                var key_dc = docente_sigla;

                if(obj_d[key_oc] == null){
                    obj_d[key_oc] = {};
                    obj_d[key_oc]["docente_list"] = [];
                }

                if(obj_d[key_oc][key_dc] == null){
                    obj_d[key_oc][key_dc] = {
                        "nr" : docente_nr,
                        "nome" : docente_nome,
                        "sigla" : docente_sigla,
                        "categoria" : docente_categoria,
                        "proprio" : docente_proprio,
                        "apelido" : docente_apelido,
                        "estado" : docente_estado,

                        "aulas" : []
                    };

                    obj_d[key_oc]["docente_list"].push(key_dc);
                }

                obj_d[key_oc][key_dc].aulas.push({
                    "dsd" : {
                        "horas": dsd_horas,
                        "fator": dsd_fator,
                        "ordem": dsd_ordem
                    },
                    "tipo": aula_tipo,
                    "turnos": aula_turnos,
                    "n_aulas": aula_n_aulas,
                    "horas_turno": aula_horas_turno
                });
            }

            var docs = [];

            console.log("Building documents...");
            for(var ii in obj){
                var o = obj[ii];

                var k_ano = o.ano_lectivo || "";
                var k_cod = o.codigo || "";
                var k_per = o.periodo || "";

                var k = k_ano + "::" + k_cod + "::" + k_per;
                var l = obj_d[k]["docente_list"];

                for(var iii in l){
                    o.docentes.push(obj_d[k][l[iii]]);
                }

                docs.push(new dbp.Ocorrencia(o));
            }

            dbp.Ocorrencia.collection.insert(docs, (err, docs) => {
                console.log("Inserted documents into MongoDB");
                dbp.db.close();
            });
        });
    }
);
