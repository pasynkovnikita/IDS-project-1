
DROP TABLE payment;

CREATE TABLE payment
(
    payment_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    order_id     INT                              NOT NULL,
    user_id      INT                              NOT NULL,
    sum          FLOAT                            NOT NULL, -- TODO: calculate sum from order
    payment_date DATE                             NOT NULL,
    CONSTRAINT FK_payment_order FOREIGN KEY (order_id) REFERENCES "order",
    CONSTRAINT FK_payment_user FOREIGN KEY (user_id) REFERENCES registered_user
);

INSERT INTO payment (order_id, user_id, sum, payment_date)
VALUES (1, 1, 100.90, '10.10.2010');

SELECT *
FROM payment;