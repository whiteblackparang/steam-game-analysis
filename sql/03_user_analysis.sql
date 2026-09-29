/* User Analysis */


/* User count */

SELECT COUNT(*) AS user_count
FROM user_features;


/* Average number of owned games */

SELECT AVG(products) AS avg_products
FROM user_features;


/* Average number of reviews */

SELECT AVG(reviews) AS avg_reviews
FROM user_features;


/* Users with the most games */

SELECT
    user_id,
    products
FROM user_features
ORDER BY products DESC
LIMIT 20;


/* Users with the most reviews */

SELECT
    user_id,
    reviews
FROM user_features
ORDER BY reviews DESC
LIMIT 20;

/* Review activity relative to owned games */

SELECT
    user_id,
    products,
    reviews,
    reviews_per_product
FROM user_features
WHERE products >= 10
ORDER BY reviews_per_product DESC
LIMIT 20;

/* User activity level */

SELECT
    CASE
        WHEN reviews <= 1 THEN 'Low'
        WHEN reviews <= 3 THEN 'Medium-Low'
        WHEN reviews <= 5 THEN 'Medium-High'
        ELSE 'High'
    END AS activity_level,
    COUNT(*) AS user_count,
    AVG(reviews) AS avg_reviews,
    AVG(recommend_rate) AS avg_recommend_rate,
    AVG(avg_hours) AS avg_hours
FROM user_features
GROUP BY
    CASE
        WHEN reviews <= 1 THEN 'Low'
        WHEN reviews <= 3 THEN 'Medium-Low'
        WHEN reviews <= 5 THEN 'Medium-High'
        ELSE 'High'
    END;