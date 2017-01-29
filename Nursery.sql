drop table fruit;
drop table flower;
drop table wood;
drop table plant;


create table plant
	     (
	    plants_id       varchar(10) NOT NULL,
        plants_age	number(3) check (plants_age > 0 )
	    --primary key    (plants_id)
  );
  
alter table plant modify plants_id  number(6); 
alter table plant add constraint plants_id_pk primary key (plants_id);


create table fruit
	     (
	fruit_no	 number(6) NOT NULL,
	fruit_name	 varchar(20),
    fruit_age	number(3) check (fruit_age > 0 ),
	price		 number(5,2),
	groth_date   date default sysdate,
	foreign key (fruit_no) references plant (plants_id) on delete cascade
  );


create table flower
	     (
	flower_no        number(6) NOT NULL,
	flower_name	 varchar(30) ,
	price		 number(5,2),
	groth_date   date default sysdate
	--foreign key (flower_no) references plant (plants_id) on delete cascade
  );

alter table flower add constraint flower_no_pk foreign key (flower_no) references plant (plants_id) on delete cascade;

create table wood
	     (
	wood_no		 number(6) NOT NULL,
	wood_name	 varchar(30) ,
	price		 number(5,2),
	groth_date   date default sysdate,
	foreign key (wood_no) references plant (plants_id) on delete cascade
  );


describe  plant;
describe  flower;
describe  fruit;
describe  wood;



insert into plant values (1201,12);
insert into plant values (1202,14);
insert into plant values (1203,null);
insert into plant values (1204,14);
insert into plant values (1205,10);

insert into plant values (1301,26);
insert into plant values (1302,50);
insert into plant values (1303,32);
insert into plant values (1304,26);
insert into plant values (1305,50);
insert into plant values (1306,32);


insert into plant values (1401,30);
insert into plant values (1402,31);
insert into plant values (1403,33);
insert into plant values (1404,31);
insert into plant values (1404,33);






