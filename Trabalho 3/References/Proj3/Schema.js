//Table lics (list of programs)
var LicsSchema = new mongoose.Schema({
    codigo: {type: Number, required: true, unique: true},
    sigla: {type: String, required: true, maxlength: 5},
    nome: {type: String, required: true, maxlength: 80}
});

/*• Table lics (list of programs)
• codigo NUMBER(4) NOT NULL primary key,
• sigla VARCHAR2(5) NOT NULL,
• nome VARCHAR2(80) NOT NULL*/

//Table cands
var CandsSchema = new mongoose.Schema({
    bi: {type: String, required: true, maxlength: 12},
    curso: {type: Number, required: true}, //reference lics
    ano_lectivo: {type: Number, required: true},
    resultado: {type: String, required: true, maxlength: 1}, // C – accepted; E – excluded; S – waiting list
    media: {type: Number, required: true}
});

/*• Table cands (all the applications)
• bi VARCHAR2(12) NOT NULL,
• curso NUMBER(4) NOT NULL references lics,
• ano_lectivo NUMBER(4) NOT NULL,
• resultado VARCHAR2(1), // C – accepted; E – excluded; S – waiting list
• media NUMBER(5,2),
• PRIMARY KEY (bi,curso, ano_lectivo)*/


//Table alus (the annual enrolments)
var AlusSchema = new mongoose.Schema({
	numero: {type: String, required: true, maxlength: 9, unique: true},
    bi: {type: String, required: true, maxlength: 12},
    curso: {type: Number}, //references lics
    a_lect_matricula: {type: Number, required: true},
    estado: {type: String, maxlength: 2}, //F – following; C – concluded
    a_lect_conclusao: {type: Number},
    med_final: {type: Number}
});

/*• Table alus (the annual enrolments). 
//Notice that if a person changes between programs, he will get two different student number, 
//but the same personal id (BI). Academic years are represented by the first year, i. e., 1999 means ‘1999/2000’.
• numero VARCHAR2(9) primary key,
• bi VARCHAR2(12) NOT NULL,
• curso NUMBER(4) references lics,
• a_lect_matricula NUMBER(4) NOT NULL,
• estado VARCHAR2(2), -- F – following; C – concluded
• a_lect_conclusao NUMBER(4),
• med_final NUMBER(4,2) – final grade
• FOREIGN KEY (bi, curso, a_lect_matricula) REFERENCES cands*/


//Table anos (list of years with enrolments)
var AnosSchema = new mongoose.Schema({
	ano: {type: Number}
});

/*• Table anos (list of years with enrolments)
• ano NUMBER(4).*/