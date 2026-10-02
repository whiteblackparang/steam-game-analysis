# Steam Game & User Behavior Analysis — Final Report

## 1. Project Overview

### 1.1 Background

Steam에는 게임 정보 외에도 게임 보유량, 리뷰 활동, 플레이타임, 추천 여부 같은 사용자 행동 데이터가 쌓여 있습니다.

이 프로젝트는 Steam의 게임·사용자 데이터로 게임 특성과 사용자 행동의 관계를 분석하고, 행동 패턴에 따라 사용자 세그먼트를 나눴습니다. 게임 인기 순위를 보는 데서 멈추지 않고 아래 네 가지를 차례로 살펴봤습니다.

- 게임 특성에 따른 사용자 반응
- 사용자별 게임 이용 및 리뷰 활동
- 플레이타임과 추천 여부의 관계
- 사용자 행동 기반 세분화

### 1.2 Objectives

- 가격, 플랫폼, 출시연도 등 게임 특성별 사용자 반응 분석
- 사용자의 게임 보유량과 리뷰 활동 분석
- 플레이타임과 게임 추천 여부의 관계 분석
- 사용자 행동 데이터 기반 세그먼트 도출
- Python 분석 결과를 MySQL로 재검증

---

## 2. Dataset

세 종류의 데이터를 사용했습니다.

| Dataset | Rows | Description |
|---|---:|---|
| Games | 50,872 | Steam 게임 정보 |
| Users | 14,306,064 | 사용자별 게임 보유 및 리뷰 정보 |
| Recommendations | 41,154,794 | 게임 리뷰 및 추천 정보 |

### 2.1 Games

- `app_id`: 게임 ID
- `title`: 게임명
- `date_release`: 출시일
- `rating`: Steam 평점
- `positive_ratio`: 긍정 리뷰 비율
- `user_reviews`: 리뷰 수
- `price_final`: 최종 가격
- `price_original`: 기존 가격
- `discount`: 할인율
- `win`, `mac`, `linux`: 플랫폼 지원 여부
- `steam_deck`: Steam Deck 지원 여부

### 2.2 Users

- `user_id`: 사용자 ID
- `products`: 보유 게임 수
- `reviews`: 리뷰 수

### 2.3 Recommendations

- `app_id`: 게임 ID
- `user_id`: 사용자 ID
- `is_recommended`: 추천 여부
- `hours`: 플레이타임
- `helpful`: 유용함 평가 수
- `funny`: 재미있음 평가 수
- `date`: 리뷰 작성일

---

## 3. Analysis Workflow

분석은 아래 순서로 진행했습니다.

```text
Raw Data
   ↓
Data Quality Check
   ↓
Data Cleaning
   ↓
Feature Engineering
   ↓
Game Analysis
   ↓
User Analysis
   ↓
Recommendation Analysis
   ↓
User Segmentation
   ↓
Python ↔ MySQL Result Validation
```

Recommendation 데이터는 규모가 커서 Python에서 Chunk 단위로 나눠 처리했습니다.

---

## 4. Data Quality

분석에 들어가기 전에 데이터 품질부터 확인했습니다.

### Missing Values

- Games: 0
- Users: 0
- Recommendations sample: 0

### Duplicate Checks

- Games `app_id` duplicates: 0
- Users `user_id` duplicates: 0
- Recommendations `review_id` duplicates: 0

가격, 할인율, 날짜 값이 분석에 쓸 수 있는 범위 안에 있는지도 확인했습니다.

---

## 5. Data Cleaning

### 5.1 Date Features

게임 출시일을 datetime으로 바꾸고 `release_year`, `release_month` 변수를 만들었습니다. 출시 시기별로 게임 분포와 사용자 반응을 볼 수 있게 하기 위해서입니다.

### 5.2 Rating Encoding

문자형 rating은 분석에 쓸 수 있도록 순서형 점수로 변환했습니다.

| Rating | Score |
|---|---:|
| Overwhelmingly Negative | 1 |
| Very Negative | 2 |
| Negative | 3 |
| Mostly Negative | 4 |
| Mixed | 5 |
| Mostly Positive | 6 |
| Positive | 7 |
| Very Positive | 8 |
| Overwhelmingly Positive | 9 |

### 5.3 Price & Platform Features

가격과 플랫폼 정보에서 아래 Feature를 만들었습니다.

- `is_free`
- `price_change`
- `discount_rate`
- `platform_count`

