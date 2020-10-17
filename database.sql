-- Tá dando um probleminha ao inserir um dado do tipo money, porém ao dividir por 100, resolve....
-- create database loteria;
-- create extension btree_gin;

create table tipoJogos(
	id_tipo integer primary key,
	nome varchar not null
);

create table concurso(
	id_concurso integer primary key,
	dataInicio timestamp not null,
	dataFim timestamp not null,
	arrecadacaoTotal money,
	valorDoPremio money,
	id_tipo integer not null,
	id_sort integer
);
 
create table concursoLoto(
	ganhadores15 integer,
	ganhadores14 integer,
	ganhadores13 integer,
	ganhadores12 integer,
	ganhadores11 integer
) inherits(concurso);

create table concursoMega(
	acumulado boolean not null,
	somadorMegaDaVirada money,
	ganhadores6 integer,
	ganhadores5 integer,
	ganhadores4 integer
) inherits(concurso);

create table sorteio(
	concursoPremiado integer primary key
);

create table sorteioLoto(
	bola1 integer not null,
	bola2 integer not null,
	bola3 integer not null,
	bola4 integer not null,
	bola5 integer not null,
	bola6 integer not null,
	bola7 integer not null,
	bola8 integer not null,
	bola9 integer not null,
	bola10 integer not null,
	bola11 integer not null,
	bola12 integer not null,
	bola13 integer not null,
	bola14 integer not null,
	bola15 integer not null
) inherits(sorteio);

create table sorteioMega(
	bola1 integer not null,
	bola2 integer not null,
	bola3 integer not null,
	bola4 integer not null,
	bola5 integer not null,
	bola6 integer not null
) inherits(sorteio);


-- Foreign keys adicionadas
alter table concurso add constraint fktipo foreign key (id_tipo) references tipoJogos(id_tipo);
alter table concurso add constraint fksorteio foreign key (id_sort) references sorteio(concursoPremiado) on delete cascade on update cascade;


-- Inserção table tipoJogos
insert into tipojogos values (1, 'Lotofácil');
insert into tipojogos values (2, 'Mega-Sena');
								 
								 
-- 6
create index idxMaiorPremioMega on concursoMega(valordopremio);
--drop index if exists idxmaiorpremiomega;

create index idxMaiorPremioLoto on concursoLoto(valordopremio);
--drop index if exists idxmaiorpremioloto;


--create extension btree_gin;
create index idxNumMaisRepeteMega on sorteiomega using gin (bola1);
--drop index if exists idxNumMaisRepeteMega;

create index idxNumMaisRepeteLoto on sorteioLoto using gin (bola1);
--drop index if exists idxNumMaisRepeteLoto;



create index idx4GanhadoresMega on concursoMega(ganhadores4);
--drop index if exists idx4GanhadoresMega;

create index idx5GanhadoresMega on concursoMega(ganhadores5);
--drop index if exists idx5GanhadoresMega;

create index idx6GanhadoresMega on concursoMega(ganhadores6);
--drop index if exists idx5GanhadoresMega;

create index idx11GanhadoresLoto on concursoLoto(ganhadores11);
--drop index if exists idx11GanhadoresLoto;

create index idx12GanhadoresLoto on concursoLoto(ganhadores12);
--drop index if exists idx12GanhadoresLoto;

create index idx13GanhadoresLoto on concursoLoto(ganhadores13);
--drop index if exists idx13GanhadoresLoto;

create index idx14GanhadoresLoto on concursoLoto(ganhadores14);
--drop index if exists idx14GanhadoresLoto;

create index idx15GanhadoresLoto on concursoLoto(ganhadores15);
--drop index if exists idx15GanhadoresLoto;
								 
-- Questão 7 - resolução:
											
-- Para a mega
select bola1, count(bola1)  as qtdeBola1 from sorteiomega
	group by bola1
	order by bola1 asc, qtdeBola1;

-- Para a loto	
select bola1, count(bola1)  as qtdeBola1 from sorteioloto
	group by bola1
	order by bola1 asc, qtdeBola1;								 

--Concurso com maior premio
CREATE OR REPLACE FUNCTION MaiorPremio(jogo integer)
RETURNS table(id_concurso integer,id_tipo integer,valordopremio money) AS $$
BEGIN
	RETURN QUERY(SELECT C.id_concurso, C.id_tipo, MAX(C.valordopremio)
				 FROM concurso C
				 WHERE C.id_tipo = jogo
				 GROUP BY C.id_concurso,C.id_tipo
				 ORDER BY C.valordopremio DESC
				 FETCH FIRST 1 ROW ONLY);
