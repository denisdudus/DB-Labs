CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    category_id INT,
    manufacturer VARCHAR(100),
    model_name VARCHAR(255),
    specifications TEXT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    zone VARCHAR(50),
    rack VARCHAR(50),
    shelf VARCHAR(50)
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_info TEXT
);

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    product_id INT,
    serial_number VARCHAR(100) UNIQUE,
    location_id INT,
    supplier_id INT,
    status VARCHAR(50),
    warranty_end DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    item_id INT,
    transaction_type VARCHAR(50),
    created_at TIMESTAMP,
    responsible_person VARCHAR(255),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);