DROP TABLE "order";

CREATE TABLE "order"
(
    order_id   INT          NOT NULL PRIMARY KEY,
    address    VARCHAR(255) NOT NULL,
    status     VARCHAR(20)  NOT NULL,
    order_date DATE         NOT NULL,
    user_id    INT          NOT NULL,
    CONSTRAINT FK_order_user_id FOREIGN KEY (user_id) REFERENCES REGISTERED_USER
);


INSERT INTO "order" (order_id, address, status, order_date, user_id)
VALUES (1, '123 Main St', 'pending', '01.01.2019', 1);

SELECT * FROM "order";