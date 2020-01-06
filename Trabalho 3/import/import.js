const Mongo = require('mongodb').MongoClient;

const assert = require('assert');
const fs = require('fs');

const url = 'mongodb://tbdb:grupob@vdbase.inesctec.pt:27017';

const dbName = 'tbdb';

const docentes_json = JSON.parse(fs.readFileSync('./exports/docentes.json','utf-8'));
const dsd_json =  JSON.parse(fs.readFileSync('./exports/dsd.json', 'utf-8'));
const ocorrencias_json = JSON.parse(fs.readFileSync('./exports/ocorrencias.json', 'utf-8'));
const tiposaula_json = JSON.parse(fs.readFileSync('./exports/tiposaula.json', 'utf-8'));
const ucs_json = JSON.parse(fs.readFileSync('./exports/ucs.json', 'utf-8'));

aux();

async function aux(){
    await createDocentesCollection();
    await createUcsCollection();
}

Mongo.connect(url, function(err, client) {
        assert.equal(null, err);
        console.log("Connected successfully to server");
    
        const db = client.db(dbName);

        try{
            db.collection('docentes').insertMany(docentes_json);
            console.log('Dados dos Docentes inseridos!');
        } catch (e) {
            print(e);
        }

        try{
            db.collection('ucs').insertMany(ucs_json);
            console.log('Dados das Unidades Curriculares inseridos!');
        } catch (e) {
            print(e);
        }

        client.close();
});

function createDocentesCollection() {
    docentes_json.forEach(i => {
        const dsd = [];
        dsd_json.forEach(j => {
            if (i["nr"] == j["nr"]){
                const k = {};
                k.id = j.id;
                k.horas = j.horas;
                k.fator = j.fator;
                k.ordem = j.ordem;
                dsd.push(k);
            }
        });
        i.dsd = dsd;
    });
}

function createUcsCollection() {
    ucs_json.forEach(i => {
        const ocorrencias = [];
        ocorrencias_json.forEach(j => {
            if (i["codigo"] == j["codigo"]){
                const tiposaula = [];
                tiposaula_json.forEach(k => {
                    if (j["ano_letivo"] == k["ano_letivo"] && j["periodo"] == k["periodo"] && j["codigo"]==k["codigo"]){
                        delete k["ano_letivo"];
                        delete k["periodo"];
                        delete k["codigo"];
                        tiposaula.push(k);
                    }
                });
                j.tiposaula = tiposaula;
                delete j["codigo"];
                ocorrencias.push(j);
            }
        })
        i.ocorrencias = ocorrencias;
    })
}