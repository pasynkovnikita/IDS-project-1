CREATE TABLE registered_user
(
    user_id      INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    login        VARCHAR(20)                      NOT NULL,
    password     VARCHAR(20)                      NOT NULL,
    first_name   VARCHAR(20)                      NOT NULL,
    last_name    VARCHAR(20)                      NOT NULL,
    email        VARCHAR(20)                      NOT NULL,
    phone_number VARCHAR(20)                      NOT NULL,
    address      VARCHAR(256)                     NOT NULL,
    CONSTRAINT length_password CHECK (length(password) between 8 and 20),
    CONSTRAINT email_validation CHECK (REGEXP_LIKE(email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
    CONSTRAINT phone_number_check CHECK (REGEXP_LIKE(phone_number, '^\+?[0-9]{11,13}$'))
);

CREATE TABLE employee
(
    employee INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY

);

INSERT INTO registered_user (login, password, first_name, last_name, email, phone_number, address)
VALUES ('user1', 'password1', 'John', 'Doe', 'xqwerty00@gmail.com', '79999210755',
        '123 Main St, New York, NY 10001');

SELECT *
FROM registered_user;