use lab5;

# 쇼핑몰처럼 하위 타입들 확인하는 기능
WITH RECURSIVE TYPES AS ( 
    SELECT id, description, parent_id, 0 AS LEVEL FROM ProductType WHERE parent_id IS NULL
    UNION ALL
    SELECT p.id, p.description, p.parent_id, t.LEVEL + 1
    FROM Types t, ProductType p
    WHERE t.id = p.parent_id
), TYPES2 AS (
	SELECT id, description, parent_id, 0 AS COUNT FROM TYPES tt WHERE NOT EXISTS (SELECT * FROM ProductType pp WHERE tt.id = pp.parent_id)
    UNION ALL
    SELECT p.id, p.description, p.parent_id, (SELECT COUNT(*) FROM Product WHERE product_type = t.id) + t.COUNT AS COUNT
    FROM ProductType p, TYPES2 t
    WHERE p.id = t.parent_id
) SELECT id, description, parent_id, (SELECT COUNT(*) FROM Product WHERE product_type = t.id) + SUM(COUNT) AS Total FROM TYPES2 t GROUP BY id ORDER BY id;


# 유저가 배송이 언제오는지 확인하고싶을때
SELECT username, order_id, prod.name as ProductName, quantity, ord.status as OrderStatus, item.status as ItemStatus, ship.date
	FROM OrderTable ord, User usr, OrderItem item, Product prod, Shipment ship
    WHERE ord.user_id = usr.id AND item.order_id = ord.id AND item.product_id = prod.id AND item.shipment_id = ship.id AND usr.id = 1 ORDER BY ord.id;

# product를 누를때 사진과 product 정보 보기
SELECT p.name as ProductName, s.name as ShopName, price FROM Product p, Shop s WHERE p.shop_id = s.id;

# order로 결제 총액 확인 Transaction_fee 고려
SELECT usr.username, ord.id as orderId, (pi.amount * (1 + pm.transaction_fee)) as Paid, pi.method, pi.date 
	FROM User usr, OrderTable ord, Invoice inv, PaymentId pi, PaymentMethod pm
	WHERE ord.user_id = usr.id AND inv.order_id = ord.id AND pi.invoice_number = inv.number 
	AND pi.method = pm.method AND inv.status = 'paid' AND pi.date >= DATE_SUB(NOW(), INTERVAL 6 MONTH);
