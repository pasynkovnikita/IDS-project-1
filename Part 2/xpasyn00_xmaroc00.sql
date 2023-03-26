-- DROP TABLE "user" CASCADE CONSTRAINTS;
-- DROP TABLE employee CASCADE CONSTRAINTS ;
-- DROP TABLE registered_user CASCADE CONSTRAINTS;
-- DROP TABLE "order";
-- DROP TABLE category;
-- DROP TABLE product;
-- DROP TABLE contains;
-- DROP TABLE payment;

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

-- First, we have to create tables for users
INSERT INTO "user" (type)
VALUES ('registered_user');
INSERT INTO registered_user (user_id, login, password, first_name, last_name, email, phone_number, address)
VALUES (1, 'xpasyn00', 'qwerty12345', 'Nikita', 'Pasynkov', 'xpasyn00@fit.cz', '+420777777777', 'Brno 1');

INSERT INTO "user" (type)
VALUES ('employee');
INSERT INTO employee (employee_id, first_name, last_name)
VALUES (2, 'John', 'Doe');

CREATE TABLE "order"
(
    order_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    address    VARCHAR(255)                     NOT NULL,
    status     VARCHAR(20)                      NOT NULL CHECK (status IN ('created', 'paid', 'shipped', 'cancelled')),
    order_date DATE                             NOT NULL,
    user_id    INT                              NOT NULL,
    CONSTRAINT FK_order_user_id FOREIGN KEY (user_id) REFERENCES registered_user
);

-- add an order
INSERT INTO "order" (address, status, order_date, user_id)
VALUES ('Brno 1', 'shipped', '01.01.2023', 1);
INSERT INTO "order" (address, status, order_date, user_id)
VALUES ('Brno 1', 'created', '03.05.2023', 1);

CREATE TABLE category
(
    category_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_name VARCHAR(255)                     NOT NULL
);

-- add a category before adding products
INSERT INTO category (category_name)
VALUES ('foreign-books');
INSERT INTO category (category_name)
VALUES ('magazines');

CREATE TABLE product
(
    product_id    INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_id   INT                              NOT NULL,
    product_name  VARCHAR(255)                     NOT NULL,
    product_price FLOAT                            NOT NULL,
    product_count INT                              NOT NULL,
    CONSTRAINT FK_product_category_id FOREIGN KEY (category_id) REFERENCES category
);

-- add products
INSERT INTO product (category_id, product_name, product_price, product_count)
VALUES (1, 'Harry Potter', 100, 10);
INSERT INTO product (category_id, product_name, product_price, product_count)
VALUES (1, 'Lord of the Rings', 200, 20);
INSERT INTO product (category_id, product_name, product_price, product_count)
VALUES (2, 'National Geographic', 50, 50);

CREATE TABLE contains
(
    product_id    INT NOT NULL,
    order_id      INT NOT NULL,
    product_count INT NOT NULL,
    CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES product (product_id),
    CONSTRAINT FK_order_id FOREIGN KEY (order_id) REFERENCES "order" (order_id)
);

-- contain table to link order and products
INSERT INTO contains (product_id, order_id, product_count)
VALUES (1, 1, 1);
INSERT INTO contains (product_id, order_id, product_count)
VALUES (2, 1, 2);
INSERT INTO contains (product_id, order_id, product_count)
VALUES (3, 2, 3);

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

-- add a payment for the order
INSERT INTO payment (order_id, user_id, sum, payment_date)
VALUES (1, 1, 350, '01.01.2023');

-- show the created data
SELECT *
FROM "user";

SELECT *
FROM employee;

SELECT *
FROM registered_user;

SELECT *
FROM "order";

SELECT *
FROM category;

SELECT *
FROM product;

SELECT *
FROM contains;

SELECT *
FROM payment;
