create table farm
(id int generated always as identity not null, 
 farm_name varchar2(50)  not null,
 constraint farm_pk primary key (id) enable);


create table input_type
(id int generated always as identity not null, 
 input_type_name varchar2(50)  not null,
 constraint input_type_pk primary key (id) enable);


create table formulation
(id int generated always as identity not null, 
 formulation_name varchar2(50)  not null,
 constraint formulation_pk primary key (id) enable);


create table crop
(id int generated always as identity not null, 
 crop_name varchar2(50)  not null,
 is_permanent number(1) constraint check_is_permanent check (is_permanent in(0,1)),
 unit_value varchar2(5) not null,
 constraint crop_pk primary key (id) enable);

create table input_hub
(id int generated always as identity not null,
 input_string varchar2(25) not null,
 constraint input_hub_pk primary key (id) enable);


create table hub
(id varchar2(10) not null,
 hub_location_latitude float(10) not null,
 hub_location_longitude float(10) not null,
 constraint hub_pk primary key (id) enable);


create table hub_type
(hub_id varchar2(10) not null,
 type varchar2(1) not null,
 constraint hub_type_pk primary key (hub_id) enable);
 
  
create table customer
(id int generated always as identity not null, 
 customer_name varchar2(50)  not null,
 tax_number varchar2(20) not null constraint check_tax_number check (tax_number>=0),
 email varchar(30)  constraint email_format check (regexp_like (email, '^\w+(\.\w+)*+@\w+(\.\w+)+$')),
 credit_limit int not null constraint check_credit_limit check (credit_limit>=0),
 value_of_last_year_orders int not null constraint check_value_of_last_year_orders check (value_of_last_year_orders>=0),
 number_of_last_year_orders int not null constraint check_number_of_last_year_orders check (number_of_last_year_orders>=0),
 constraint customer_pk primary key (id) enable);
 

create table customer_hub
(customer_id int not null,
 hub_id varchar2(10),
 constraint customer_hub_pk primary key (customer_id) enable); 

alter table customer_hub
add constraint customer_hub_fk1 foreign key(hub_id)
references hub (id) enable;


create table building
(id int generated always as identity not null, 
 farm_id int not null,
 building_name varchar2(50)  not null,
 constraint building_pk primary key (id) enable);

alter table building 
add constraint building_fk1 foreign key(farm_id)
references farm (id) enable;


create table garage
( building_id int not null,
 constraint garage_pk primary key (building_id) enable);

alter table garage 
add constraint garage_fk1 foreign key(building_id)
references building (id) enable;


create table storage
(building_id int not null,
 constraint storage_pk primary key (building_id ) enable);

alter table storage 
add constraint storage_fk1 foreign key(building_id)
references building (id) enable;


create table stable
(building_id int not null,
 constraint stable_pk primary key (building_id ) enable);

alter table stable 
add constraint stable_fk1 foreign key(building_id)
references building (id) enable;


create table irrigation_system
(building_id int not null,
 constraint irrigation_system_pk primary key (building_id) enable);

alter table irrigation_system 
add constraint irrigation_system_fk1 foreign key(building_id)
references building (id) enable;


create table sector
(id int generated always as identity not null, 
 farm_id int not null,
 designation varchar2(30) not null,
 area int not null constraint check_area1 check (area>=0),
 constraint sector_pk primary key (id) enable);

alter table sector 
add constraint sector_fk1 foreign key(farm_id)
references farm (id) enable;


create table sector_crop
(sector_id int not null, 
 crop_id int not null,
 start_date date not null,
 end_date date,
 area int not null constraint check_area2 check (area>=0),
 constraint sector_crop_pk primary key (sector_id,crop_id,start_date) enable);

alter table sector_crop
add constraint check_end_date check(end_date>start_date) enable;

alter table sector_crop 
add constraint sector_crop_fk1 foreign key(sector_id)
references sector (id) enable;

alter table sector_crop 
add constraint sector_crop_fk2 foreign key(crop_id)
references crop (id) enable;


create table input
(id int generated always as identity not null,
 input_type_id int not null, 
 formulation_id int not null,
 supplier varchar2(30) not null,
 trade_name varchar2(30) not null,
 constraint input_pk primary key (id) enable);

alter table input 
add constraint input_fk1 foreign key(input_type_id)
references input_type (id) enable;

alter table input 
add constraint input_fk2 foreign key(formulation_id)
references formulation (id) enable;

CREATE TABLE input_restriction
(input_id INT NOT NULL,
sector_id INT NOT NULL,
input_restriction_start_date DATE NOT NULL,
input_restriction_end_date DATE NOT NULL,
CONSTRAINT input_restriction_pk PRIMARY KEY (input_id, sector_id, input_restriction_start_date),
CONSTRAINT input_id_fk FOREIGN KEY(input_id) REFERENCES input(id),
CONSTRAINT sector_id_fk FOREIGN KEY(sector_id) REFERENCES sector(id),
CONSTRAINT end_date_greater_than_start_date_check CHECK (input_restriction_end_date > input_restriction_start_date)
);

