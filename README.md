# Steam Game & User Behavior Analysis

Steam 게임 및 사용자 데이터를 활용하여 게임 특성과 사용자 행동을 분석하고, 리뷰·추천 데이터를 기반으로 사용자 세그먼트를 도출한 데이터 분석 프로젝트입니다.

## Project Overview

Steam의 게임 정보, 사용자 정보, 리뷰 및 추천 데이터를 활용하여 다음과 같은 질문을 분석했습니다.

- 어떤 게임이 많은 사용자 리뷰와 추천을 받는가?
- 게임 가격, 플랫폼, 출시연도와 사용자 반응에는 어떤 관계가 있는가?
- 사용자의 게임 보유량과 리뷰 활동은 어떻게 다른가?
- 플레이타임에 따라 게임 추천 비율이 달라지는가?
- 사용자 행동을 기반으로 어떤 유형의 사용자 세그먼트를 만들 수 있는가?

## Key Findings

### 1. 사용자 세그먼트

사용자의 게임 보유량, 리뷰 활동, 추천 활동, 평균 플레이타임 등을 활용하여 K-Means 기반 사용자 세분화를 수행했습니다.

| Segment | Users | Share | Avg. Products | Avg. Reviews | Recommend Rate |
|---|---:|---:|---:|---:|---:|
| General Users | 9,181,826 | 67.24% | 83.30 | 1.38 | 99.44% |
| Highly Engaged Users | 2,851,721 | 20.88% | 247.04 | 9.08 | 87.16% |
| Low-Recommendation Users | 1,622,270 | 11.88% | 104.94 | 1.49 | 14.84% |

### 2. Highly Engaged Users

Highly Engaged Users는 평균 보유 게임 수가 247개, 평균 리뷰 수가 9.08개로 다른 사용자 그룹보다 높은 리뷰 활동을 보였습니다.

### 3. Low-Recommendation Users

Low-Recommendation Users는 평균 추천율이 14.84%로 다른 세그먼트와 큰 차이를 보였습니다. 다만 낮은 추천율만으로 사용자 만족도나 이탈을 직접 판단하지 않고, 하나의 행동 특성으로 해석했습니다.

### 4. Activity Pattern

사용자 활동 수준을 리뷰 수를 기준으로 구분하여 세그먼트별 활동 특성을 비교했습니다. Highly Engaged Users에서는 Medium-High 및 High 활동 사용자가 대부분을 차지했으며, General Users와 Low-Recommendation Users에서는 Low 및 Medium-Low 활동 사용자가 많았습니다.

## Analysis

### Game Analysis

- 게임별 리뷰 및 추천 수 분석
- 추천율이 높은 게임 분석
- 가격대별 사용자 반응 비교
- 플랫폼 지원 범위별 게임 특성 비교
- 출시연도별 게임 분포 및 사용자 반응 분석
- 플레이타임과 추천율 관계 분석

### User Analysis

- 사용자별 게임 보유량 및 리뷰 활동 분석
- 게임 보유량 대비 리뷰 활동 분석
- 사용자 활동 수준별 행동 비교
- 사용자 활동 수준에 따른 추천율 및 플레이타임 비교

### Recommendation Analysis

- 추천 / 비추천 리뷰 비교
- 추천 여부에 따른 평균 플레이타임 비교
- 플레이타임 구간별 추천율 분석
- 월별 리뷰 및 추천율 추이 분석
- 게임별 추천율 및 평균 플레이타임 분석

### User Segmentation

K-Means Clustering을 활용하여 사용자 행동을 기반으로 세그먼트를 구성했습니다.

사용 변수:

- `products`
- `reviews`
- `reviews_per_product`
- `recommendation_count`
- `recommend_rate`
- `avg_hours`

분석 과정에서 왜도가 높은 변수에는 `log1p` 변환을 적용하고, StandardScaler로 스케일링한 후 Elbow Method와 Silhouette Score를 비교했습니다.

Silhouette Score 분석 결과 K=3을 사용하여 최종 사용자 세그먼트를 구성했습니다.

## Dataset

분석에 사용한 데이터는 다음과 같습니다.

| Dataset | Rows | Description |
|---|---:|---|
| Games | 50,872 | Steam 게임 정보 |
| Users | 14,306,064 | 사용자별 게임 보유 및 리뷰 정보 |
| Recommendations | 41,154,794 | 게임 리뷰 및 추천 정보 |

주요 데이터 컬럼:

**Games**
- `app_id`
- `title`
- `date_release`
- `rating`
- `positive_ratio`
- `user_reviews`
- `price_final`
- `discount`
- `steam_deck`

**Recommendations**
- `app_id`
- `user_id`
- `is_recommended`
- `hours`
- `helpful`
- `funny`
- `date`

## Methodology

1. 데이터 품질 확인
2. 데이터 전처리
3. 게임 및 사용자 Feature Engineering
4. 게임 분석
5. 사용자 행동 분석
6. 추천 데이터 분석
7. 사용자 세분화
8. Python 분석 결과와 MySQL 결과 검증

대규모 Recommendation 데이터를 효율적으로 처리하기 위해 Chunk 단위 데이터 처리를 사용했습니다.

## Tech Stack

- Python
- Pandas
- NumPy
- Matplotlib
- Scikit-learn
- MySQL
- MySQL Workbench
- Jupyter Notebook
- PyCharm

## Project Structure

```text
steam-game-analysis/
├── README.md
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
│   ├── 01_data_loading.ipynb
│   ├── 02_data_quality.ipynb
│   ├── 03_data_cleaning.ipynb
│   ├── 04_feature_engineering.ipynb
│   ├── 05_game_analysis.ipynb
│   ├── 06_user_analysis.ipynb
│   ├── 07_recommendation_analysis.ipynb
│   └── 08_segmentation.ipynb
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_game_analysis.sql
│   ├── 03_user_analysis.sql
│   ├── 04_recommendation_analysis.sql
│   └── 05_segmentation.sql
├── outputs/
│   ├── figures/
│   └── tables/
└── docs/
    ├── project_plan.md
    └── data_dictionary.md