DROP TABLE registered_user;

CREATE TABLE registered_user
(
    user_id      INT          NOT NULL PRIMARY KEY,
    login        VARCHAR(20)  NOT NULL,
    password     VARCHAR(20)  NOT NULL,
    first_name   VARCHAR(20)  NOT NULL,
    last_name    VARCHAR(20)  NOT NULL,
    email        VARCHAR(20)  NOT NULL,
    phone_number VARCHAR(20)  NOT NULL,
    address      VARCHAR(256) NOT NULL
);

INSERT INTO registered_user (user_id, login, password, first_name, last_name, email, phone_number, address)
VALUES (1, 'user1', 'password1', 'John', 'Doe', 'xqwerty00@gmail.com', '1234567890', '123 Main St, New York, NY 10001');

SELECT * FROM registered_user;