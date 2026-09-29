/* Recommendation Analysis */


/* Total reviews */

SELECT COUNT(*) AS review_count
FROM recommendations;


/* Recommended vs not recommended */

SELECT
    is_recommended,
    COUNT(*) AS review_count
FROM recommendations
GROUP BY is_recommended
ORDER BY is_recommended DESC;


/* Average playtime */

SELECT
    AVG(hours) AS avg_hours
FROM recommendations;


/* Average playtime by recommendation */

SELECT
    is_recommended,
    AVG(hours) AS avg_hours,
    AVG(helpful) AS avg_helpful,
    AVG(funny) AS avg_funny
FROM recommendations
GROUP BY is_recommended
ORDER BY is_recommended DESC;


/* Recommendation rate */

SELECT
    AVG(
        CASE
            WHEN is_recommended = 1 THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM recommendations;


/* Playtime group */

SELECT
    CASE
        WHEN hours < 1 THEN 'Under 1h'
        WHEN hours < 5 THEN '1-5h'
        WHEN hours < 20 THEN '5-20h'
        WHEN hours < 50 THEN '20-50h'
        WHEN hours < 100 THEN '50-100h'
        ELSE '100h+'
    END AS playtime_group,
    COUNT(*) AS review_count,
    AVG(
        CASE
            WHEN is_recommended = 1 THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM recommendations
GROUP BY
    CASE
        WHEN hours < 1 THEN 'Under 1h'
        WHEN hours < 5 THEN '1-5h'
        WHEN hours < 20 THEN '5-20h'
        WHEN hours < 50 THEN '20-50h'
        WHEN hours < 100 THEN '50-100h'
        ELSE '100h+'
    END
ORDER BY MIN(hours);


/* Monthly review trend */

SELECT
    YEAR(date) AS review_year,
    MONTH(date) AS review_month,
    COUNT(*) AS review_count,
    AVG(
        CASE
            WHEN is_recommended = 1 THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM recommendations
GROUP BY
    YEAR(date),
    MONTH(date)
ORDER BY
    review_year,
    review_month;


/* Games with high recommendation rates */

SELECT
    r.app_id,
    g.title,
    COUNT(*) AS review_count,
    AVG(
        CASE
            WHEN r.is_recommended = 1 THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate,
    AVG(r.hours) AS avg_hours
FROM recommendations r
JOIN games_cleaned g
    ON r.app_id = g.app_id
GROUP BY
    r.app_id,
    g.title
HAVING COUNT(*) >= 100
ORDER BY recommendation_rate DESC
LIMIT 20;


/* Playtime and recommendation rate by game */

SELECT
    r.app_id,
    g.title,
    COUNT(*) AS review_count,
    AVG(r.hours) AS avg_hours,
    AVG(
        CASE
            WHEN r.is_recommended = 1 THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM recommendations r
JOIN games_cleaned g
    ON r.app_id = g.app_id
GROUP BY
    r.app_id,
    g.title
HAVING COUNT(*) >= 100
ORDER BY avg_hours DESC
LIMIT 20;