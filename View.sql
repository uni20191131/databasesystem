CREATE VIEW TYPES_HIERARCHY AS (
	WITH RECURSIVE TYPES AS ( 
		SELECT id, description, parent_id, 0 AS LEVEL FROM ProductType WHERE parent_id IS NULL
		UNION ALL
		SELECT p.id, p.description, p.parent_id, t.LEVEL + 1
		FROM Types t, ProductType p
		WHERE t.id = p.parent_id
	) SELECT * FROM TYPES
);

CREATE VIEW NUM_TYPES AS (
	WITH RECURSIVE TYPES2 AS (
		SELECT id, description, parent_id, 0 AS COUNT FROM TYPES_HIERARCHY th WHERE NOT EXISTS (SELECT * FROM ProductType p WHERE th.id = p.parent_id)
		UNION ALL
		SELECT p.id, p.description, p.parent_id, (SELECT COUNT(*) FROM Product WHERE product_type = t.id) + t.COUNT AS COUNT
		FROM ProductType p, TYPES2 t
		WHERE p.id = t.parent_id
	) SELECT id, description, parent_id, (SELECT COUNT(*) FROM Product WHERE product_type = t.id) + SUM(COUNT) AS Total FROM TYPES2 t GROUP BY id ORDER BY id
);

SELECT * FROM NUM_TYPES;