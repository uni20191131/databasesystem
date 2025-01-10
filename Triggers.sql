DROP TRIGGER CreateInvoice;

# Invoice
DELIMITER $$
CREATE TRIGGER CreateInvoice
	AFTER INSERT ON OrderTable
    FOR EACH ROW
    BEGIN
		INSERT INTO Invoice(order_id) VALUES(NEW.id);
    END
$$ DELIMITER ;

DROP TRIGGER RestrictSell;

# RestrictedShop
DELIMITER $$
CREATE TRIGGER RestrictSell
	BEFORE INSERT ON Product
    FOR EACH ROW
    BEGIN
		IF NEW.product_type IN (
			SELECT DISTINCT rn.product_type
            FROM Restriction rn, RestrictedShop rs 
            WHERE rn.restricted_shop = rs.id AND rs.id = NEW.shop_id) THEN
				SIGNAL SQLSTATE '45000';
        END IF;
    END
$$ DELIMITER ;