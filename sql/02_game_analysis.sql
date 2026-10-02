USE steam_analysis;

-- Game Analysis / 게임 분석

-- Most reviewed games / 가장 리뷰가 많은 게임
SELECT 
    gf.app_id, 
    g.title, 
    gf.recommended_count, 
    gf.recommend_rate, 
    gf.avg_hours
FROM game_features gf
JOIN games_cleaned g 
    ON gf.app_id = g.app_id
ORDER BY gf.recommended_count DESC
LIMIT 20;


-- Games with high recommendation rates / 추천 비율이 높은 게임
SELECT 
    gf.app_id, 
    g.title, 
    gf.recommended_count, 
    gf.recommend_rate, 
    gf.avg_hours
FROM game_features gf
JOIN games_cleaned g 
    ON gf.app_id = g.app_id
WHERE gf.recommended_count >= 100
ORDER BY gf.recommend_rate DESC
LIMIT 20;


-- Price group / 가격대별 그룹 분석
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


-- Platform support / 플랫폼 지원 여부별 분석
SELECT 
    platform_count,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews,
    AVG(price_final) AS avg_price
FROM games_cleaned
GROUP BY platform_count
ORDER BY platform_count;


-- Release year / 출시 연도별 분석
SELECT 
    release_year,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews
FROM games_cleaned
GROUP BY release_year
ORDER BY release_year;


-- Rating / 등급별 분석
SELECT 
    rating,
    COUNT(*) AS game_count,
    AVG(positive_ratio) AS avg_positive_ratio,
    AVG(user_reviews) AS avg_user_reviews
FROM games_cleaned
GROUP BY rating
ORDER BY avg_positive_ratio DESC;


-- Playtime and recommendation rate / 플레이 타임과 추천 비율 분석
SELECT 
    gf.app_id, 
    g.title, 
    gf.recommended_count, 
    gf.avg_hours, 
    gf.recommend_rate
FROM game_features gf
JOIN games_cleaned g 
    ON gf.app_id = g.app_id
WHERE gf.recommended_count >= 100
ORDER BY gf.avg_hours DESC
LIMIT 20;