END;
$$ LANGUAGE plpgsql;
select MaiorPremio(1);	-- Loto
select MaiorPremio(2);	-- Mega

-- Maior quantidade de ganhadores da história.
CREATE OR REPLACE FUNCTION MaisGanhadoresMega()
RETURNS table(id_concurso integer,ganhadores6 integer,ganhadores5 integer,ganhadores4 integer) AS $$
BEGIN
	RETURN QUERY (SELECT M.id_concurso,max(M.ganhadores6),max(M.ganhadores5),max(M.ganhadores4)
	FROM concursoMega M
	GROUP BY M.id_concurso,M.ganhadores6,M.ganhadores5,M.ganhadores4
	ORDER BY M.ganhadores6 DESC
	FETCH FIRST 1 ROW ONLY);
END;
$$ LANGUAGE plpgsql;
select MaisGanhadoresMega();

CREATE OR REPLACE FUNCTION MaisGanhadoresLoto()
RETURNS table(id_concurso integer,ganhadores15 integer,ganhadores14 integer,ganhadores13 integer,ganhadores12 integer,
			 ganhadores11 integer) AS $$
BEGIN
	RETURN QUERY (SELECT L.id_concurso,max(L.ganhadores15),max(L.ganhadores14),
				  max(L.ganhadores13),max(L.ganhadores12),max(L.ganhadores11)
	FROM concursoLoto L
	GROUP BY L.id_concurso,L.ganhadores15,L.ganhadores14,L.ganhadores13,L.ganhadores12,L.ganhadores11
	ORDER BY L.ganhadores15 DESC
	FETCH FIRST 1 ROW ONLY);
END;
$$ LANGUAGE plpgsql;
								 

	
-- Auditoria
create table auditoriaConcursoLoto
(
    operacao varchar(6),
    data timestamp,
    id_concurso integer,
    dataInicio timestamp not null,
    dataFim timestamp not null,
    arrecadacaoTotal money,
    valorDoPremio money,
    id_tipo integer not null,
    id_sort integer,
    ganhadores15 integer,
    ganhadores14 integer,
    ganhadores13 integer,
    ganhadores12 integer,
    ganhadores11 integer
    
);

create table auditoriaConcursoMega
(
    operacao varchar(6),
    data timestamp,
    id_concurso integer,
    dataInicio timestamp not null,
    dataFim timestamp not null,
    arrecadacaoTotal money,
    valorDoPremio money,
    id_tipo integer not null,
    id_sort integer,
    acumulado boolean not null,
    somadorMegaDaVirada money,
    ganhadores6 integer,
    ganhadores5 integer,
    ganhadores4 integer
    
);

create or replace function processoauditorialoto()
returns trigger as $concursoaudloto$
begin

if(TG_OP = 'DELETE') then
insert into auditoriaConcursoLoto select 'delete', now(), old.*;
return old;
elsif(TG_OP = 'UPDATE') then
insert into auditoriaConcursoLoto select 'update', now(), new.*;
return new;
elsif(TG_OP = 'INSERT') then
insert into auditoriaConcursoLoto select 'insert', now(),  new.*;
return new;
end if;
return null;
end;
$concursoaudloto$ language plpgsql;

create trigger concursoaudloto
after insert or update or delete on concursoLoto
for each row execute procedure processoauditorialoto();

create or replace function processoauditoriamega()
returns trigger as $concursoaudmega$
begin

if(TG_OP = 'DELETE') then
insert into auditoriaConcursoMega select 'delete', now(), old.*;
return old;
elsif(TG_OP = 'UPDATE') then
insert into auditoriaConcursoMega select 'update', now(), new.*;
return new;
elsif(TG_OP = 'INSERT') then
insert into auditoriaConcursoMega select 'insert', now(), new.*;
return new;
end if;
return null;
end;
$concursoaudmega$ language plpgsql;

create trigger concursoaudmega
after insert or update or delete on concursoMega
for each row execute procedure processoauditoriamega();								 
							 

				--select * from concursoMega;	
								
				--select * from auditoriaConcursoLoto;
				--delete from auditoriaConcursoLoto where id_concurso != -1;
								 
				--delete from concursoLoto where concursoLoto.id_concurso != -1;
								 
						 

								 
-- Quantidade de ganhadores do ultimo concurso
create materialized view ganhadoresmega as
select sum(ganhadores6)+sum(ganhadores5)+sum(ganhadores5) as numero_de_ganhadores  from concursoMega
where id_concurso = (select max(id_concurso) from concursoMega)-1;


CREATE OR REPLACE FUNCTION atualizaganhadoresmega()
RETURNS trigger AS $$
BEGIN

REFRESH MATERIALIZED VIEW ganhadoresmega;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
								 							 
