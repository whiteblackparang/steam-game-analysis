USE steam_analysis ;

DROP TABLE IF EXISTS users_cleaned;

CREATE TABLE users_cleaned (
    user_id BIGINT,
    products INT,
    reviews INT
) CHARACTER SET utf8mb4;

LOAD DATA LOCAL INFILE 'C:/Users/color/Desktop/steam-game-analysis/data/processed/users_cleaned.csv'
INTO TABLE users_cleaned
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS row_count
FROM users_cleaned;

DROP TABLE IF EXISTS recommendations;

CREATE TABLE recommendations (
    app_id INT,
    helpful INT,
    funny INT,
    date DATE,
    is_recommended VARCHAR(10), 
    hours DECIMAL(10,2),
    user_id BIGINT,
    review_id BIGINT
) CHARACTER SET utf8mb4;

LOAD DATA LOCAL INFILE 'C:/Users/color/Desktop/steam-game-analysis/data/raw/recommendations.csv'
INTO TABLE recommendations
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT is_recommended, COUNT(*) 
FROM recommendations 
GROUP BY is_recommended;

SELECT COUNT(*) AS row_count
FROM recommendations;

--
--
SELECT COUNT(*) AS review_count
FROM recommendations;
--
--
DROP TABLE IF EXISTS game_features;

CREATE TABLE game_features (
    app_id INT,
    title VARCHAR(255),
    date_release DATE,
    win BOOLEAN,
    mac BOOLEAN,
    linux BOOLEAN,
    rating VARCHAR(50),
    positive_ratio INT,
    user_reviews INT,
    price_final DECIMAL(10,2),
    price_original DECIMAL(10,2),
    discount DECIMAL(10,2),
    steam_deck BOOLEAN,
    rating_score INT,
    release_year INT,
    release_month INT,
    is_free BOOLEAN,
    price_change DECIMAL(10,2),
    discount_rate DECIMAL(10,4),
    platform_count INT,
    review_count INT,
    recommended_count INT,
    hours_sum DECIMAL(15,2),
    helpful_sum DECIMAL(15,2),
    funny_sum DECIMAL(15,2),
    recommend_rate DECIMAL(10,6),
    avg_hours DECIMAL(15,6),
    avg_helpful DECIMAL(15,6),
    avg_funny DECIMAL(15,6)
);

LOAD DATA LOCAL INFILE 'C:/Users/color/Desktop/steam-game-analysis/data/processed/game_features.csv'
INTO TABLE game_features
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS game_feature_count FROM game_features;

DROP TABLE IF EXISTS user_features;

CREATE TABLE user_features (
    user_id BIGINT,
    products INT,
    reviews INT,
    reviews_per_product DOUBLE,
    recommendation_count BIGINT,
    recommend_rate DOUBLE,
    avg_hours DOUBLE,
    avg_helpful DOUBLE,
    avg_funny DOUBLE
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/color/Desktop/steam-game-analysis/data/processed/user_features.csv'
INTO TABLE user_features
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS user_feature_count
FROM user_features;

SELECT *
FROM user_features
LIMIT 10;

-- SET SESSION net_read_timeout = 600;
-- SET SESSION net_write_timeout = 600;
-- SET SESSION wait_timeout = 600;

SELECT 
    AVG(CAST(NULLIF(reviews_per_product, '') AS DECIMAL(10, 4))) AS avg_value
FROM (
    SELECT reviews_per_product 
    FROM user_features 
    LIMIT 2000000
) AS sub;

USE steam_analysis;

DROP TABLE IF EXISTS user_segments;

CREATE TABLE user_segments (
    user_id BIGINT,
    cluster INT
);

-- SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/color/Desktop/steam-game-analysis/data/processed/user_segments.csv'
INTO TABLE user_segments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS segment_user_count
FROM user_segments;