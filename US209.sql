--US209: As an Agricultural Manager, I want to manage the orders made by my clients.

--nessesary tables
create table customer
(id int generated always as identity not null, 
 customer_name varchar2(50)  not null,
 tax_number varchar2(20) not null constraint check_tax_number check (tax_number>=0),
 email varchar(30)  constraint email_format check (regexp_like (email, '^\w+(\.\w+)*+@\w+(\.\w+)+$')),
 credit_limit int not null constraint check_credit_limit check (credit_limit>=0),
 value_of_last_year_orders int not null constraint check_value_of_last_year_orders check (value_of_last_year_orders>=0),
 number_of_last_year_orders int not null constraint check_number_of_last_year_orders check (number_of_last_year_orders>=0),
 constraint customer_pk primary key (id) enable);

create table crop
(id int generated always as identity not null, 
 crop_name varchar2(50)  not null,
 is_permanent number(1) constraint check_is_permanent check (is_permanent in(0,1)),
 unit_value varchar2(5) not null,
 constraint crop_pk primary key (id) enable);

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
 address_id int,
 payment_day date,
 registration_date date not null,
 delivery_date date,
 constraint indent_pk primary key (id) enable);

alter table indent 
add constraint indent_fk1 foreign key(customer_id)
references customer (id) enable;

alter table indent 
add constraint indent_fk2 foreign key(address_id)
references address (id) enable;

alter table indent add status VARCHAR2(10);

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

--nessesary input
--costumers
INSERT INTO customer(
        customer_name,
        tax_number,
        email,
        credit_limit,
        value_of_last_year_orders,
        number_of_last_year_orders
    )
VALUES(
        'Camilla Customer',
        '2343578',
        'camilla.customer@email.com',
        500,
        1500,
        3
    );
INSERT INTO customer(
        customer_name,
        tax_number,
        email,
        credit_limit,
        value_of_last_year_orders,
        number_of_last_year_orders
    )
VALUES(
        'Henry Customer',
        '9765437',
        'henry.customer@email.com',
        1000,
        3000,
        6
    );
--crops 
INSERT INTO crop(crop_name, is_permanent, unit_value)
VALUES('corn', 0, 'kg');
INSERT INTO crop(crop_name, is_permanent, unit_value)
VALUES('wheat', 0, 'kg');
INSERT INTO crop(crop_name, is_permanent, unit_value)
VALUES('apple tree', 1, 'kg');
INSERT INTO crop(crop_name, is_permanent, unit_value)
VALUES('potato', 0, 'kg');
--addresses
INSERT INTO address(address, postal_code, is_default, customer_id)
VALUES('Memory Lane 4', '3487345', 1, 1);
INSERT INTO address(address, postal_code, is_default, customer_id)
VALUES('Memory Lane 5', '3487345', 0, 1);
INSERT INTO address(address, postal_code, is_default, customer_id)
VALUES('Meryl Street 54', '9876234', 1, 2);
INSERT INTO address(address, postal_code, is_default, customer_id)
VALUES('Rua da Santa Catarina 722', '4000446', 0, 2);
--indents
INSERT INTO indent( 
        customer_id, 
        address_id, 
        payment_day, 
        registration_date, 
        delivery_date 
    ) 
VALUES( 
        1, 
        5, 
        to_date('10-OCT-2022', 'DD-MON-YYYY'), 
        to_date('01-OCT-2022', 'DD-MON-YYYY'), 
        to_date('15-OCT-2022', 'DD-MON-YYYY') 
    );
INSERT INTO indent(
        customer_id,
        address_id,
        payment_day, 
        registration_date,
        delivery_date
    )
VALUES(
        1,
        5,
        to_date('10-DEC-2022', 'DD-MON-YYYY'),
        to_date('05-NOV-2022', 'DD-MON-YYYY'),
        to_date('15-DEC-2022', 'DD-MON-YYYY')
    );
INSERT INTO indent( 
        customer_id, 
        address_id, 
        payment_day,  
        registration_date, 
        delivery_date 
    ) 
