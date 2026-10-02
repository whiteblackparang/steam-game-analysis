-- User Analysis / 유저 분석

-- 1. 전체 유저 수 확인 Total user count
SELECT COUNT(*) AS user_count
FROM user_features;

-- 2. Average number of owned games 유저당 평균 보유 게임 수
SELECT AVG(products) AS avg_products
FROM user_features;

-- 3. Average number of reviews 유저당 평균 리뷰 수
SELECT AVG(reviews) AS avg_reviews
FROM user_features;

-- 4. Users with the most games 게임을 가장 많이 보유한 유저 상위 20명 
SELECT
    user_id,
    products
FROM user_features
ORDER BY products DESC
LIMIT 20;

-- 5. 리뷰 가장 많이 남긴 유저 상위 20명
SELECT
    user_id,
    reviews
FROM user_features
ORDER BY reviews DESC
LIMIT 20;

-- products와 reviews_per_product에 대한 복합 인덱스 생성
CREATE INDEX idx_products_reviews 
       ON user_features(products, reviews_per_product);
     
-- DROP INDEX idx_products_reviews ON user_features;

-- 6. Review activity relative to owned games 보유 게임 수 대비 리뷰 작성 활동량 
SELECT 
    user_id,
    products,
    reviews,
    reviews_per_product
FROM (
    SELECT user_id, products, reviews, reviews_per_product
    FROM user_features
    WHERE products >= 10
) AS sub
ORDER BY reviews_per_product DESC
LIMIT 20;

-- 7. User activity level 
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