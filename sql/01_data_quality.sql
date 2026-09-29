/* Data Quality Check */


/* Row count */

SELECT COUNT(*) AS game_count
FROM games_cleaned;

SELECT COUNT(*) AS user_count
FROM users_cleaned;

SELECT COUNT(*) AS recommendation_count
FROM recommendations;


/* Missing values */

SELECT
    SUM(CASE WHEN app_id IS NULL THEN 1 ELSE 0 END) AS missing_app_id,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS missing_title,
    SUM(CASE WHEN date_release IS NULL THEN 1 ELSE 0 END) AS missing_date_release,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS missing_rating,
    SUM(CASE WHEN positive_ratio IS NULL THEN 1 ELSE 0 END) AS missing_positive_ratio,
    SUM(CASE WHEN price_final IS NULL THEN 1 ELSE 0 END) AS missing_price_final
FROM games_cleaned;

SELECT
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN products IS NULL THEN 1 ELSE 0 END) AS missing_products,
    SUM(CASE WHEN reviews IS NULL THEN 1 ELSE 0 END) AS missing_reviews
FROM users_cleaned;

SELECT
    SUM(CASE WHEN app_id IS NULL THEN 1 ELSE 0 END) AS missing_app_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS missing_review_id,
    SUM(CASE WHEN hours IS NULL THEN 1 ELSE 0 END) AS missing_hours,
    SUM(CASE WHEN is_recommended IS NULL THEN 1 ELSE 0 END) AS missing_recommendation
FROM recommendations;


/* Duplicate IDs */

SELECT
    app_id,
    COUNT(*) AS duplicate_count
FROM games_cleaned
GROUP BY app_id
HAVING COUNT(*) > 1;

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM users_cleaned
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM recommendations
GROUP BY review_id
HAVING COUNT(*) > 1;


/* Value checks */

SELECT COUNT(*) AS invalid_price_count
FROM games_cleaned
WHERE price_final < 0
   OR price_original < 0;

SELECT COUNT(*) AS invalid_discount_count
FROM games_cleaned
WHERE discount < 0
   OR discount > 100;

SELECT
    is_recommended,
    COUNT(*) AS review_count
FROM recommendations
GROUP BY is_recommended;

SELECT COUNT(*) AS invalid_hours_count
FROM recommendations
WHERE hours < 0;


/* Table relationship */

SELECT COUNT(*) AS games_without_reviews
FROM games_cleaned g
LEFT JOIN recommendations r
    ON g.app_id = r.app_id
WHERE r.app_id IS NULL;

SELECT COUNT(*) AS recommendations_without_games
FROM recommendations r
LEFT JOIN games_cleaned g
    ON r.app_id = g.app_id
WHERE g.app_id IS NULL;


/* Date range */

SELECT
    MIN(date) AS min_review_date,
    MAX(date) AS max_review_date
FROM recommendations;

SELECT
    MIN(date_release) AS min_release_date,
    MAX(date_release) AS max_release_date
FROM games_cleaned;