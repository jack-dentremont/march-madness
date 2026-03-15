# 🏀 March Madness Predictor: Champion & Cinderella Modeling

A Random Forest classification model built in R that uses KenPom and Bart Torvik advanced metrics to predict the NCAA Tournament national champion and identify Cinderella teams (double-digit seeds reaching the Sweet Sixteen or beyond). Built for the 2025 tournament and designed to be rerun annually.

## Overview

Every March, the NCAA Tournament produces two reliable storylines: a dominant team cutting down the nets, and a handful of double-digit seeds making improbable runs. This project uses machine learning to predict both!  By training Random Forest models on 16 years of tournament data and advanced metrics from KenPom and Bart Torvik, this project attempts to identify the teams most likely to win it all and the underdogs most likely to bust brackets.

The model runs two parallel analyses: a **Champion model** that filters the entire field down to title contenders, and a **Cinderella model** that identifies which 10+ seeds have the statistical profile to make a deep run.

## 2025 Predictions & Results

### Champion Pick: Auburn

| Prediction | Result |
|:----------:|:------:|
| **Auburn** | Reached the **Final Four** — led eventual champion Florida by 8 at halftime before falling in the semifinal |

### Cinderella Picks

| Team | Seed | Result |
|:----:|:----:|:------:|
| **Arkansas** | 10 | Reached the **Sweet Sixteen** — held an 11-point lead with 4:47 left against 3-seed Texas Tech before losing by 2 in overtime |
| **New Mexico** | 11 | Won first-round game — held a second-half lead over 2-seed Michigan State before falling |
| **Xavier** | 11 | Won First Four game — lost to 6-seed Illinois in the Round of 64 |

> All three Cinderella picks won at least one tournament game. Arkansas came within one possession of the Elite Eight. Auburn reached the final weekend of the tournament. The model identified teams with the right statistical DNA to shine in March.

## Methodology

### Data

- **Source:** Combined KenPom and Barttorvik advanced metrics for every NCAA Tournament team
- **Timeframe:** 2008–2024 (16 tournaments, ~1,100 team-seasons)
- **Features:** 90+ variables including adjusted efficiency margins, tempo, shooting percentages, rebounding rates, experience, recruiting class strength, strength of schedule, and more

### Champion Model

1. Create a binary `CHAMP` variable (1 for each year's champion, 0 for all others)
2. Train a 500-tree Random Forest on the historical dataset
3. Extract variable importance (Mean Decrease Gini) to identify the strongest predictors
4. Analyze the statistical profile of past champions to establish critical thresholds
5. Filter the 2025 field through those thresholds to identify contenders

**Top predictors for Champions:**
- Barttorvik Adjusted Efficiency Margin (BADJ EM) and Rank
- KenPom Adjusted Efficiency Margin (KADJ EM)
- KenPom Adjusted Defensive Efficiency (KADJ D)
- BARTHAG (estimated probability of beating an average D1 team)

### Cinderella Model

1. Isolate all double-digit seeds (10+) from the historical dataset
2. Create a binary `Cinderella` variable (1 if the team reached the Sweet Sixteen or further)
3. Train a separate 500-tree Random Forest on this subset
4. Extract variable importance and critical thresholds from past Cinderellas
5. Apply filters to the 2025 double-digit seeds in two tiers (loose and strict)

**Top predictors for Cinderellas:**
- Recruiting class ranking
- Opponent assist percentage (OP AST%)
- 2-point and 3-point shooting defense rank (2PTRD, 3PTRD)

## Tech Stack

| Tool | Purpose |
|------|---------|
| **R** | Core language |
| **randomForest** | Random Forest classification models |
| **caret** | Model training and evaluation utilities |
| **dplyr** | Data wrangling and transformation |

**To rerun for a future tournament:** Update `KenPom_Barttorvik.csv` with the new year's tournament field data, add the previous year's champion to the `champions` data frame, and run the script. The models retrain automatically on the expanded historical dataset.

## Key Takeaways

- **Champions are defined by elite efficiency on both ends** — adjusted efficiency margin and defensive efficiency are the strongest signals, not raw offensive talent
- **Cinderellas are defined by talent and defensive disruption** — double-digit seeds that make runs tend to have higher ranked recruiting classes than their double digit seeded peers, paired with strong perimeter defense and the ability to force tough shots
- **The model is deliberately conservative** — filtering by critical thresholds from past champions/Cinderellas produces a short list of high-confidence picks rather than a full bracket projection

## Future Work

- Add logistic regression and gradient boosting models for ensemble comparison
- Build a full bracket simulation using win probabilities rather than binary classification
- Incorporate historical betting lines to evaluate the model's edge against the market
- Backtest predictions against past tournaments to measure accuracy over time

## About

Built by **Jack d'Entremont** — MBA candidate (Data Science) at Mount St. Mary's University, Graduate Assistant for Men's Basketball, and former college basketball player at both the DIII and DI levels. This project combines machine learning, sports analytics, and deep domain knowledge of college basketball to make data-driven tournament predictions.
