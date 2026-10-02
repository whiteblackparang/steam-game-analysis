/* User Segmentation */

-- Cluster size 
SELECT
    cluster,
    COUNT(*) AS user_count
FROM user_segments
GROUP BY cluster
ORDER BY cluster;

-- Cluster percentage 
SELECT
    cluster,
    COUNT(*) AS user_count,
    COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM user_segments) AS user_percentage
FROM user_segments
GROUP BY cluster
ORDER BY cluster;

-- Cluster profile 
SELECT
    s.cluster,
    COUNT(*) AS user_count,
    AVG(u.products) AS avg_products,
    AVG(u.reviews) AS avg_reviews,
    AVG(u.reviews_per_product) AS avg_reviews_per_product,
    AVG(u.recommendation_count) AS avg_recommendation_count,
    AVG(u.recommend_rate) AS avg_recommend_rate,
    AVG(u.avg_hours) AS avg_hours
FROM user_segments s
JOIN user_features u
    ON s.user_id = u.user_id
GROUP BY s.cluster
ORDER BY s.cluster;

-- Cluster activity level 
SELECT
    s.cluster,
    CASE
        WHEN u.reviews <= 1 THEN 'Low'
        WHEN u.reviews <= 3 THEN 'Medium-Low'
        WHEN u.reviews <= 5 THEN 'Medium-High'
        ELSE 'High'
    END AS activity_level,
    COUNT(*) AS user_count
FROM user_segments s
JOIN user_features u
    ON s.user_id = u.user_id
GROUP BY
    s.cluster,
    CASE
        WHEN u.reviews <= 1 THEN 'Low'
        WHEN u.reviews <= 3 THEN 'Medium-Low'
        WHEN u.reviews <= 5 THEN 'Medium-High'
        ELSE 'High'
    END
ORDER BY
    s.cluster,
    user_count DESC;

-- Cluster recommendation level 
SELECT
    s.cluster,
    CASE
        WHEN u.recommend_rate < 0.5 THEN 'Low'
        WHEN u.recommend_rate < 0.8 THEN 'Medium'
        ELSE 'High'
    END AS recommendation_level,
    COUNT(*) AS user_count
FROM user_segments s
JOIN user_features u
    ON s.user_id = u.user_id
GROUP BY
    s.cluster,
    CASE
        WHEN u.recommend_rate < 0.5 THEN 'Low'
        WHEN u.recommend_rate < 0.8 THEN 'Medium'
        ELSE 'High'
    END
ORDER BY
    s.cluster,
    user_count DESC;

-- Cluster statistics 
SELECT
    s.cluster,
    MIN(u.products) AS min_products,
    AVG(u.products) AS avg_products,
    MAX(u.products) AS max_products,
    MIN(u.reviews) AS min_reviews,
    AVG(u.reviews) AS avg_reviews,
    MAX(u.reviews) AS max_reviews,
    AVG(u.recommend_rate) AS avg_recommend_rate,
    AVG(u.avg_hours) AS avg_hours
FROM user_segments s
JOIN user_features u
    ON s.user_id = u.user_id
GROUP BY s.cluster
ORDER BY s.cluster;