---

## 6. Feature Engineering

게임·사용자 데이터를 Recommendation 데이터와 연결해 분석용 Feature를 만들었습니다.

### 6.1 Game Features

게임별 지표는 다음과 같습니다.

- `review_count`
- `recommended_count`
- `hours_sum`
- `helpful_sum`
- `funny_sum`
- `recommend_rate`
- `avg_hours`
- `avg_helpful`
- `avg_funny`

최종 `game_features`에는 **50,872개** 게임이 들어 있습니다.

### 6.2 User Features

사용자별 Feature는 다음과 같습니다.

- `products`
- `reviews`
- `reviews_per_product`
- `recommendation_count`
- `recommend_rate`
- `avg_hours`
- `avg_helpful`
- `avg_funny`

최종 `user_features`에는 **14,306,064명**이 들어 있습니다.

---

## 7. Game Analysis

게임 데이터로 게임 특성과 사용자 반응을 분석했습니다.

### 7.1 Game Popularity

게임별 Recommendation 데이터를 집계해 리뷰와 추천 활동이 많은 게임을 확인했습니다. 사용한 지표는 Recommendation Count, Recommendation Rate, Average Playtime, User Reviews입니다. 전체 리뷰 수만 보지 않고 Recommendation 데이터에 나타난 실제 반응도 함께 비교했습니다.

### 7.2 Price Analysis

가격은 Free, Under $10, $10-$30, $30-$60, $60+ 다섯 구간으로 나눴습니다. 구간별로 게임 수, 긍정 리뷰 비율, 리뷰 수를 비교했습니다.

### 7.3 Platform Analysis

Windows, macOS, Linux 지원 여부로 게임별 플랫폼 수를 계산하고, 지원 범위에 따라 게임 수와 사용자 반응이 어떻게 다른지 비교했습니다.

### 7.4 Release Year Analysis

출시연도별 게임 수, 긍정 리뷰 비율, 사용자 리뷰 수를 비교해 Steam 게임의 연도별 분포와 반응을 확인했습니다.

### 7.5 Playtime & Recommendation

게임별 평균 플레이타임과 추천율을 나란히 놓고, 플레이 시간과 추천 행동 사이에 어떤 관계가 있는지 살펴봤습니다.

---

## 8. User Analysis

### 8.1 User Activity

리뷰 수를 기준으로 활동 수준을 네 단계로 나눴습니다.

```text
Reviews <= 1  → Low
Reviews <= 3  → Medium-Low
Reviews <= 5  → Medium-High
Reviews > 5   → High
```

활동 수준별 사용자 수, 평균 리뷰 수, 추천율, 평균 플레이타임은 다음과 같습니다.

| Activity Level | User Count | Avg. Reviews | Avg. Recommend Rate | Avg. Hours |
|---|---:|---:|---:|---:|
| Low | 3,682,540 | 1.28 | 82.60% | 137.73 |
| Medium-Low | 3,473,307 | 1.93 | 83.94% | 126.57 |
| Medium-High | 3,593,350 | 2.82 | 84.12% | 125.77 |
| High | 3,556,867 | 5.52 | 84.04% | 115.17 |

활동 수준이 올라갈수록 평균 리뷰 수는 늘었습니다. 평균 플레이타임은 반대로 활동 수준이 높은 사용자에서 더 낮았습니다. 리뷰를 많이 쓰는 것과 오래 플레이하는 것은 같은 행동 특성이 아닙니다.

---

## 9. Recommendation Analysis

Recommendation 데이터 41,154,794건으로 리뷰 행동을 분석했습니다.

### 9.1 Recommendation vs Non-Recommendation

추천 여부별로 리뷰 수, 평균 플레이타임, Helpful/Funny 반응을 비교했습니다.

### 9.2 Playtime Groups

플레이타임을 Under 1h, 1-5h, 5-20h, 20-50h, 50-100h, 100h+ 여섯 구간으로 나누고, 구간마다 리뷰 수와 추천율을 비교했습니다.

### 9.3 Monthly Trend

리뷰 작성일에서 연도와 월을 뽑아 월별 리뷰 수와 추천율을 집계하고, Recommendation 활동이 시간에 따라 어떻게 달라졌는지 확인했습니다.

### 9.4 Game-level Recommendation

Recommendation 데이터가 100개 이상인 게임만 골라 Review Count, Recommendation Rate, Average Playtime을 계산하고 게임별 반응을 비교했습니다.

