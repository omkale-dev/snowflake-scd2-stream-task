CREATE TABLE d_customer_landing (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR,
    state VARCHAR,
    is_active INT DEFAULT 1
);

CREATE TABLE d_date_landing (
    date_id INT PRIMARY KEY,
    full_date DATE,
    is_active INT DEFAULT 1
);

CREATE TABLE d_product_landing (
    product_id INT PRIMARY KEY,
    product_name VARCHAR,
    category VARCHAR,
    is_active INT DEFAULT 1
);

CREATE TABLE f_order_landing (
    order_id INT PRIMARY KEY,
    product_id INT,
    date_id INT,
    customer_id INT,
    amount DECIMAL,
    quantity INT,
    is_active INT DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES d_product(product_id),
    FOREIGN KEY (date_id) REFERENCES d_date(date_id),
    FOREIGN KEY (customer_id) REFERENCES d_customer(customer_id)
);