create table address
(id int generated always as identity not null,
 customer_id int not null, 
 address varchar2(50) not null,
 postal_code varchar2(7) not null,
 is_default number(1) constraint check_is_default check (is_default in(0,1)),
 constraint address_pk primary key (id) enable);
 
alter table address 
add constraint address_fk1 foreign key(customer_id)
references customer (id) enable;


create table indent
(id int generated always as identity not null,
 customer_id int not null, 
 hub_id varchar2(10),
 payment_date date,
 registration_date date not null,
 delivery_date date,
 constraint indent_pk primary key (id) enable);

alter table indent 
add constraint indent_fk1 foreign key(customer_id)
references customer (id) enable;

alter table indent 
add constraint indent_fk2 foreign key(hub_id)
references hub (id) enable;


create table indent_crop
(indent_id int not null, 
 crop_id int not null,
 amount int not null constraint check_amount check (amount>=0),
 constraint indent_crop_pk primary key (indent_id,crop_id) enable);

alter table indent_crop 
add constraint indent_crop_fk1 foreign key(indent_id)
references indent (id) enable;

alter table indent_crop 
add constraint indent_crop_fk2 foreign key(crop_id)
references crop (id) enable;


create table property
(id int generated always as identity not null,
 input_id int not null, 
 property_name varchar2(30) not null,
 unit varchar2(30) not null,
 quantity int not null constraint check_quantity1 check (quantity>=0),
 constraint property_pk primary key (id) enable);

alter table property 
add constraint property_fk1 foreign key(input_id)
references input (id) enable;


create table component
(id int generated always as identity not null,
 input_id int not null, 
 component_name varchar2(30) not null,
 unit varchar2(30) not null,
 quantity int not null constraint check_quantity2 check (quantity>=0),
 constraint component_pk primary key (id) enable);

alter table component 
add constraint component_fk1 foreign key(input_id)
references input (id) enable;


create table action
(id int generated always as identity not null,
 sector_id int not null,
 crop_id int not null,
 start_date date not null,
 planned_date date not null,
 performed_date date,
 is_canceled int DEFAULT 0 constraint check_is_canceled check (is_canceled in(0,1)),
 constraint action_pk primary key (id) enable);

alter table action 
add constraint action_fk1 foreign key(sector_id,crop_id,start_date)
references sector_crop (sector_id,crop_id,start_date) enable;


create table harvesting
(action_id int not null, 
 amount_per_hectare int constraint check_amount_per_hectare check (amount_per_hectare>=0),
 value_per_hectare int constraint check_quantity check (value_per_hectare>=0),
 constraint harvesting_pk primary key (action_id) enable);

alter table harvesting 
add constraint harvesting_fk1 foreign key(action_id)
references action (id) enable;


create table irrigation
(action_id int not null, 
 constraint irrigation_pk primary key (action_id) enable);

alter table irrigation 
add constraint irrigation_fk1 foreign key(action_id)
references action (id) enable;


create table input_related
(action_id int not null,
 input_id int not null,
 form_of_application_id int not null,
 input_related_unit VARCHAR2(20) not null,
 input_amount int not null constraint check_input_amount check (input_amount>=0),
 constraint input_related_pk primary key (action_id) enable);

alter table input_related 
add constraint input_related_fk1 foreign key(action_id)
references action (id) enable;

alter table input_related 
add constraint input_related_fk2 foreign key(input_id)
references input (id) enable;

CREATE TABLE form_of_application
(id int generated always as identity not null,
form_of_application_name varchar2(50) not null,
CONSTRAINT form_of_application_pk PRIMARY KEY (id)
);

create table input_sensor
(
    id int generated always as identity not null, 
    input_string varchar2(45)  not null,
    constraint input_sensor_pk primary key (id) enable
);

create table sensor_type
(
    id int generated always as identity not null,
    sensor_type_name varchar2(2) not null,
    constraint sensor_type_pk primary key (id) enable
);

create table sensor
(
    id varchar2(5) not null, 
    sensor_type_id int not null,
    reference_value int not null,
    caused_errors_number int DEFAULT 0,
    constraint sensor_pk primary key (id) enable
);

alter table sensor
add constraint sensor_fk1 foreign key (sensor_type_id)
references sensor_type (id) enable;

create table sensor_record
(
    sensor_id varchar2(5) not null,
    sensor_record_date date not null,
    read_value int not null,
    constraint sensor_record_pk primary key (sensor_id, sensor_record_date) enable
);

alter table sensor_record 
add constraint sensor_record_fk1 foreign key (sensor_id)
references sensor (id) enable;

create table sensor_data_reading_process
(
    id int generated always as identity not null,
    data_reading_date date not null,
    read_registers_number int not null,
    inserted_registers_number int not null,
    not_inserted_registers_number int not null,
    constraint sensor_data_reading_process_pk primary key (id) enable
);
