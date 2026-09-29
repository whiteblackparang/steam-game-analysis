/* Game Analysis */


/* Most reviewed games */

SELECT
    gf.app_id,
    g.title,
    gf.recommendation_count,
    gf.recommend_rate,
    gf.avg_hours
FROM game_features gf
JOIN games_cleaned g
    ON gf.app_id = g.app_id
ORDER BY gf.recommendation_count DESC
LIMIT 20;


/* Games with high recommendation rates */

SELECT
    gf.app_id,
    g.title,
    gf.recommendation_count,
    gf.recommend_rate,
    gf.avg_hours
FROM game_features gf
JOIN games_cleaned g
    ON gf.app_id = g.app_id
WHERE gf.recommendation_count >= 100
ORDER BY gf.recommend_rate DESC
LIMIT 20;


/* Price group */

SELECT
    CASE
        WHEN price_final = 0 THEN 'Free'
        WHEN price_final < 10 THEN 'Under $10'
        WHEN price_final < 30 THEN '$10-$30'
        WHEN price_final < 60 THEN '$30-$60'
        ELSE '$60+'
    END AS price_group,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews
FROM games_cleaned
GROUP BY
    CASE
        WHEN price_final = 0 THEN 'Free'
        WHEN price_final < 10 THEN 'Under $10'
        WHEN price_final < 30 THEN '$10-$30'
        WHEN price_final < 60 THEN '$30-$60'
        ELSE '$60+'
    END
ORDER BY game_count DESC;


/* Platform support */

SELECT
    platform_count,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews,
    AVG(price_final) AS avg_price
FROM games_cleaned
GROUP BY platform_count
ORDER BY platform_count;


/* Release year */

SELECT
    release_year,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews
FROM games_cleaned
GROUP BY release_year
ORDER BY release_year;


/* Rating */

SELECT
    rating,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews
FROM games_cleaned
GROUP BY rating
ORDER BY avg_positive_ratio DESC;


/* Playtime and recommendation rate */

SELECT
    gf.app_id,
    g.title,
    gf.recommendation_count,
    gf.avg_hours,
    gf.recommend_rate
FROM game_features gf
JOIN games_cleaned g
    ON gf.app_id = g.app_id
WHERE gf.recommendation_count >= 100
ORDER BY gf.avg_hours DESC
LIMIT 20;