insert into flower values (1301,'rose',25,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into flower values (1302,'Hasnahena',25,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into flower values (1303,'jui',50,to_date('01-Jan-2015','DD-MM-YYYY'));


insert into wood   values (1401, 'mehegunni' , 100,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into wood   values (1402, 'jacfruit' , 150,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into wood   values (1403, 'Rentry' , 200,to_date('01-Jan-2015','DD-MM-YYYY'));

select * from plant;
select * from flower;

select * from wood;



--trigger
CREATE TRIGGER TR_of_fruit  
BEFORE UPDATE OR INSERT ON fruit  
FOR EACH ROW  
BEGIN 
	IF :NEW.fruit_age < 50 THEN 
	:NEW.price:= 45; 
	END IF; 
END TR_of_fruit; 
/ 

insert into fruit  values (1201, 'mango', 50 ,25,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into fruit  values (1202, 'guava', 10 ,40,to_date('01-Jan-2015','DD-MM-YYYY'));
insert into fruit  values (1203, 'jackfruit', 77 ,50,to_date('01-Jan-2015','DD-MM-YYYY'));
commit;

insert into fruit  values (1204, 'banana', 50 ,75,to_date('01-Jan-2015','DD-MM-YYYY'));

savepoint cont_4;

insert into fruit  values (1205, 'Orange', 50 ,100,to_date('01-Jan-2015','DD-MM-YYYY'));

savepoint cont_5;


rollback to cont_4;

select * from fruit;

delete from plant where plants_id = '1301';

select * from flower;

select * from wood where price IN(100,200);

select * from wood where wood_name like '%jacfruit%';

select * from plant order by plants_age desc;


select count(plants_id),count(plants_age) from plant;

select max(price) from wood;

select plants_id,count(plants_age) from plant group by plants_id;

insert into flower (flower_no, flower_name, price ) select plants_id,'lily', 60 from plant where plants_id =1304 ;
select flower_name, price from flower where flower_no in (select plants_id from plant where plants_age >=10 and plants_age <=100);

select flower_name , price from flower union select f.flower_name, f.price from flower f where price in 
  ( select fl.price from flower fl , fruit frt where fl.price >=20 and frt.price <= 100);
  
select * from fruit; 
select * from flower;
select fr.fruit_no, fr.fruit_name , fl.flower_no, fl.flower_name from fruit fr cross join  flower fl;
select fr.fruit_no, fr.fruit_name , fl.flower_no, fl.flower_name from fruit fr join  flower fl using(price);
select fr.fruit_no, fr.fruit_name , fl.flower_no, fl.flower_name from fruit fr left outer join  flower fl on fr.price = fl.price;
select fr.fruit_no, fr.fruit_name , fl.flower_no, fl.flower_name from fruit fr right outer join  flower fl on fr.price = fl.price;
select fr.fruit_no, fr.fruit_name , fl.flower_no, fl.flower_name from fruit fr full outer join  flower fl on fr.price = fl.price;

--pl/sql 

set SERVEROUTPUT ON
declare
	max_fruit_price fruit.price%Type;
	max_fruit_age  fruit.fruit_age%TYPE;
begin
	select max(price),max(fruit_age) into max_fruit_price ,max_fruit_age from fruit;
	DBMS_OUTPUT.PUT_LINE('The maximum fruit price is : '|| max_fruit_price);
	DBMS_OUTPUT.PUT_LINE('The maximum fruit price is : '|| max_fruit_age);
end;
/

--pl/sql update
create or replace procedure upd_flower (
	f_id flower.flower_no%type,
	f_name flower.flower_name%type) is
begin
	update flower set flower_name=f_name where flower_no = f_id;
	if sql%notfound then
		raise_application_error(-20202, 'no flower updated');
	end if;
	commit;
end upd_flower;
/
show errors

begin 
	upd_flower(1303, 'Chameli');
end;
/

--pl/sql insert
create or replace procedure insert_wood (
	w_id wood.wood_no%type,
	w_name wood.wood_name%type,
	w_price wood.price%type,
	w_g_date wood.groth_date%type
	) is
begin
	insert into wood values
		(
			w_id, w_name, w_price, w_g_date
		);

	if sql%notfound then
		raise_application_error(-20000, 'no wood inserted');
	end if;
	commit;
end insert_wood;
/
show errors

begin 
	insert_wood(1404, 'Shal',  120,to_date('23-Aug-2015','DD-MM-YYYY'));
end;
/
select * from wood;


--pl/sql delete
create or replace procedure del_wood (
	wid wood.wood_no%type) is
begin
	delete from wood where wood_no = wid;
	if sql%notfound then
		raise_application_error(-20203, 'no wood deleted');
	end if;
	commit;
end del_wood;
/
show errors

begin 
	del_wood(1402);
end;
/
select * from wood;

--pl/sql function

set serverout on
create or replace function get_plant_name (
	plnt_id plant.plants_id%type) return varchar is
plant_name  wood.wood_name%type;
begin
	select wood_name into plant_name from wood where wood_no = plnt_id;
	if sql%notfound then
		dbms_output.put_line('no such plant found');
	end if;
	commit;
	return plant_name;
end;
/
show errors

begin 
	dbms_output.put_line('Plant name is: ' || get_plant_name(1403));
end;
/
--cursor
set SERVEROUTPUT ON
declare 
  cursor fruit_cur is
  select fruit_no, fruit_name from fruit;
  fruit_record fruit_cur%rowtype;
begin
  open fruit_cur;
    loop
		 fetch fruit_cur into fruit_record;
		 exit when fruit_cur%rowcount > 3;
		 dbms_output.put_line('Fruit ID : '|| fruit_record.fruit_no ||'    '|| 'Fruit Namae : '|| fruit_record.fruit_name);
	 end loop;
 close fruit_cur;
end;
/



