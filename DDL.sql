CREATE DATABASE IF NOT EXISTS lab5;
USE lab5;

CREATE TABLE IF NOT EXISTS HelpdeskInfo (
	category			VARCHAR(128)	PRIMARY	KEY,
    helpdesk_email		VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS User (
	id					INT	PRIMARY KEY	AUTO_INCREMENT,
    username 			VARCHAR(128)	UNIQUE	NOT NULL,
    email				VARCHAR(128)	UNIQUE	NOT NULL	CHECK(email LIKE '%@%.%'),
    password			VARCHAR(256)	NOT	NULL			CHECK(LENGTH(password ) >= 8),
    name				VARCHAR(128)	NOT	NULL,
    address				VARCHAR(256),
    phone_number		VARCHAR(32)							CHECK(phone_number LIKE '%-%-%'),
    category			VARCHAR(128)	NOT NULL,
    FOREIGN	KEY	(category) REFERENCES HelpdeskInfo(category)
);

CREATE TABLE IF NOT EXISTS Bank (
	bank_code			VARCHAR(32)	PRIMARY	KEY,
    bank				VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS CreditCard (
	number				INT	PRIMARY	KEY	AUTO_INCREMENT,
    bank_code			VARCHAR(32),
    expire_date			TIMESTAMP	DEFAULT	NOW(),
    user_id				INT NOT NULL,
    FOREIGN	KEY	(bank_code) REFERENCES Bank(bank_code) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Shop (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    name				VARCHAR(128)	UNIQUE	NOT	NULL
);

CREATE TABLE IF NOT EXISTS ProductType (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    description			VARCHAR(256),
    parent_id			INT,
    FOREIGN	KEY	(parent_id) REFERENCES ProductType(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Product (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    name				VARCHAR(128),
    color				VARCHAR(128),
    size				VARCHAR(32),
    price				INT,
    description			VARCHAR(256),
    shop_id				INT NOT NULL,
    product_type		INT	NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES Shop(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_type) REFERENCES ProductType(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Photo (
	id					INT,
    photo				BLOB,
    Product_id			INT NOT NULL,
    FOREIGN	KEY	(product_id) REFERENCES	Product(id),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS RestrictedShop (
	id	INT	PRIMARY	KEY	AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Restriction (
	restricted_shop		INT,
    product_type		INT,
    FOREIGN KEY (restricted_shop) REFERENCES RestrictedShop(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_type) REFERENCES ProductType(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (restricted_shop, product_type)
);

CREATE TABLE IF NOT EXISTS OrderTable (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    date				TIMESTAMP	DEFAULT	NOW(),
    status				VARCHAR(128)	DEFAULT('processing')	CHECK(status IN ('processing', 'completed', 'cancelled')),
    user_id				INT	NOT	NULL,
    FOREIGN	KEY	(user_id) REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Shipment (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    tracking_number		INT,
    date				TIMESTAMP	DEFAULT	NOW()
);

CREATE TABLE IF NOT EXISTS OrderItem (
	seq_id				INT,
    order_id			INT,
    product_id			INT,
    shipment_id			INT NOT NULL,
    unit_price			INT,
    quantity			INT,
    status				VARCHAR(128)	DEFAULT('processing')	CHECK(status IN ('processing', 'shipped', 'out of stock')),
    FOREIGN	KEY (order_id) REFERENCES OrderTable(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (shipment_id) REFERENCES Shipment(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY	KEY	(seq_id, order_id)
);

CREATE TABLE IF NOT EXISTS Invoice (
	number				INT	PRIMARY	KEY	AUTO_INCREMENT,
    status				VARCHAR(128)	DEFAULT('issued')	CHECK(status IN ('issued', 'paid')),
    date				TIMESTAMP	DEFAULT	NOW(),
    order_id			INT,
    FOREIGN	KEY	(order_id) REFERENCES OrderTable(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PaymentMethod (
	method				VARCHAR(128)	PRIMARY	KEY,
    transaction_fee		DOUBLE
);

CREATE TABLE IF NOT EXISTS PaymentID (
	id					INT	PRIMARY	KEY	AUTO_INCREMENT,
    date				TIMESTAMP	DEFAULT	NOW(),
    amount				INT,
    invoice_number		INT	NOT NULL,
    creditcard_number	INT,
    method				VARCHAR(128),
    FOREIGN	KEY (invoice_number) REFERENCES Invoice(number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (creditcard_number) REFERENCES CreditCard(number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (method) REFERENCES PaymentMethod(method) ON DELETE CASCADE ON UPDATE CASCADE
);
    









    