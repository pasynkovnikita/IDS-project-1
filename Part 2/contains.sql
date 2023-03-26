CREATE TABLE contains (
    product_id INT NOT NULL,
    order_id INT NOT NULL,
    product_count INT NOT NULL,
    CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES product (product_id),
    CONSTRAINT FK_order_id FOREIGN KEY (order_id) REFERENCES "order" (order_id)
)