CREATE TRIGGER attultimosmega AFTER INSERT ON concursoMega
FOR EACH ROW EXECUTE PROCEDURE atualizaganhadoresmega();

create materialized view ganhadoresloto as
select sum(ganhadores15)+sum(ganhadores14)+sum(ganhadores13)+sum(ganhadores12)+sum(ganhadores11) as numero_de_ganhadores  from concursoLoto
where id_concurso = (select max(id_concurso) from concursoLoto)-1;

CREATE OR REPLACE FUNCTION atualizaganhadoresloto()
RETURNS trigger AS $$
BEGIN

REFRESH MATERIALIZED VIEW ganhadoresloto;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER attultimosloto AFTER INSERT ON concursoLoto
FOR EACH ROW EXECUTE PROCEDURE atualizaganhadoresloto();

---Valor acumulado


create materialized view acumuladomega as
select valordopremio from concursoMega
where id_concurso = ((select max(id_concurso) from concursoMega)-1) and acumulado = TRUE;


CREATE OR REPLACE FUNCTION checaracumulo()
RETURNS trigger AS $$
BEGIN

REFRESH MATERIALIZED VIEW acumulomega;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
								 
CREATE TRIGGER acmega AFTER INSERT ON concursoMega
FOR EACH ROW EXECUTE PROCEDURE checaracumulo();

---- informação dos 3 últimos concursos
-- Visão 2: informaçoes dos ultimos 3 concursos. - concurso, numero sorteado, premio e quantidade de ganhadores

create materialized view ultimosconcursosloto as
select concursoLoto.id_concurso as concurso, concursoLoto.valordopremio as premio, 
sum(concursoLoto.ganhadores15) + sum(concursoLoto.ganhadores14) + sum(concursoLoto.ganhadores13) + sum(concursoLoto.ganhadores12) + sum(concursoLoto.ganhadores11) as numero_de_ganhadores, bola1, bola2, bola3, bola4, bola5, bola6, bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15
from concursoLoto inner join sorteioloto on sorteioloto.concursoPremiado=concursoLoto.id_concurso

where ((concursoLoto.id_concurso = (select max(id_concurso) from concursoLoto)) or 
((concursoLoto.id_concurso = (select max(id_concurso) from concursoLoto)-1) or ((concursoLoto.id_concurso = (select  
max(id_concurso) from concursoLoto)-2))))
group by id_concurso, concursoLoto.valordopremio,  bola1, bola2, bola3, bola4, bola5, bola6, bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15;								

								 
								 
create materialized view ultimosconcursosmega as
select concursoMega.id_concurso as concurso, concursoMega.valordopremio as premio, sum(concursoMega.ganhadores6) + 
sum(concursoMega.ganhadores5) + sum(concursoMega.ganhadores4) as numero_de_ganhadores, 
bola1, bola2, bola3, bola4, bola5, bola6 from concursoMega inner join sorteiomega on sorteiomega.concursoPremiado=concursoMega.id_concurso
where ((concursoMega.id_concurso = (select max(id_concurso) from concursoMega)) or 
((concursoMega.id_concurso = (select max(id_concurso) from concursoMega)-1) or 
((concursoMega.id_concurso = (select max(id_concurso) from concursoMega)-2))))
group by id_concurso, concursoMega.valordopremio, bola1, bola2, bola3, bola4, bola5, bola6;

								 
CREATE OR REPLACE FUNCTION attultimoloto()
RETURNS trigger AS $$
BEGIN

REFRESH MATERIALIZED VIEW ultimosconcursosloto;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER attultimoslotoconc AFTER INSERT ON concursoLoto
FOR EACH ROW EXECUTE PROCEDURE attultimoloto();


CREATE OR REPLACE FUNCTION attultimomega()
RETURNS trigger AS $$
BEGIN

REFRESH MATERIALIZED VIEW ultimosconcursosmega;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER attultimomegaconc AFTER INSERT ON concursoLoto
FOR EACH ROW EXECUTE PROCEDURE attultimomega();
								 
								 
-- Função data
								 
--Data aleatoria (indicar periodo na funcao se quiser alterar)
create or replace function data() returns date as
$$
   begin
   return date(timestamp '2009-05-27 00:00:00' +
       random() * (timestamp '2018-11-21 00:00:00' -
                   timestamp '2009-05-27 00:00:00'));
   end;
$$language plpgsql;
-- select data()								 


CREATE OR REPLACE FUNCTION random_integer(integer, integer)
  RETURNS integer AS
$BODY$
   select trunc( $1 + (($2*random()) ))::integer
$BODY$
  LANGUAGE sql VOLATILE
				
				
				


