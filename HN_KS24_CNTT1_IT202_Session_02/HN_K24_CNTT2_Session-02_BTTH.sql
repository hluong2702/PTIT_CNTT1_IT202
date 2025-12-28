CREATE database BTTH;
USE BTTH;

CREATE TABLE Customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE table Account(
	id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL CHECK (balance >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    customer_id INT NOT NULL
);

CREATE table Partner(
	id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL
);

CREATE table TuitionBill(
	id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
    partner_id INT NOT NULL
);

CREATE table Transaction(
	id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    transaction_type VARCHAR(20) NOT NULL DEFAULT 'TUITION_PAYMENT',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    account_id INT NOT NULL,
    bill_id INT NOT NULL UNIQUE
);

ALTER TABLE Account
ADD CONSTRAINT fk_account_customer
FOREIGN KEY (customer_id)
REFERENCES Customer(id);

ALTER TABLE TuitionBill
ADD CONSTRAINT fk_tuitionbill_partner
FOREIGN KEY (partner_id)
REFERENCES Partner(id);

ALTER TABLE Transaction
ADD CONSTRAINT fk_transaction_account
FOREIGN KEY (account_id)
REFERENCES Account(id);

ALTER TABLE Transaction
ADD CONSTRAINT fk_transaction_bill
FOREIGN KEY (bill_id)
REFERENCES TuitionBill(id);
