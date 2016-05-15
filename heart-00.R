# based on data analyitcs edge, unit 3, The Framingham Heart Study
# Video 3

DEBUG <- TRUE

# Read in the dataset
framingham = read.csv( "data/framingham.csv" )
summary( framingham )

# Look at structure
str( framingham )

# Load the library caTools
library( caTools )

# Randomly split the data into training and testing sets
set.seed( 1000 )
split = sample.split( framingham$TenYearCHD, SplitRatio = 0.65 )

# Split up the data using subset
train = subset( framingham, split == TRUE )
test = subset( framingham, split == FALSE )

# Logistic Regression Model
model_all = glm( TenYearCHD ~ ., data = train, family = binomial )
summary( model_all )$aic

# remove NAs from training set
dim( train )
train_lite <- na.omit( train )
dim( train_lite )

# remove NAs from test set? No need.
dim( test )
test_lite <- na.omit( test )
dim( test )

model_all_lite <- glm( TenYearCHD ~ ., data = train_lite, family = binomial )
summary( model_all_lite )$aic

model_nih <- glm( TenYearCHD ~ male + age + currentSmoker + totChol + sysBP, data = train_lite, family = binomial )
summary( model_nih )$aic
summary( model_nih )

# random forest?
start_time <- proc.time()
model_rf <- randomForest( TenYearCHD ~ male + age + currentSmoker + totChol + sysBP, data = train_lite, do.trace = TRUE, ntrees = 1000 )
proc.time() - start_time
varImpPlot( model_rf, main="Feature Importance" )
summary( model_rf )

# tree
start_time <- proc.time()
model_rp = rpart(TenYearCHD ~ male + age + currentSmoker + totChol + sysBP, data = train_lite, method="class" )
proc.time() - start_time
summary( model_rp )
prediction_probabilities_rp_test = predict( model_rp, newdata = test_lite, type = "class")
head( prediction_probabilities_rp_test )
str( prediction_probabilities_rp_test )

probs = predict( model_rp, newdata = test_lite )
str( probs )
head( probs )

prediction_probabilities_rf_test <- predict( model_rf, newdata = test_lite, type = "class" )
head( prediction_probabilities_rf_test )
mean( prediction_probabilities_rf_test )
max( prediction_probabilities_rf_test )
min( prediction_probabilities_rf_test )
str( prediction_probabilities_rf_test )

str( test_lite )

#print( confusionMatrix( test_lite$TenYearCHD, predictions_rf_test )$overall[ 'Accuracy' ] )
#print( confusionMatrix( test_lite$TenYearCHD, predictions_rf_test )$table )


# this chokes due to NAs...
model_auto <- step( model_all )
summary( model_auto )$aic

# ...this one doesn't
model_auto_lite <- step( model_all_lite )
summary( model_auto_lite )$aic

# review coefficients
summary( model_auto_lite )

# let's remove 000, 000, 000 from model?

# Predictions on the training set
predict_train_all <- predict( model_all, type="response", newdata = train )
predict_train_auto_lite <- predict( model_auto_lite, type="response", newdata = train_lite )
predict_train_nih <- predict( model_nih, type="response", newdata = train_lite )

# Confusion matrix with threshold of 0.5
c_table_train_all <- table( train$TenYearCHD, predict_train_all > 0.5 )
c_table_train_auto_lite <- table( train_lite$TenYearCHD, predict_train_auto_lite > 0.5 )
c_table_train_nih_lite <- table( train_lite$TenYearCHD, predict_train_nih > 0.5 )
c_table_test_nih_lite_rf <- table( test_lite$TenYearCHD, prediction_probabilities_rf_test > 0.1504017 )

get_accuracy <- function( table ) {
    
    # if ( DEBUG ) {
    #     print( table[ 1, 1 ] )
    #     print( table[ 2, 2 ] )
    #     print( sum( table ) ) 
    # }
    ( table[ 1, 1 ] + table[ 2, 2 ] ) / sum( table )
}
# Accuracy of training set(s)
get_accuracy( c_table_train_all )

# Accuracy of training set(s) lite
get_accuracy( c_table_train_auto_lite )

# Accuracy based on nih.
get_accuracy( c_table_train_nih_lite )

c_table_test_nih_lite_rf
get_accuracy( c_table_test_nih_lite_rf )

# Predictions on the test set
predict_test_all = predict( model_all, type="response", newdata = test )
predict_test_auto_lite = predict( model_auto_lite, type="response", newdata = test )
predict_test_nih_lite = predict( model_nih, type="response", newdata = test )

# Confusion matrix with threshold of 0.5
c_table_test_all <- table( test$TenYearCHD, predict_test_all > 0.5 )
c_table_test_auto_lite <- table( test$TenYearCHD, predict_test_auto_lite > 0.5 )
c_table_test_nih_lite <- table( test$TenYearCHD, predict_test_nih_lite > 0.5 )

# Accuracy of test set(s)
get_accuracy( c_table_test_all )

# Accuracy of test set(s) lite
get_accuracy( c_table_test_auto_lite )

# Nih model
get_accuracy( c_table_test_nih_lite )

# Test set AUC 
library(ROCR)
ROCRpred = prediction( predict_test_all, test$TenYearCHD )
as.numeric( performance(ROCRpred, "auc")@y.values )

# predict for myself
summary( model_auto_lite )

me <- test[ 1, ]
me$male <- 1
me$age <- 54
me$education <- -1
me$currentSmoker <- -1
me$cigsPerDay <- 0
me$BPMeds <- -1
me$prevalentStroke <- 0
me$prevalentHyp <- 0
me$diabetes <- -1
me$totChol <- 217
me$sysBP <- 127
me$diaBP <- -1
me$BMI <- -1
me$heartRate <- 77
me$glucose <- 130
me$TenYearCHD <- -1
me

# rpart model
predict_me <- predict( model_rp, newdata = me )
predict_me

# auto-lite version
predict_me <- predict( model_auto_lite, type="response", newdata = me )
predict_me

# nih-lite
predict_me <- predict( model_nih, type="response", newdata = me )
predict_me

predict_me <- predict( model_rf, newdata = me, type = "class" ) #class is syn for response
predict_me

age <- log( 54 )
age_b <- 3.06117

# NOW
chol <- log( 217 )
hdl <- log( 52 )
systolic <- log( 127 )

# FUTURE
# chol <- log( 180 )
# hdl <- log( 58 )
# systolic <- log( 120 )

chol_b <- 1.12370
hdl_b <- -0.93263
systolic_b <- 1.93303

smoking <- 0
smoking_b <- 0.65451
diabetes <- 0
diabetes_b <- 0.57367

sum_b_x <- age * age_b + chol * chol_b + hdl * hdl_b + systolic * systolic_b + smoking * smoking_b + diabetes * diabetes_b 

1 - ( 0.88936 * exp( sum_b_x - 23.9802 ) )

# get basic stats
mean( predict_train_nih )
max( predict_train_nih )
min( predict_train_nih )
#worst odds
max( predict_train_nih ) / ( 1 - max( predict_train_nih ) )