---

## 10. User Segmentation

이 프로젝트의 핵심 분석입니다. 사용자 행동 데이터에 K-Means Clustering을 적용했습니다.

### 10.1 Variables

다음 6개 변수를 사용했습니다.

- `products`
- `reviews`
- `reviews_per_product`
- `recommendation_count`
- `recommend_rate`
- `avg_hours`

Recommendation 활동이 전혀 없는 사용자는 대상에서 뺐습니다.

### 10.2 Preprocessing

왜도가 큰 `products`, `reviews`, `reviews_per_product`, `recommendation_count`, `avg_hours`에는 `log1p` 변환을 적용했습니다. 그다음 `StandardScaler`로 변수 간 스케일 차이를 맞췄습니다.

### 10.3 Selecting K

K=2부터 K=8까지 Silhouette Score를 비교했습니다.

| K | Silhouette Score |
|---:|---:|
| 2 | 0.3279 |
| 3 | **0.3520** |
| 4 | 0.3415 |
| 5 | 0.2787 |
| 6 | 0.2820 |
| 7 | 0.2701 |
| 8 | 0.2502 |

Elbow Method와 Silhouette Score를 함께 보고 **K=3**을 선택했습니다.

---

## 11. Segmentation Results

3개의 세그먼트가 나왔습니다.

| Segment | Users | Share | Avg. Products | Avg. Reviews | Recommend Rate | Avg. Hours |
|---|---:|---:|---:|---:|---:|---:|
| General Users | 9,181,826 | 67.24% | 83.30 | 1.38 | 99.44% | 141.77 |
| Highly Engaged Users | 2,851,721 | 20.88% | 247.04 | 9.08 | 87.16% | 99.21 |
| Low-Recommendation Users | 1,622,270 | 11.88% | 104.94 | 1.49 | 14.84% | 123.50 |

### 11.1 Cluster 0 — General Users

전체 사용자의 **67.24%**로 가장 큰 그룹입니다. 평균 보유 게임은 83.30개, 평균 리뷰는 1.38개이고 추천율은 99.44%, 평균 플레이타임은 141.77시간입니다. 활동 수준은 Low와 Medium-Low가 대부분이었습니다. 게임은 갖고 있지만 리뷰는 적게 남기는 일반 사용자군으로 볼 수 있습니다.

### 11.2 Cluster 1 — Highly Engaged Users

전체의 **20.88%**입니다. 평균 보유 게임 247.04개, 평균 리뷰 9.08개로 세 세그먼트 중 가장 많습니다. 추천율은 87.16%, 평균 플레이타임은 99.21시간입니다. 대부분 Medium-High나 High 활동 수준에 속해, 게임 보유와 리뷰 활동이 활발한 사용자군으로 분류했습니다.

### 11.3 Cluster 2 — Low-Recommendation Users

전체의 **11.88%**입니다. 평균 보유 게임은 104.94개, 평균 리뷰는 1.49개, 평균 플레이타임은 123.50시간으로 눈에 띄는 차이가 없지만, 추천율은 14.84%로 다른 세그먼트보다 크게 낮습니다. 다만 낮은 추천율을 곧바로 불만족이나 이탈로 해석하지는 않고 관찰된 행동 특성으로만 다뤘습니다.

---

## 12. Cluster Activity Analysis

클러스터별 활동 수준 분포입니다.

### Cluster 0

- Low: 6,464,760명
- Medium-Low: 2,716,989명
- Medium-High: 77명

대부분 Low~Medium-Low입니다.

### Cluster 1

- High: 1,473,614명
- Medium-High: 1,086,424명
- Medium-Low: 291,683명

대부분 Medium-High~High입니다.

### Cluster 2

- Low: 987,855명
- Medium-Low: 601,736명
- Medium-High: 31,352명
- High: 1,327명

Cluster 0처럼 대부분 Low~Medium-Low입니다.

---

## 13. Cluster Recommendation Analysis

추천 수준은 추천율 기준으로 나눴습니다.

```text
recommend_rate < 0.5  → Low
recommend_rate < 0.8  → Medium
recommend_rate >= 0.8 → High
```

| Cluster | Low | Medium | High |
|---:|---:|---:|---:|
| 0 | 0 | 146,344 | 9,035,482 |
| 1 | 79,574 | 691,715 | 2,080,432 |
| 2 | 1,200,066 | 422,204 | 0 |

