/* Data Quality Check */


/* Row count */

SELECT COUNT(*) AS game_count
FROM games_cleaned;

SELECT COUNT(*) AS user_count
FROM users_cleaned;

SELECT COUNT(*) AS recommendation_count
FROM recommendations;


/* Duplicate IDs */

SELECT
    app_id,
    COUNT(*) AS duplicate_count
FROM games_cleaned
GROUP BY app_id
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


/* Date range */

SELECT
    MIN(date_release) AS min_release_date,
    MAX(date_release) AS max_release_date
FROM games_cleaned;