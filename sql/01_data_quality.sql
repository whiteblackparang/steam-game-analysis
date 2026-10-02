USE steam_analysis;

/* Row count / 각 테이블별 전체 행(Row) 개수 확인 */
SELECT COUNT(*) AS game_count
FROM games_cleaned;

SELECT COUNT(*) AS user_count
FROM users_cleaned;

SELECT COUNT(*) AS recommendation_count
FROM recommendations;

/* Duplicate IDs / 중복된 앱 ID(App ID) 확인 */
SELECT 
    app_id,
    COUNT(*) AS duplicate_count
FROM games_cleaned
GROUP BY app_id
HAVING COUNT(*) > 1;

/* Value checks / 잘못된 가격 및 할인율 데이터 검증 */
SELECT COUNT(*) AS invalid_price_count
FROM games_cleaned
WHERE price_final < 0
   OR price_original < 0;

SELECT COUNT(*) AS invalid_discount_count
FROM games_cleaned
WHERE discount < 0
   OR discount > 100;

/* Date range / 출시일 날짜 범위 확인 */
SELECT 
    MIN(date_release) AS min_release_date,
    MAX(date_release) AS max_release_date
FROM games_cleaned;