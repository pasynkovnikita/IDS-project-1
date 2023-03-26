DROP TABLE registered_user;

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
    CONSTRAINT phone_number_check CHECK (REGEXP_LIKE(phone_number, '^\+?[0-9]{11,13}$'))
);

INSERT INTO registered_user (user_id, login, password, first_name, last_name, email, phone_number, address)
VALUES (1, 'user1', 'password1', 'John', 'Doe', 'xqwerty00@gmail.com', '79999210755', '123 Main St, New York, NY 10001');

SELECT * FROM registered_user;