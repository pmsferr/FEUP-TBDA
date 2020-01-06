const express = require("express");
const app = express();
const MongoClient = require("mongodb").MongoClient;
var fs = require('fs');

var ucs_url = "../UCS.json";
var docentes_url = "../DOCENTES.json";

var ucs_json;
var docentes_json;

app.get("/insertDocentes", (req, res) => {
MongoClient.connect('mongodb://tbdb:grupob@vdbase.inesctec.pt:27017/tbdb?aut hSource=admin',function(err, db){
if(err) 
  console.log(err);
else
{
	console.log('Connected');
	var dbo = db.db("tbdb"); 
	dbo.collection("docentes").insertMany(docentes_json,
function(err, res) {
 
if (err) throw err;
console.log("Docentes document inserted"); 
db.close();
		});
	}
});
 return res.send();
});

 app.get("/insertUcs", (req, res) => {

    MongoClient.connect('mongodb://tbdb:grupob@vdbase.inesctec.pt:27017/tbdb?aut hSource=admin',function(err, db){
if(err)
 console.log(err);
 else
{
   console.log('Connected');
	var dbo = db.db("tbdb"); 
	dbo.collection("ucs").insertMany(ucs_json, function(err, res) {
		if (err) throw err;
		console.log("UCS document inserted"); 
		db.close();
			});
		}
});
	return res.send();
});

app.get("/load", (req, res) => {
ucs_json = JSON.parse(fs.readFileSync(ucs_url, 'utf8')); 
docentes_json = JSON.parse(fs.readFileSync(docentes_url, 'utf8'));
return res.send();
});

app.get("/", (req, res) => {
    MongoClient.connect('mongodb://tbdb:grupob@vdbase.inesctec.pt:27017/tbdb?aut hSource=admin',function(err, db){
	if(err) 
		console.log(err);
else
{
 console.log('Mongo Connected');
}
});
  
return res.send();
});

app.listen(3000, () => { console.log("Listening on port 3000!");
});