VALUES( 
        1, 
        6, 
        to_date('11-NOV-2022', 'DD-MON-YYYY'), 
        to_date('05-NOV-2022', 'DD-MON-YYYY'), 
        to_date('15-NOV-2022', 'DD-MON-YYYY') 
    );

INSERT INTO indent( 
        customer_id, 
        address_id, 
        payment_day,  
        registration_date, 
        delivery_date 
    ) 
VALUES( 
        2, 
        8, 
        to_date('30-NOV-2022', 'DD-MON-YYYY'), 
        to_date('19-NOV-2022', 'DD-MON-YYYY'), 
        to_date('15-DEC-2022', 'DD-MON-YYYY') 
    );
INSERT INTO indent( 
        customer_id, 
        address_id, 
        payment_day,  
        registration_date, 
        delivery_date 
    ) 
VALUES( 
        2, 
        7, 
        to_date('27-NOV-2022', 'DD-MON-YYYY'), 
        to_date('20-NOV-2022', 'DD-MON-YYYY'), 
        to_date('20-DEC-2022', 'DD-MON-YYYY') 
    );
--indent_crop
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(21, 1, 100);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(21, 2, 40);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(22, 1, 59);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(23, 3, 23);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(23, 4, 35);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(24, 4, 45);
INSERT INTO indent_crop(indent_id, crop_id, amount)
VALUES(25, 1, 34);

--A user can register orders from a given customer (orders), requesting that delivery be made to agiven address that will be the customer's delivery address (default). However, a specific address may be indicated for each order, on a given date. 
--Check customer’s credit limit.
--found out that price is missing from indent_crop


CREATE OR REPLACE PROCEDURE p_register_order (
  p_customer_id IN indent.customer_id%TYPE,
  p_delivery_address IN VARCHAR2 DEFAULT NULL,
  p_delivery_date IN DATE DEFAULT SYSDATE
)
AS
  -- Retrieve the current credit limit and value of the customer's orders
  credit_limit NUMBER;
  value_of_last_year_orders NUMBER;
BEGIN
  SELECT credit_limit, value_of_last_year_orders
  INTO credit_limit, value_of_last_year_orders
  FROM customer
  WHERE id = p_customer_id;
  -- Check if the customer's credit limit would be exceeded by the new order
  IF value_of_last_year_orders + 1 > credit_limit THEN
    RAISE_APPLICATION_ERROR(-20000, 'Customer credit limit exceeded');
  END IF;
  -- Insert the new order into the database
  INSERT INTO indent (customer_id, delivery_date)
  VALUES (p_customer_id, p_delivery_date);
  INSERT INTO address (customer_id, address)
  VALUES (p_customer_id, p_delivery_address);
  -- Update the value of the customer's orders
  UPDATE customer
  SET value_of_last_year_orders = value_of_last_year_orders + 1
  WHERE id = p_customer_id;
END;


--for testing
BEGIN
  p_register_order(1, '123 Main St', SYSDATE + 1);
END;
--test
select * from indent;
select * from indent_crop;


--creating a new order
create or replace procedure p_create_order(
    customerP indent.customer_id%type,
    quantityP indent_crop.amount%type, 
    productP crop.id%type, 
    addressP address.id%type,
    dateP indent.registration_date%type) 
as 
    indent_id int;
BEGIN
    insert into indent(customer_id, address_id, registration_date) values (p_create_order.customerP, p_create_order.addressP, p_create_order.dateP)
    returning id into indent_id;
    insert into indent_crop(indent_id, crop_id, amount)
    values (indent_id, p_create_order.productP, p_create_order.quantityP);
end;

--to check, should be added a row with the new information in both indent and indent_order tables 
begin p_create_order(1,35, 4,5,'01-DEC-2021');
end;
--test if get default address
begin p_create_order(2,2,3,7,'01-DEC-2021');
end;
--test
select * from indent;
select * from indent_crop;



--A user can record the delivery of an order on a certain date. The order is presumed to be delivered in full; partial deliveries are not supported.
CREATE OR REPLACE PROCEDURE p_record_delivery (
  p_order_id IN indent.id%TYPE,
  p_delivery_date IN DATE DEFAULT SYSDATE
)
AS
  order_status VARCHAR2(10);
