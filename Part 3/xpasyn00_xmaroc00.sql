-- DROP TABLE "user" CASCADE CONSTRAINTS;
-- DROP TABLE employee CASCADE CONSTRAINTS ;
-- DROP TABLE registered_user CASCADE CONSTRAINTS;
-- DROP TABLE "order" CASCADE CONSTRAINTS;
-- DROP TABLE category CASCADE CONSTRAINTS ;
-- DROP TABLE product CASCADE CONSTRAINTS ;
-- DROP TABLE contains CASCADE CONSTRAINTS;
-- DROP TABLE payment CASCADE CONSTRAINTS;

-- alter date because of some error with date input we could not solve
ALTER SESSION SET NLS_DATE_FORMAT = 'dd.mm.yyyy';

-- user has user_id as a primary key, which is a foreign key for employee and registered_user
-- user has type attribute, which shows if the user is an employee or a registered_user
-- employee and registered_user are specializations of user
CREATE TABLE "user"
(
    user_id INT GENERATED AS IDENTITY PRIMARY KEY,
    type    VARCHAR(20) NOT NULL CHECK (type IN ('registered_user', 'employee'))
);

CREATE TABLE employee
(
    employee_id INT         NOT NULL PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(20) NOT NULL,
    -- employee is a specialization of user
    CONSTRAINT FK_employee_id FOREIGN KEY (employee_id) REFERENCES "user" (user_id)
);

