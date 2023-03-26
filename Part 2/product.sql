CREATE TABLE category
(
    category_id   INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE product
(
    product_id    INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    category_id   INT         NOT NULL,
    product_name  VARCHAR(255) NOT NULL,
    product_price FLOAT       NOT NULL,
    product_count INT         NOT NULL,
    CONSTRAINT FK_product_category_id FOREIGN KEY (category_id) REFERENCES category
);

INSERT INTO category(category_name)
VALUES ('Foreign books');

INSERT INTO product(category_id, product_name, product_price, product_count)
VALUES (1, 'The Little Prince', 10.00, 100);

SELECT *
FROM CATEGORY;
SELECT *
FROM PRODUCT;

