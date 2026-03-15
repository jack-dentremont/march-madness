#load libraries
library(dplyr)
library(randomForest)
library(caret)

#load data
data <- read.csv("KenPom Barttorvik.csv")

#get rid of unnecessary columns
data <- data %>%
  select(-c(CONF.ID, QUAD.NO, QUAD.ID, TEAM.NO, TEAM.ID, GAMES))

#isolate 2025 field in own df
just2025 <- data %>%
  filter(YEAR == 2025) %>%
  select(-ROUND)

#get rid of 2025 field from historical dataset
data <- data %>%
  filter(YEAR != 2025)

#create champion binary variable
data <- data %>%
  mutate(CHAMP = 0)

#assign values of 1 to appropriate teams in historical dataset
champions <- data.frame(
  team = c("Kansas", "North Carolina", "Duke", "Connecticut", "Kentucky", "Louisville", "Connecticut",
           "Duke", "Villanova", "North Carolina", "Villanova", "Virginia", "Baylor", "Kansas",
           "Connecticut", "Connecticut"),
  year = c(2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2021, 2022,
           2023, 2024)
)
data <- data %>%
  mutate(CHAMP = ifelse(paste(TEAM, YEAR) %in% paste(champions$team, champions$year), 1, 0))

#isolate double digit seeds, both historical and current field
double_digit_seeds_historical <- data %>%
  filter(SEED >= 10) %>%
  select(-CHAMP) %>%
  mutate(Cinderella = ifelse(ROUND <= 16, 1, 0))
double_digit_seeds25 <- just2025 %>%
  filter(SEED >= 10)

#identify predictor variables for CHAMP analysis
str(data)
data$CHAMP <- as.factor(data$CHAMP)
predictors <- data %>%
  select(-c(YEAR, TEAM, CONF, SEED, ROUND))

#run random forest CHAMP analysis
set.seed(2025)
rf_model <- randomForest(CHAMP ~ ., data = predictors,
                         importance = TRUE, ntree = 500)
print(rf_model)

#get variable importance for predicting CHAMP
importance_scores <- importance(rf_model)
importance_df <- data.frame(Variable = rownames(importance_scores),
                            MeanDecreaseGini = importance_scores[, "MeanDecreaseGini"]) %>%
  arrange(desc(MeanDecreaseGini))
print(importance_df)

#identify critical values for top predictors among champions
champions <- data %>% filter(CHAMP == 1)
summary(champions[, c("YEAR", "TEAM", importance_df$Variable[1:5])])

#apply critical values to 2025 field to predict CHAMP
predicted_champ <- just2025 %>%
  filter(BADJ.EM.RANK <= 3,
         BADJ.EM >= 29.09,
         KADJ.EM >= 28.84,
         KADJ.D >= 91.70,
         BARTHAG >= 0.9557)
print(predicted_champ$TEAM)

#identify predictor variables for Cinderella analysis
str(double_digit_seeds_historical)
double_digit_seeds_historical$Cinderella <- as.factor(double_digit_seeds_historical$Cinderella)
predictors_cind <- double_digit_seeds_historical %>%
  select(-c(YEAR, CONF, TEAM, SEED, ROUND))

#run random forest CIND analysis
set.seed(2025)
rf_model_cind <- randomForest(Cinderella ~ ., data = predictors_cind,
                              importance = TRUE, ntree = 500)
print(rf_model_cind)  

#get variable importance for predicting Cind's
importance_scores_cind <- importance(rf_model_cind)
importance_df_cind <- data.frame(Variable = rownames(importance_scores_cind),
                                 MeanDecreaseGini = importance_scores_cind[, "MeanDecreaseGini"]) %>%
  arrange(desc(MeanDecreaseGini))
print(importance_df_cind)

#identify critical values for top predictors among Cinderellas
cinds <- double_digit_seeds_historical %>% filter(Cinderella == 1)
summary(cinds[, importance_df_cind$Variable[1:5]])

#apply critical values to 2025 field to predict Cinderellas
predicted_cinds <- double_digit_seeds25 %>%
  filter(TALENT >= 0.2,
         TALENT.RANK <= 362,
         OP.AST. >= 38.2,
         X2PTRD.RANK <= 347,
         X3PTRD.RANK <= 334)
predicted_cinds_v2 <- predicted_cinds %>%
  filter(TALENT >= 22.78,
         TALENT.RANK <= 112,
         OP.AST. >= 48.4,
         X2PTRD.RANK <= 267,
         X3PTRD.RANK <= 272)
print(predicted_cinds_v2$TEAM)
