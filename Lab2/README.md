# Лабораторна робота №2

## Вимоги
**Мета:** Перетворити концептуальну ER-модель на фізичну реляційну схему бази даних. Написати SQL DDL-інструкції для створення таблиць, визначити типи даних, налаштувати зв'язки (зовнішні ключі) та обмеження цілісності даних (PRIMARY KEY, UNIQUE, FOREIGN KEY), а також заповнити базу тестовими даними.

## Опис схеми та технічні рішення
Кожна сутність з нашої ER-діаграми була перетворена на відповідну таблицю бази даних.

1. **Базові таблиці-довідники:**
   - `Categories`: Зберігає типи комп'ютерної техніки (наприклад, ноутбуки, відеокарти).
   - `Products`: Довідник конкретних моделей техніки. Пов'язаний з категорією через зовнішній ключ (`FOREIGN KEY`).
   - `Locations` та `Suppliers`: Зберігають фізичні адреси полиць на складі та контактні дані компаній-постачальників відповідно.

2. **Таблиці екземплярів (динамічні дані):**
   - `Items`: Представляє конкретну фізичну одиницю техніки на складі. Включає обмеження `UNIQUE` для атрибута `serial_number`, щоб унеможливити існування двох різних товарів з однаковим штрих-кодом/серійником. Зв'язує разом модель (`product_id`), місце (`location_id`) та постачальника (`supplier_id`).
   - `Transactions`: Логує всі операції (прийом, відвантаження, переміщення). Фіксує точний час дії (`TIMESTAMP`) та відповідальну особу.

3. **Реалізація зв'язків "Один-до-багатьох" (1:N):**
   - Архітектура системи побудована навколо зв'язків 1:N. Наприклад, одна загальна модель материнської плати (`Products`) може мати сотні фізичних копій на складі (`Items`), і кожна така фізична одиниця має власну детальну історію переміщень (`Transactions`).

## SQL код
```sql
-- SQL table for categories of equipment
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

-- SQL table for product models, with reference to Category
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    category_id INT,
    manufacturer VARCHAR(100),
    model_name VARCHAR(255),
    specifications TEXT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- SQL table for physical warehouse locations
CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    zone VARCHAR(50),
    rack VARCHAR(50),
    shelf VARCHAR(50)
);

-- SQL table for equipment suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_info TEXT
);

-- SQL table for physical items in stock, with unique serial numbers and multiple FKs
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

-- SQL table for logging movements and operations with items
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    item_id INT,
    transaction_type VARCHAR(50),
    created_at TIMESTAMP,
    responsible_person VARCHAR(255),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

-- Insertion of dummy data into reference tables
INSERT INTO Categories (category_id, name, description) 
VALUES (1, 'Відеокарти', 'Графічні прискорювачі'),
       (2, 'Процесори', 'Центральні процесори (CPU)');

INSERT INTO Products (product_id, category_id, manufacturer, model_name, specifications) 
VALUES (1, 1, 'NVIDIA', 'GeForce RTX 4090', 'VRAM: 24GB'),
       (2, 2, 'AMD', 'Ryzen 9 7950X', '16 Cores, 32 Threads');

INSERT INTO Locations (location_id, zone, rack, shelf) 
VALUES (1, 'Зона А (Дороговартісне)', 'Стелаж 1', 'Полиця 2');

INSERT INTO Suppliers (supplier_id, name, contact_info) 
VALUES (1, 'ТОВ "ТехноДром"', 'info@technodrom.ua');

-- Insertion of physical items and their initial transactions
INSERT INTO Items (item_id, product_id, serial_number, location_id, supplier_id, status, warranty_end) 
VALUES (1, 1, 'NV4090-8877665544', 1, 1, 'На складі', '2026-12-31');

INSERT INTO Transactions (transaction_id, item_id, transaction_type, created_at, responsible_person) 
VALUES (1, 1, 'Прийом на склад', '2024-05-10 10:00:00', 'Коваленко О.В.');
