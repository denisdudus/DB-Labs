-- ==========================================
-- КРОК 1: Нормалізація таблиці Suppliers (1НФ)
-- ==========================================
-- Видаляємо неатомарне поле
ALTER TABLE Suppliers 
DROP COLUMN contact_info;

-- Додаємо атомарні поля
ALTER TABLE Suppliers 
ADD COLUMN email VARCHAR(255),
ADD COLUMN phone VARCHAR(50);


-- ==========================================
-- КРОК 3: Нормалізація таблиці Transactions (3НФ)
-- ==========================================
-- 1. Створюємо нову таблицю довідника співробітників
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    email VARCHAR(255)
);

-- 2. Додаємо тестових співробітників
INSERT INTO Staff (staff_id, full_name, position, email)
VALUES (1, 'Іваненко І.І.', 'Комірник', 'ivanenko@warehouse.ua'),
       (2, 'Коваленко О.В.', 'Менеджер', 'kovalenko@warehouse.ua');

-- 3. Модифікуємо таблицю транзакцій
ALTER TABLE Transactions 
DROP COLUMN responsible_person;

ALTER TABLE Transactions 
ADD COLUMN staff_id INT;

-- 4. Встановлюємо зовнішній ключ (Foreign Key)
ALTER TABLE Transactions 
ADD CONSTRAINT fk_transactions_staff
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id);

-- 5. (Опціонально) Додаємо поле для приміток
ALTER TABLE Transactions 
ADD COLUMN notes TEXT;