Cluster 0은 대부분 High, Cluster 2는 대부분 Low에 속했습니다.

---

## 14. Python & MySQL Validation

Python에서 분석한 결과를 MySQL에서 다시 계산해 비교했습니다.

구축한 MySQL 테이블은 다음과 같습니다.

- `games_cleaned`
- `users_cleaned`
- `recommendations`
- `game_features`
- `user_features`
- `user_segments`

SQL 분석 파일은 다음 5개입니다.

- `01_data_quality.sql`
- `02_game_analysis.sql`
- `03_user_analysis.sql`
- `04_recommendation_analysis.sql`
- `05_segmentation.sql`

세그먼트는 Python과 MySQL의 계산 결과를 직접 비교했습니다. 클러스터별 사용자 수는 두 환경에서 같았습니다.

- Cluster 0 → 9,181,826
- Cluster 1 → 2,851,721
- Cluster 2 → 1,622,270

Cluster Profile의 주요 평균값도 일치했습니다. Feature 생성과 Segmentation 결과가 SQL 환경에서도 그대로 재현된다는 점을 확인한 셈입니다.

---

## 15. Key Findings

### 1. 사용자 행동은 세 가지 패턴으로 나뉘었습니다.

K-Means Clustering 결과 일반 사용자, 고관여 사용자, 추천율이 낮은 사용자 그룹이 나왔습니다.

### 2. Highly Engaged Users는 게임 보유량과 리뷰 활동이 가장 높았습니다.

평균 보유 게임 247.04개, 평균 리뷰 9.08개로 다른 세그먼트를 앞섰습니다.

### 3. Low-Recommendation Users는 추천 행동이 뚜렷하게 달랐습니다.

평균 추천율은 **14.84%**였고, 대부분 Low~Medium-Low 활동 수준이었습니다.

### 4. 리뷰 활동량과 플레이타임은 같은 지표가 아니었습니다.

활동 수준이 높을수록 리뷰는 많아지는데 평균 플레이타임은 오히려 낮아졌습니다. 사용자의 참여 수준은 하나의 지표로 판단하기보다 보유 게임, 리뷰, 추천, 플레이타임을 함께 봐야 합니다.

---

## 16. Limitations

### 16.1 Recommendation 데이터의 기간

Recommendation 데이터는 2010-11-03 ~ 2022-12-31 범위입니다. 현재 Steam 사용자 전체의 행동을 대표한다고 보기에는 기간상 한계가 있습니다.

### 16.2 Recommendation Rate의 해석

추천율은 사용자가 게임을 긍정적으로 평가했는지 보여주는 행동 지표입니다. 사용자 만족도나 이탈 여부와는 같지 않습니다. Low-Recommendation Users를 별도 세그먼트로 구분했어도 이 그룹이 반드시 불만족 사용자라는 뜻은 아닙니다.

### 16.3 Causal Interpretation

관찰 데이터를 바탕으로 한 분석이라, 가격·플레이타임·리뷰 활동 등에서 발견한 관계를 인과관계로 해석하지 않았습니다.

### 16.4 Segmentation Interpretation

K-Means는 입력 변수와 전처리 방식에 따라 결과가 달라질 수 있습니다. 이번 세그먼트는 절대적인 사용자 유형이 아니라, 선택한 행동 Feature와 분석 방법에 따라 구분한 그룹으로 읽어야 합니다.

---

## 17. Conclusion

Steam의 게임, 사용자, Recommendation 데이터로 게임 특성 분석, 사용자 행동 분석, 추천 행동 분석, 사용자 세분화를 차례로 진행했습니다. 1,400만 명이 넘는 사용자 데이터와 4,100만 건이 넘는 Recommendation 데이터는 Python으로 처리했고, 분석은 MySQL에서도 수행했습니다.

사용자 행동을 기준으로 세 개의 세그먼트를 도출했고, 그룹마다 게임 보유량, 리뷰 활동, 추천 행동, 플레이타임이 다르다는 점을 확인했습니다. Python의 Segmentation 결과를 MySQL에서 다시 집계해 주요 결과가 일치하는 것도 검증했습니다.

이 프로젝트에서는 **대규모 데이터 처리 → Feature Engineering → 행동 분석 → 사용자 Segmentation → SQL 검증**으로 이어지는 분석 workflow를 구현했습니다.