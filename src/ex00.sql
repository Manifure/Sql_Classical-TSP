CREATE TABLE routes (
    node1 VARCHAR,
    node2 VARCHAR,
    cost INTEGER
);

INSERT INTO routes
VALUES
    ('a', 'b', 10), ('b', 'a', 10), ('a', 'c', 15), ('c', 'a', 15),
    ('a', 'd', 20), ('d', 'a', 20), ('d', 'b', 25), ('b', 'd', 25),
    ('d', 'c', 30), ('c', 'd', 30), ('c', 'b', 35), ('b', 'c', 35);



WITH RECURSIVE city_a AS (
    SELECT
        cost AS total_cost,
        node1 AS path,
        node1,
        node2
    FROM routes WHERE node1 = 'a'

    UNION ALL

    SELECT
        parent.total_cost + child.cost,
        CONCAT(parent.path, ',', child.node1),
        child.node1,
        child.node2
    FROM routes AS child
    INNER JOIN city_a AS parent ON child.node1 = parent.node2
    WHERE path NOT LIKE CONCAT('%', child.node1, '%')
)
SELECT total_cost, CONCAT('{', path, ',', node2, '}') AS tour
FROM city_a
WHERE node2 = 'a'
    AND LENGTH(path) = 7
    AND total_cost = (
        SELECT MIN(total_cost)
        FROM city_a
        WHERE LENGTH(path) = 7 AND node2 = 'a'
    )
ORDER BY total_cost, path;