CREATE TABLE registered_user
(
    user_id      INT          NOT NULL PRIMARY KEY,
    login        VARCHAR(20)  NOT NULL,
    password     VARCHAR(20)  NOT NULL,
    first_name   VARCHAR(20)  NOT NULL,
    last_name    VARCHAR(20)  NOT NULL,
    email        VARCHAR(20)  NOT NULL,
    phone_number VARCHAR(20)  NOT NULL,
    address      VARCHAR(256) NOT NULL,
--     check if password is longer than 8 symbols and shorter than 20
    CONSTRAINT length_password CHECK (length(password) between 8 and 20),
--     validate email
    CONSTRAINT email_validation CHECK (REGEXP_LIKE(email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
--    validate phone number
    CONSTRAINT phone_number_check CHECK (REGEXP_LIKE(phone_number, '^\+?[0-9]{11,13}$')),
    -- registered_user is a specialization of user
    CONSTRAINT FK_user_id FOREIGN KEY (user_id) REFERENCES "user" (user_id)
);

-- procedure for creating an employee
create or replace procedure create_employee(
    ins_first_name varchar2,
    ins_last_name varchar2
)
as
    genUserId INT;
begin
    INSERT INTO "user" (type)
    VALUES ('employee')
    RETURNING user_id INTO genUserId;

    INSERT INTO employee (employee_id, first_name, last_name)
    VALUES (genUserId, ins_first_name, ins_last_name);
end;

-- procedure for creating a registered user
create or replace procedure create_registered_user(
    ins_login varchar2,
    ins_password varchar2,
    ins_first_name varchar2,
    ins_last_name varchar2,
    ins_email varchar2,
    ins_phone_number varchar2,
    ins_address varchar2
)
as
    genUserId INT;
begin
    INSERT INTO "user" (type)
    VALUES ('registered_user')
    RETURNING user_id INTO genUserId;

    INSERT INTO registered_user (user_id, login, password, first_name, last_name, email, phone_number, address)
    VALUES (genUserId, ins_login, ins_password, ins_first_name, ins_last_name, ins_email, ins_phone_number,
            ins_address);
end;

call create_registered_user('xpasyn00', 'qwerty12345', 'Nikita', 'Pasynkov', 'xpasyn00@fit.cz', '+420777777777',
                            'Brno');
call create_registered_user('xmaroc00', '1235qwerty', 'Lena', 'Marochkina', 'xmaroc00@fit.cz', '+420774555555',
                            'Prague');
call create_registered_user('xnovak00', '1235sdfghjk', 'Jan', 'Novak', 'jan.novak@gmail.com', '+420774555555',
                            'Brno');
call create_registered_user('princ89', '79swfdghj', 'Petr', 'Princ', 'petr.pronc@mail.cz', '+420774555555',
                            'Prague');

call create_employee('John', 'Doe');
call create_employee('Nick', 'Kowalsky');

CREATE TABLE "order"
(
    order_id    INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    address     VARCHAR(255)                     NOT NULL,
    status      VARCHAR(20) DEFAULT ('created') CHECK (status IN ('created', 'paid', 'shipped', 'cancelled')),
    order_date  DATE                             NOT NULL,
    user_id     INT                              NOT NULL,
    -- expeduje objednavku
    employee_id INT                              NOT NULL,
    CONSTRAINT FK_order_user_id FOREIGN KEY (user_id) REFERENCES registered_user,
    CONSTRAINT FK_order_employee_id FOREIGN KEY (employee_id) REFERENCES employee
);

-- procedure for creating order
create or replace procedure create_order(
    ins_address varchar2,
    ins_order_date date,
    ins_user_id int
) as
    random_employee_id int;
begin
    --     get random employee to expedite the order
    select employee_id
    into random_employee_id
    from employee
    order by dbms_random.value
        fetch first 1 rows only;

    INSERT INTO "order" (address, order_date, user_id, employee_id)
    VALUES (ins_address, ins_order_date, ins_user_id, random_employee_id);
end;

-- add an order
call create_order('Brno', '01.01.2023', 1);
call create_order('Prague', '03.05.2023', 1);
call create_order('Prague', '01.01.2023', 2);
call create_order('Brno', '01.01.2020', 1);
call create_order('Brno', '01.01.2019', 1);
call create_order('Olomouc', '01.01.2023', 1);
call create_order('Brno', '01.01.2020', 3);
call create_order('Praha', '01.08.2023', 3);
call create_order('Brno', '01.01.2023', 4);
call create_order('Pardubice', '01.01.2023', 4);

create or replace procedure change_order_state(
    ins_order_id int,
    ins_status varchar2
) as
begin
    if ins_status in ('paid', 'shipped', 'cancelled') then
        update "order"
        set status = ins_status
        where order_id = ins_order_id;
    else
        raise_application_error(-20000, 'Invalid status');
    end if;
end;

CREATE TABLE category
(
    category_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_name VARCHAR(255) UNIQUE              NOT NULL
);

-- procedure for creating product category
create or replace procedure create_category(
    ins_category_name varchar2
) as
begin
    INSERT INTO category (category_name)
    VALUES (ins_category_name);
end;

call create_category('magazines');
call create_category('foreign-books');
call create_category('domestic-books');
call create_category('culture');
call create_category('sport');

CREATE TABLE product
(
    product_id    INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_id   INT                              NOT NULL,
    product_name  VARCHAR(255) UNIQUE              NOT NULL,
    product_price FLOAT                            NOT NULL,
    product_count INT                              NOT NULL,
    CONSTRAINT FK_product_category_id FOREIGN KEY (category_id) REFERENCES category
);

create or replace procedure create_product(
    ins_category_name varchar2,
    ins_product_name varchar2,
    ins_product_price float,
    ins_product_count int
) as
    CategoryId    INT;
    CategoryCount INT; -- check if category already exists
    ProductCount  INT; -- check if product already exists
begin
    --     check for existing category
    SELECT COUNT(*) into CategoryCount FROM category WHERE category_name = ins_category_name;

    IF CategoryCount = 0 THEN
        insert into category (category_name) values (ins_category_name);
    END IF;

--     check for existing product
    SELECT COUNT(*) into ProductCount FROM product WHERE product_name = ins_product_name;

    IF ProductCount = 0 THEN
        SELECT category_id
        INTO CategoryId
        FROM category
        WHERE category_name = ins_category_name; -- get category id by its name

        INSERT INTO product (category_id, product_name, product_price, product_count)
        VALUES (CategoryId, ins_product_name, ins_product_price, ins_product_count);
    END IF;

end;

-- add products
call create_product('foreign-books', 'Harry Potter', 100, 10);
call create_product('magazines', 'National Geographic', 50, 50);
call create_product('foreign-books', 'Lord of the Rings', 200, 20);
call create_product('classics', 'Smrt krasnych srncu', 200, 20);
call create_product('foreign-books', 'The Hitchhiking Guide to Galaxy', 200, 20);
call create_product('culture', 'Ancient Egypt', 500, 80);
call create_product('culture', 'Ancient Greece', 400, 80);
call create_product('sport', 'Football', 300, 10);
call create_product('sport', 'Basketball', 200, 10);

CREATE TABLE contains
(
    product_id            INT NOT NULL,
    order_id              INT NOT NULL,
    product_count_ordered INT NOT NULL,
    CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES product (product_id),
    CONSTRAINT FK_order_id FOREIGN KEY (order_id) REFERENCES "order" (order_id)
);

create or replace procedure add_product_to_order(
    ins_product_name varchar2,
    ins_order_id int,
    ins_product_count_ordered int
) as
    ProductId int;
begin
    SELECT product_id
    INTO ProductId
    FROM product
    WHERE product_name = ins_product_name;

    INSERT INTO contains (product_id, order_id, product_count_ordered)
    VALUES (ProductId, ins_order_id, ins_product_count_ordered);

end;

-- contain table to link order and products
call add_product_to_order('Harry Potter', 1, 1);
call add_product_to_order('Lord of the Rings', 1, 2);
call add_product_to_order('The Hitchhiking Guide to Galaxy', 2, 3);
call add_product_to_order('National Geographic', 2, 1);
call add_product_to_order('Lord of the Rings', 2, 3);

call add_product_to_order('National Geographic', 3, 1);
call add_product_to_order('Lord of the Rings', 3, 2);

call add_product_to_order('Ancient Egypt', 4, 2);
call add_product_to_order('Ancient Greece', 4, 1);

call add_product_to_order('Harry Potter', 5, 1);
call add_product_to_order('Lord of the Rings', 5, 2);

call add_product_to_order('Football', 6, 3);
call add_product_to_order('Basketball', 7, 3);
call add_product_to_order('Football', 8, 3);
call add_product_to_order('Basketball', 9, 3);
call add_product_to_order('Football', 10, 3);

CREATE TABLE payment
(
    payment_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    order_id     INT                              NOT NULL,
    user_id      INT                              NOT NULL,
    sum          FLOAT                            NOT NULL,
    payment_date DATE                             NOT NULL,
    CONSTRAINT FK_payment_order FOREIGN KEY (order_id) REFERENCES "order",
    CONSTRAINT FK_payment_user FOREIGN KEY (user_id) REFERENCES registered_user
);

create or replace procedure create_payment(
    ins_order_id int,
    ins_user_id int,
    ins_sum float,
    ins_payment_date date
) as
    ORDERCOUNT INT;
begin
    -- check if order exists before create payment
    SELECT COUNT(*) into ORDERCOUNT FROM "order" WHERE order_id = ins_order_id;
    IF ORDERCOUNT = 0 THEN
        raise_application_error(-20000, 'Order does not exist');
    END IF;
-- change order status to paid
    UPDATE "order"
    SET "order".status = 'paid'
    WHERE order_id = ins_order_id;

    INSERT INTO payment (order_id, user_id, sum, payment_date)
    VALUES (ins_order_id, ins_user_id, ins_sum, ins_payment_date);
end;

-- add a payment for the order
call create_payment(2, 1, 350, '03.05.2023');
call create_payment(2, 1, 350, '03.05.2023');
call create_payment(5, 1, 500, '03.05.2023');
call create_payment(8, 1, 900, '03.05.2023');
call create_payment(9, 1, 600, '03.05.2023');


call change_order_state(2, 'shipped');
call change_order_state(5, 'shipped');
call change_order_state(9, 'shipped');

call change_order_state(3, 'cancelled');
call change_order_state(4, 'cancelled');


-- dva dotazy využívající spojení dvou tabulek
-- join product and category to show products and their categories
SELECT product_name, category_name, product_price, product_count
FROM product
         LEFT JOIN category ON product.category_id = category.category_id;

-- join order and user tables to show users with their respective orders from Brno
SELECT login, first_name, last_name, email, order_id, status, order_date
FROM registered_user
         LEFT JOIN "order" ON registered_user.user_id = "order".user_id
WHERE registered_user.address = 'Brno';

-- jeden využívající spojení tří tabulek
-- show orders with products and their prices - join order, contains and product tables
SELECT "order".order_id, product_name, product_count_ordered, product_price
FROM "order"
         LEFT JOIN contains ON "order".order_id = contains.order_id
         LEFT JOIN product ON contains.product_id = product.product_id
ORDER BY order_id;

-- dva dotazy s klauzulí GROUP BY a agregační funkcí
-- show most popular products that were shipped
SELECT product_name, SUM(product_count_ordered) AS products_delivered
FROM product
         LEFT JOIN contains ON product.product_id = contains.product_id
         left join "order" on contains.order_id = "order".order_id
WHERE "order".status = 'shipped'
GROUP BY product_count_ordered, product_name
ORDER BY product_count_ordered DESC;

-- show users most expensive orders that were ordered and payed from Brno after 2019
SELECT user_id, "order".order_id, SUM(product_price * product_count_ordered) AS order_price
FROM "order"
         LEFT JOIN contains ON "order".order_id = contains.order_id
         LEFT JOIN product ON contains.product_id = product.product_id
WHERE order_date >= '01.01.2019'
  AND "order".address = 'Brno'
  AND EXISTS(SELECT *
             FROM payment
             WHERE payment.order_id = "order".order_id)
GROUP BY user_id, "order".order_id
ORDER BY order_price DESC;

--  jeden dotaz obsahující predikát EXISTS
-- show users who ordered in the year 2020
SELECT login, first_name, last_name, email
FROM registered_user
WHERE EXISTS(SELECT *
             FROM "order"
             WHERE "order".user_id = registered_user.user_id
               AND EXTRACT(YEAR FROM order_date) = 2020);

-- jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat)
-- show users who ordered products from the category 'foreign-books'
SELECT login, first_name, last_name, email
FROM registered_user
WHERE user_id IN (SELECT user_id
                  FROM "order"
                           LEFT JOIN contains ON "order".order_id = contains.order_id
                           LEFT JOIN product ON contains.product_id = product.product_id
                           LEFT JOIN category ON product.category_id = category.category_id
                  WHERE category_name = 'foreign-books');

