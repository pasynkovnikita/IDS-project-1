DROP TABLE product;
DROP TABLE category;

CREATE TABLE category
(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE product
(
    product_id INT PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    product_price FLOAT NOT NULL,
    product_count INT NOT NULL,
    CONSTRAINT FK_product_category_id FOREIGN KEY (category_id) REFERENCES category
);

INSERT INTO category(category_id, category_name)
VALUES(1, 'Foreign books');

INSERT INTO product(product_id, category_id, product_name, product_price, product_count)
VALUES(1, 1, 'The Little Prince', 10.00, 100);

SELECT * FROM CATEGORY;
SELECT * FROM PRODUCT;