BEGIN
  -- Retrieve the current status of the order
  SELECT status
  INTO order_status
  FROM indent
  WHERE id = p_order_id;
  -- Check if the order has already been delivered
  IF order_status = 'delivered' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Order has already been delivered');
  END IF;
  -- Update the order to mark it as delivered
  UPDATE indent
  SET status = 'delivered', delivery_date = p_delivery_date
  WHERE id = p_order_id;
END;


--to check, should be added a delivery_date in indent 
BEGIN
  p_record_delivery(21, '15-OCT-22');
END;
--test
select * from indent;


--A user can register the payment of an order on a certain date.
CREATE OR REPLACE PROCEDURE p_register_payment (
  p_order_id IN indent.id%TYPE,
  p_payment_day IN DATE DEFAULT SYSDATE
)
AS
  order_status VARCHAR2(10);
BEGIN
  -- Retrieve the current status of the order
  SELECT status
  INTO order_status
  FROM indent
  WHERE id = p_order_id;
  -- Check if the order has already been paid
  IF order_status = 'paid' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Order has already been paid');
  END IF;
  -- Update the order to mark it as paid
  UPDATE indent
  SET status = 'paid', payment_day = p_payment_day
  WHERE id = p_order_id;
END;


-- To test
BEGIN
  p_register_payment(23, '11-NOV-22');
END;
select * from indent;



CREATE OR REPLACE PROCEDURE p_add_payment_date(indent_id indent.id%type, date1 indent.payment_day%type)
AS
BEGIN
     UPDATE indent set payment_day = date1 where id = indent_id;
END;

--to check, should be added a payment_date in indent 
begin p_add_payment_date(8, '01-AUG-21');
end;
--test
select * from indent;


--I can list orders by status (registered, delivered, paid) – order registration date, customer, order
-- lage statuser og sorter
-- sorter i tre lister, gi den lista med ordere som 
REGISTERd WHEN 
select * from indent
where payment_day > TO_DATE(current_date) and registration_date < TO_DATE(current_date);

paid WHEN 
select * from indent
where delivery_date > TO_DATE(current_date) and payment_day < TO_DATE(current_date);

delivered WHEN 
select * from indent
where delivery_date < TO_DATE(current_date);

--here
CREATE OR REPLACE PROCEDURE p_list_orders_by_status ( 
  p_status IN VARCHAR2) 
AS 
  CURSOR c_orders IS 
    SELECT o.registration_date, c.customer_name, o.id 
    FROM indent o 
    JOIN customer c ON c.id = o.customer_id 
    WHERE o.status = p_status 
    ORDER BY o.registration_date; 
BEGIN 
  FOR r_order IN c_orders LOOP 
    DBMS_OUTPUT.PUT_LINE(r_order.registration_date || ' ' || r_order.customer_name || ' ' || r_order.id); 
  END LOOP; 
END;

-- to test 
BEGIN
  p_list_orders_by_status('delivered');
END;



--lists orders
CREATE OR REPLACE PROCEDURE p_list_orders_by_status (
  p_status IN indent.status%TYPE
)
AS
  CURSOR c_orders IS
  SELECT
    o.registration_date,
    c.customer_name AS customer_name,
    o.id AS order_id
  FROM indent o
  INNER JOIN customer c
  ON o.customer_id = c.id
  WHERE o.status = p_status;
  v_order c_orders%ROWTYPE;
BEGIN
  -- Open the cursor
  OPEN c_orders;
  -- Fetch and process the orders
  LOOP
    FETCH c_orders INTO v_order;
    EXIT WHEN c_orders%NOTFOUND;
    -- Print the order details
    DBMS_OUTPUT.PUT_LINE(
      v_order.order_id || ': ' || v_order.customer_name ||
      ' (' || v_order.registration_date || ')'
    );
  END LOOP;
  -- Close the cursor
  CLOSE c_orders;
END;

--to TEST
BEGIN
  p_list_orders_by_status('delivered');
END;

