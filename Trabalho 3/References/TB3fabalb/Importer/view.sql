create or replace view ocs_ucs_view as (
    select 
        gtd10.xocorrencias.codigo as ocorrencia_codigo,
        gtd10.xocorrencias.ano_letivo as ocorrencia_ano_letivo,
        gtd10.xocorrencias.periodo as ocorrencia_periodo,
        gtd10.xocorrencias.inscritos as ocorrencia_inscritos,
        gtd10.xocorrencias.com_frequencia as ocorrencia_com_frequencia,
        gtd10.xocorrencias.aprovados as ocorrencia_aprovados,
        gtd10.xocorrencias.objetivos as ocorrencia_objetivos,
        gtd10.xocorrencias.conteudo as ocorrencia_conteudo,
        gtd10.xocorrencias.departamento as ocorrencia_departamento,
        gtd10.xucs.designacao as uc_designacao,
        gtd10.xucs.sigla_uc as uc_sigla_uc,
        gtd10.xucs.curso as uc_curso
    from 
        gtd10.xocorrencias
    join 
        gtd10.xucs 
    on 
        gtd10.xocorrencias.codigo = gtd10.xucs.codigo
);

create or replace view doc_dsd_view as (
    select 
        gtd10.xdocentes.nome,
        gtd10.xdocentes.sigla,
        gtd10.xdocentes.categoria,
        gtd10.xdocentes.proprio,
        gtd10.xdocentes.apelido,
        gtd10.xdocentes.estado,
        gtd10.xdsd.horas,
        gtd10.xdsd.fator,
        gtd10.xdsd.ordem,
        gtd10.xdsd.id,
        gtd10.xdocentes.nr
    from 
        gtd10.xdsd
    join 
        gtd10.xdocentes
    on
        gtd10.xdsd.nr = gtd10.xdocentes.nr
);

create or replace view doc_dsd_taulas_view as (
    select 
        doc_dsd_view.nome as docente_nome,
        doc_dsd_view.sigla as docente_sigla,
        doc_dsd_view.categoria as docente_categoria,
        doc_dsd_view.proprio as docente_proprio,
        doc_dsd_view.apelido as docente_apelido,
        doc_dsd_view.estado as docente_estado,
        doc_dsd_view.horas as dsd_horas,
        doc_dsd_view.fator as dsd_fator,
        doc_dsd_view.ordem as dsd_order,
        gtd10.xtiposaula.tipo as aula_tipo,
        gtd10.xtiposaula.turnos as aula_turnos,
        gtd10.xtiposaula.n_aulas  as aula_n_aulas,
        gtd10.xtiposaula.horas_turno as aula_horas_turno,
        gtd10.xtiposaula.ano_letivo as j_ano_letivo,
        gtd10.xtiposaula.codigo as j_codigo,
        gtd10.xtiposaula.periodo as j_periodo,
        doc_dsd_view.nr as docente_nr
    from
        doc_dsd_view
    join
        gtd10.xtiposaula
    on
        doc_dsd_view.id = gtd10.xtiposaula.id
);

create or replace view master_view as (
    select
        ocorrencia_codigo,
        ocorrencia_ano_letivo,
        ocorrencia_periodo,
        ocorrencia_inscritos,
        ocorrencia_com_frequencia,
        ocorrencia_aprovados,
        ocorrencia_objetivos,
        ocorrencia_conteudo,
        ocorrencia_departamento,
        uc_designacao,
        uc_sigla_uc,
        uc_curso,
        docente_nome,
        docente_sigla,
        docente_categoria,
        docente_proprio,
        docente_apelido,
        docente_estado,
        dsd_horas,
        dsd_fator,
        dsd_order,
        aula_tipo,
        aula_turnos,
        aula_n_aulas,
        aula_horas_turno,
        docente_nr
    from
        ocs_ucs_view 
    join
        doc_dsd_taulas_view
    on 
        ocs_ucs_view.ocorrencia_codigo = doc_dsd_taulas_view.j_codigo and
        ocs_ucs_view.ocorrencia_ano_letivo = doc_dsd_taulas_view.j_ano_letivo and
        ocs_ucs_view.ocorrencia_periodo = doc_dsd_taulas_view.j_periodo  
);