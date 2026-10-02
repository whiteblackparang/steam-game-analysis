# Steam Game & User Behavior Analysis — Data Dictionary

## 1. Overview

This document describes the datasets and features used in the Steam Game & User Behavior Analysis project.

The project uses three raw datasets:

- Games
- Users
- Recommendations

Additional feature tables were created during the analysis.

---

## 2. Games Dataset

**File:** `games.csv`

| Column | Type | Description |
|---|---|---|
| `app_id` | int | Steam application ID |
| `title` | string | Game title |
| `date_release` | date | Game release date |
| `win` | bool | Whether the game supports Windows |
| `mac` | bool | Whether the game supports macOS |
| `linux` | bool | Whether the game supports Linux |
| `rating` | string | Steam rating category |
| `positive_ratio` | int | Percentage of positive reviews |
| `user_reviews` | int | Number of user reviews |
| `price_final` | float | Final game price |
| `price_original` | float | Original game price |
| `discount` | float | Discount percentage |
| `steam_deck` | bool | Whether the game supports Steam Deck |

### Derived Features

| Column | Description |
|---|---|
| `release_year` | Year extracted from `date_release` |
| `release_month` | Month extracted from `date_release` |
| `rating_score` | Numeric score assigned to the Steam rating category |
| `is_free` | Whether `price_final` is 0 |
| `price_change` | Difference between original and final price |
| `discount_rate` | Discount converted from percentage to decimal |
| `platform_count` | Number of supported platforms among Windows, macOS, and Linux |

---

## 3. Users Dataset

**File:** `users.csv`

| Column | Type | Description |
|---|---|---|
| `user_id` | int | Steam user ID |
| `products` | int | Number of games owned by the user |
| `reviews` | int | Number of reviews written by the user |

---

## 4. Recommendations Dataset

**File:** `recommendations.csv`

| Column | Type | Description |
|---|---|---|
| `app_id` | int | Steam application ID |
| `helpful` | int | Number of users who marked the review as helpful |
| `funny` | int | Number of users who marked the review as funny |
| `date` | date | Review date |
| `is_recommended` | bool | Whether the user recommended the game |
| `hours` | float | Playtime at the time of the review |
| `user_id` | int | Steam user ID |
| `review_id` | int | Unique review ID |

---

## 5. Game Features

**Output:** `game_features.csv`

Game-level features were created by aggregating Recommendation data by `app_id`.

| Column | Description |
|---|---|
| `app_id` | Steam application ID |
| `review_count` | Number of reviews in the Recommendation dataset |
| `recommended_count` | Number of positive recommendations |
| `hours_sum` | Total playtime across reviews |
| `helpful_sum` | Total helpful votes |
| `funny_sum` | Total funny votes |
| `recommend_rate` | Proportion of reviews recommending the game |
| `avg_hours` | Average playtime |
| `avg_helpful` | Average helpful votes |
| `avg_funny` | Average funny votes |

The table also contains the original game-level features from `games_cleaned`.

---

## 6. User Features

**Output:** `user_features.csv`

User-level features were created by aggregating Recommendation data by `user_id`.

| Column | Description |
|---|---|
| `user_id` | Steam user ID |
| `products` | Number of games owned |
| `reviews` | Number of reviews written |
| `reviews_per_product` | Reviews divided by number of owned games |
| `recommendation_count` | Number of reviews written in the Recommendation dataset |
| `recommend_rate` | Proportion of reviews recommending the game |
| `avg_hours` | Average playtime across reviews |
| `avg_helpful` | Average helpful votes received |
| `avg_funny` | Average funny votes received |

---

## 7. User Segmentation Features

The following six variables were used for K-Means clustering:

| Feature | Description |
|---|---|
| `products` | Number of games owned |
| `reviews` | Number of reviews written |
| `reviews_per_product` | Review activity relative to owned games |
| `recommendation_count` | Number of Recommendation records |
| `recommend_rate` | Proportion of positive recommendations |
| `avg_hours` | Average playtime |

### Preprocessing

The following features were log-transformed using `log1p`:

- `products`
- `reviews`
- `reviews_per_product`
- `recommendation_count`
- `avg_hours`

`recommend_rate` was not log-transformed.

After transformation, `StandardScaler` was applied before K-Means clustering.

---

## 8. User Segments

The final clustering used **K=3**.

| Cluster | Interpretation |
|---|---|
| Cluster 0 | General Users |
| Cluster 1 | Highly Engaged Users |
| Cluster 2 | Low-Recommendation Users |

These labels describe observed behavioral patterns in the dataset and do not represent fixed user types.

---

## 9. Activity Level Definition

User activity level was defined using the number of reviews written.

| Reviews | Activity Level |
|---:|---|
| 0–1 | Low |
| 2–3 | Medium-Low |
| 4–5 | Medium-High |
| 6+ | High |

---

## 10. Recommendation Level Definition

Recommendation level was defined using `recommend_rate`.

| Recommendation Rate | Level |
|---:|---|
| < 0.50 | Low |
| 0.50–<0.80 | Medium |
| >= 0.80 | High |

---

## 11. Data Scope

| Dataset | Rows |
|---|---:|
| Games | 50,872 |
| Users | 14,306,064 |
| Recommendations | 41,154,794 |

Recommendation data was processed in chunks in Python because of its large file size.