DELIMITER //
CREATE PROCEDURE orderSomeCar(IN order_id int, IN some_car_VIN int)
BEGIN
	DECLARE `fail` bool default 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `fail` = 1;
	set autocommit = 0;
	start transaction;
	insert into order_car values (order_id, some_car_VIN);
	update car set is_sold = true where VIN = some_car_VIN;
	if `fail` THEN
		select "transaction failed" as error_message;
		rollback;
	else
		commit;
	end if;
    set autocommit = 1;
END //

CREATE PROCEDURE orderSomePiece(IN order_id int, IN some_piece_name char(16))
BEGIN
	DECLARE `fail` bool default 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `fail` = 1;
	set autocommit = 0;
	start transaction;
	insert into order_piece values (order_id, some_piece_name);
	update piece set stock = stock - 1 where piece_name = some_piece_name;
	if `fail` THEN
    	select 'transaction failed' as error_message;
		rollback;
	else
		commit;
	end if;
	set autocommit = 1;
END //
DELIMITER ;
drop procedure orderSomeCar;
drop procedure orderSomePiece;
select * from order_piece;
select @some_piece_name;
select @some_order_id;
select * from orders;
set @some_order_id = 1;
select * from order_piece;
set @some_piece_name := "w1";
select * from piece;
call orderSomePiece(@some_order_id, @some_piece_name);
set @some_car_VIN := "12345680";
select *, @some_car_VIN from car;
select * from car;
call orderSomeCar(@some_order_id, @some_car_VIN);
-- select * from piece;
-- select * from piece;

create table model_and_brand (
	bm_id int not null auto_increment primary key,
    brand_name char(16) not null,
    model_name char(16) not null,
    unique(brand_name, model_name)
);

create table car_option (
	option_id int not null auto_increment primary key,
    color char(16) not null,
    is_automatic bool not null,
    unique(color, is_automatic)
);

create table car (
	VIN int not null primary key,
	bm_id int NOT NULL,
    option_id int NOT NULL,
    foreign key (bm_id) references model_and_brand(bm_id),
    foreign key (option_id) references car_option(option_id)
);

create table address (
	address_id int not null primary key,
	state char(16) not null,
    city char(16) not null,
    street char(16) not null
);

create table customer(
	customer_id bigint not null primary key,
    firstname char(16) not null,
    lastname char(16) not null,
    phone_number char(16) not null,
    address_id int not null,
    foreign key (address_id) references address(address_id)
);
alter table customer change customer_id customer_id bigint not null;
alter table orders change customer_id customer_id bigint not null;
drop table order_car;
drop table order_piece;
drop table orders;
drop table customer;

create table supplier (
	supplier_name char(16) not null primary key,
    effective_date char(16) not null,
    expiration_date char(16) not null,
    chief_firstname char(16) not null,
    chief_lastname char(16) not null,
    address_id int not null,
    foreign key (address_id) references address(address_id)
);
alter table supplier change expiration_date expiration_date char(16) not null;
alter table supplier change effective_date effective_date char(16) not null;
    
create table piece (
	piece_name char(16) not null primary key,
    price int not null,
    stock int not null,
    supplier_name char(16) not null,
    foreign key (supplier_name) references supplier(supplier_name)
);

create table orders (
	order_id int not null primary key,
    customer_id bigint not null,
    foreign key (customer_id) references customer(customer_id)
);


create table order_car (
	order_id int not null,
    VIN int not null,
    primary key (VIN, order_id),
    foreign key (VIN) references car(VIN),
    foreign key (order_id) references orders(order_id)
);
drop table order_car;
alter table order_car add count int not null default 1;

create table order_piece (
	order_id int not null,
    piece_name char(16) not null,
    primary key (piece_name, order_id),
    foreign key (piece_name) references piece(piece_name),
    foreign key (order_id) references orders(order_id)
);
drop table order_piece;
alter table order_piece add count int not null default 1;

insert into address values (1, "tehran", "tehran", "shariati"); # state, city, street
insert into address values (2, "shiraz", "tehran", "valiasr");
insert into address values (3, "tehran", "kish", "motahari");
insert into address values (4, "karaj", "hamedan", "mosavi");

insert into customer values (1, "armin", "ebrahimi", "09122388244", 1); # customer_id, firstname, lastname, phonenumber, address_id
insert into customer values (2, "omid", "ebrahimi", "09122388354", 2);
insert into customer values (3, "mohammad", "ebrahimi", "09122188344", 1);
insert into customer values (4, "ali", "ebrahimi", "09122388343", 3);
insert into customer values (5, "john", "ebrahimi", "09122388244", 2);
insert into customer values (6, "mohsen", "zade", "09122388354", 2);
insert into customer values (7, "ali", "karimi", "09122388384", 2);
insert into customer values (8, "ali", "sadeghi", "09122388744", 4);
insert into customer values (9, "mohsen", "rezazade", "09129388344", 4);
insert into customer values (10, "arman", "najafi", "09122382344", 4);

insert into supplier values ("x1", "1/18/2023", "1/18/2024", "y1", "z1", 1); # suppler_name, effective_date, expiration_date, chief_firstname, chief_lastname, address_id
insert into supplier values ("x2", "1/18/2022", "1/18/2024", "y2", "z2", 2);
insert into supplier values ("x3", "1/18/2021", "1/18/2023", "y3", "z3", 3);
insert into supplier values ("x4", "1/18/2020", "1/18/2029", "y4", "z4", 4);

insert into car_option values (1, "black", true); # option_id, color_name, is_automatic
insert into car_option values (2, "black", false);

