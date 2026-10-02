USE steam_analysis;

-- Recommendation Analysis / 추천 분석
SET SESSION sort_buffer_size = 1024 * 1024 * 256;

CREATE INDEX idx_recommendations_app_id ON recommendations(app_id);

-- Total reviews / 전체 리뷰 수 확인
SELECT COUNT(*) AS review_count
FROM recommendations;

-- Recommended vs not recommended / 추천 vs 비추천 리뷰 수 비교 
SELECT 
    is_recommended,
    COUNT(*) AS review_count
FROM recommendations
GROUP BY is_recommended;

-- Average playtime / 리뷰어들의 전체 평균 플레이 타임
SELECT 
    AVG(hours) AS avg_hours
FROM recommendations;

-- Average playtime by recommendation / 추천 여부에 따른 평균 플레이 타임 분석 
SELECT 
    is_recommended,
    AVG(hours) AS avg_hours,
    AVG(helpful) AS avg_helpful,
    AVG(funny) AS avg_funny
FROM recommendations
GROUP BY is_recommended
ORDER BY is_recommended DESC;

-- Recommendation rate / 전체 추천 비율 계산 
SELECT 
    AVG(
        CASE 
            WHEN is_recommended IN ('1', 'True', 'TRUE') THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM recommendations;

SELECT is_recommended, COUNT(*) 
FROM recommendations 
GROUP BY is_recommended;

-- Playtime group / 플레이 타임 구간별 리뷰 수 및 추천 비율 분석
SELECT        
    playtime_group,
    COUNT(*) AS review_count,
    AVG(
        CASE 
            WHEN is_recommended IN ('1', 'True', 'TRUE') THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM (
    SELECT 
        hours,
        is_recommended,
        CASE 
            WHEN hours < 1 THEN 'Under 1h'
            WHEN hours < 5 THEN '1-5h'
            WHEN hours < 20 THEN '5-20h'
            WHEN hours < 50 THEN '20-50h'
            WHEN hours < 100 THEN '50-100h'
            ELSE '100h+'
        END AS playtime_group
    FROM recommendations
) AS t
GROUP BY playtime_group
ORDER BY 
    CASE playtime_group
        WHEN 'Under 1h' THEN 1
        WHEN '1-5h' THEN 2
        WHEN '5-20h' THEN 3
        WHEN '20-50h' THEN 4
        WHEN '50-100h' THEN 5
        ELSE 6
    END;

-- Monthly review trend / 월별 리뷰 트렌드 분석
SELECT 
    review_year,
    review_month,
    COUNT(*) AS review_count,
    AVG(
        CASE 
            WHEN is_recommended IN ('1', 'True', 'TRUE') THEN 1.0
            ELSE 0.0
        END
    ) AS recommendation_rate
FROM (
    SELECT 
        YEAR(date) AS review_year,
        MONTH(date) AS review_month,
        is_recommended
    FROM recommendations
) AS t
GROUP BY 
    review_year,
    review_month
ORDER BY 
    review_year,
    review_month;

-- Games with high recommendation rates 
-- 리뷰 100개 이상인 게임 중 추천 비율 높은 상위 20개 
SELECT 
    sub.app_id,
    g.title,
    sub.review_count,
    sub.recommendation_rate,
    sub.avg_hours
FROM (
    SELECT 
        app_id,
        COUNT(*) AS review_count,
        AVG(CASE WHEN is_recommended IN ('1', 'True', 'TRUE') THEN 1.0 ELSE 0.0 END) AS recommendation_rate,
        AVG(hours) AS avg_hours
    FROM recommendations
    GROUP BY app_id
    HAVING COUNT(*) >= 100
) AS sub
JOIN games_cleaned g 
    ON sub.app_id = g.app_id
ORDER BY sub.recommendation_rate DESC
LIMIT 20;

-- 리뷰 100개 이상인 게임 중 평균 플레이 타임이 긴 상위 20개
SELECT 
    gf.app_id,
    g.title,
    gf.recommended_count AS review_count,
    gf.avg_hours,
    gf.recommend_rate
FROM game_features gf
JOIN games_cleaned g 
    ON gf.app_id = g.app_id
WHERE gf.recommended_count >= 100
ORDER BY gf.avg_hours DESC
LIMIT 20;