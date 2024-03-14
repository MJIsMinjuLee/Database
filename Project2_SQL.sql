--Create a table for recording audit clues
CREATE TABLE audit_clues (
    user VARCHAR2(30),
    operation VARCHAR2(20),
    date_of_change DATE,
    time_of_change TIME,
    type_of_change VARCHAR2(30),
);

alter table audit_clues
add constraint audit_clues_fk1 foreign key(user)
references customer(id) enable;
/

--Create a trigger in a way inserting the values in Audit records to maintain it
CREATE OR REPLACE TRIGGER tr_audit_clues
AFTER INSERT OR UPDATE OF CHANGE OR DELETE
ON customer, action
FOR EACH ROW
BEGIN
/
--If inserting the value in customer and action table also insert data in audit table
IF INSERTING THEN
INSERT INTO audit_clues(user, operation, date_of_change, time_of_change, type_of_change)
VALUES
(customer_id, 'insertion', sysdate, sysdate, 'action 1');
END IF;

--If updating the value in customer and action table also insert data in audit table
IF UPDATING THEN
INSERT INTO audit_clues(user, operation, date_of_change, time_of_change, type_of_change)
VALUES
(customer_id, 'updating', sysdate, sysdate, 'action 1');
END IF;

--If deleting the value in customer and action table also insert data in audit table
IF DELETING THEN
INSERT INTO audit_clues(user, operation, date_of_change, time_of_change, type_of_change)
VALUES
(customer_id, 'deleting', sysdate, sysdate, 'action 1');
END IF;

END;
/
--Inserting the record in customer and action table
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

INSERT INTO action(sector_id, crop_id, start_date, action_date)
VALUES(
        4,
        4,
        to_date('02-MAY-2021', 'DD-MON-YYYY'),
        to_date('23-SEP-2021', 'DD-MON-YYYY')
    );

COMMIT;

--Checking the data in audit table
SELECT user, operation, to_char(date_of_change, 'dd-mm-yyyy'), to_char(time_of_change, 'hh24:mm:ss'), type_of_change
FROM audit_clues
ORDER BY date_of_change;

--Checking updating operation
UPDATE action
SET start_date = start_date + 10
WHERE sector_id = 1;

SELECT user, operation, to_char(date_of_change, 'dd-mm-yyyy'), to_char(time_of_change, 'hh24:mm:ss'), type_of_change
FROM audit_clues
ORDER BY date_of_change;

--Checking deleting operation
DELETE FROM action
WHERE sector_id = 1;

SELECT user, operation, to_char(date_of_change, 'dd-mm-yyyy'), to_char(time_of_change, 'hh24:mm:ss'), type_of_change
FROM audit_clues
ORDER BY date_of_change;