insert into model_and_brand values (1, "b1", "m1"); # md_id, brand_name, model_name
insert into model_and_brand values (2, "b1", "m2");
insert into model_and_brand values (3, "b2", "m1");
insert into model_and_brand values (4, "b2", "m2");

insert into piece values ("w1", 100, 125, "x1"); #piece_name, price, stock, supplier_name
insert into piece values ("w2", 100, 125, "x2");
insert into piece values ("w3", 100, 125, "x3");
insert into piece values ("w4", 100, 125, "x4");
insert into piece values ("w5", 100, 125, "x1");
insert into piece values ("w6", 100, 125, "x2");
insert into piece values ("w7", 100, 125, "x3");
insert into piece values ("w8", 100, 125, "x4");
#insert into piece values ("w9", 100, 1, "x4");

insert into car values (12345679, 1, 1); # VIN, mb_id, option_id
insert into car values (12345680, 1, 1);
insert into car values (12345681, 1, 1);
insert into car values (12345682, 2, 1);
insert into car values (12345683, 2, 1);
insert into car values (12345684, 2, 1);
insert into car values (12345685, 3, 2);
insert into car values (12345686, 3, 2);
insert into car values (12345687, 3, 2);
insert into car values (12345688, 4, 2);
insert into car values (12345689, 4, 2);
insert into car values (12345690, 4, 2);

insert into orders values (1, 1); # order_id, customer_id
insert into orders values (2, 2);
insert into orders values (3, 3);

insert into order_car values (1, 12345679); # order_id, VIN
insert into order_car values (2, 12345680);
insert into order_car values (3, 12345681);

insert into order_piece values (1, "w1"); # order_id, piece_name 
insert into order_piece values (2, "w2");
insert into order_piece values (3, "w3");

# 4th phase
insert into address values (5, "London", "London", "212 Baker Street");
insert into customer values (123456781011, "Sherlock", "holmes", "+44796268462", 5);
insert into orders values (4, 123456781011);
insert into order_car values (4, 12345688);
update customer set phone_number="+447342780080" where customer_id=123456781011;
delete from customer where customer_id not in (select customer_id from orders);
select * from customer;

drop table orders;
drop table order_car;
drop table order_piece;

# 5th phase
create view supplier_supplies as (select * from piece natural join supplier);
create view customer_order as (
select customer.*, orders.order_id, order_car.VIN, null as piece_name 
from customer natural join orders natural join order_car 
union
select customer.*, orders.order_id, null as VIN, order_piece.piece_name 
from customer natural join orders natural join order_piece
);
create view car_brand_model as (select * from car natural join model_and_brand);
drop view customer_order;
select * from supplier_supplies;
select * from customer_order;
select * from car_brand_model;

# 6th phase
-- drop table order_car;
-- drop table order_piece;
-- drop table orders;
-- update car set is_sold=false where true;
-- update piece set stock=10 where true;
alter table car add is_sold bool not null default false;
update car set is_sold=true where VIN in (select VIN from order_car);
select * from car;
set @some_order_id := 1;
set @some_car_VIN := 12345679;
call orderSomeCar(@some_order_id, @some_car_VIN);
set @some_piece_name := "w1";
call orderSomePiece(@some_order_id, @some_piece_name);
select * from piece;
insert into order_car values (@some_order_id, @some_car_VIN);
update car set is_sold = true where VIN = @some_car_VIN;
select * from car;

# 7th phase
delimiter //
create trigger non_zero_stock before insert on order_piece for each row 
begin
	if (select stock < 2 from piece where piece_name = NEW.piece_name) then 
		signal sqlstate '45000' set message_text = 'stock is less than 2';
	else
		update piece set stock = stock - 1 where piece_name = NEW.piece_name;
	end if;
end; //

create trigger duplicate_car_sell before insert on order_car for each row 
begin
	if (select is_sold from car where VIN = NEW.VIN) then
		signal sqlstate '45000' set message_text = 'car has been sold';
	else
		update car set is_solde = true where VIN = NEW.VIN;
	end if;
end; //

delimiter ;
drop trigger non_zero_stock;
drop trigger duplicate_car_sell;

# 8th phase
create index supplier_expiration_date_index on supplier(expiration_date);
create index piece_stock_index on piece(stock);
create index customer_phone_number_index on customer(phone_number);
create index brand_name_index on model_and_brand(brand_name);

# 9th phase
CREATE USER 'john_doe'@'localhost' IDENTIFIED BY 'johndoe2000johndoe';
grant select on *.* to 'john_doe'@'localhost';

# 10th phase
create table brand (
	brand_id int not null auto_increment primary key,
    brand_name char(16) not null
);

create table brand_logs (
	id int auto_increment primary key,
    brand_id int,
    old_name char(16),
    new_name char(16),
    changed_at datetime,
    foreign key (brand_id) references brand(brand_id)
);

create trigger on_brand_name_change after update on brand for each row 
																	insert into brand_logs
																	set 
                                                                    brand_id = OLD.brand_id,
                                                                    old_name = OLD.brand_name,
                                                                    new_name = NEW.brand_name,
                                                                    changed_at = now();
drop trigger on_brand_name_change;
create trigger on_new_brand_name after insert on brand for each row 
																insert into brand_logs
																set 
                                                                brand_id = NEW.brand_id,
                                                                old_name = NULL,
                                                                new_name = NEW.brand_name,
                                                                changed_at = now();
drop trigger on_new_brand_name;
select * from brand_logs;
insert into brand values (1, "206");
insert into brand values (2, "pegeot");
update brand set brand_name = "samand" where brand_id = 1;