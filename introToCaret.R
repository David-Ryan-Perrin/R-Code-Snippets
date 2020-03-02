library(caret)
library(mlbench)
data(Sonar)

set.seed(107)

inTrain <- createDataPartition(
  y = Sonar$Class,
  p = 0.75,
  list = FALSE
)
str(inTrain)

training <- Sonar[inTrain,]
testing <- Sonar[-inTrain,]

ctrl <- trainControl(method = "repeatedcv", 
                     repeats = 10,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)
plsFit <- train(
  Class ~ .,
  data = training,
  method = "pls",
  preProc = c("center", "scale"),
  tuneLength = 15,
  trControl = ctrl,
  metric = "ROC"
)

plsFit


ggplot(plsFit)


plsClasses <- predict(plsFit, newdata = testing)
str(plsClasses)


plsProbs <- predict(plsFit, newdata = testing, type = "prob")
head(plsProbs)

confusionMatrix(data = plsClasses, testing$Class)



rdaGrid = data.frame(gamma = (0:4)/4, lambda = 3/4)
set.seed(123)
rdaFit <- train(
  Class ~ .,
  data = training,
  method = "rda",
  tuneGrid = rdaGrid,
  trControl = ctrl,
  metric = "ROC"
)

rdaFit

rdaClasses <- predict(rdaFit, newdata = testing)

ggplot(rdaFit)

confusionMatrix(rdaClasses, testing$Class)


# Resample and compare models

resamps <- resamples(list(pls = plsFit, rda = rdaFit))
summary(resamps)


xyplot(resamps, what = "BlandAltman")


fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)




set.seed(825)


gbmFit1 <- train(
  Class ~ .,
  data = training,
  method = "gbm",
  trControl = fitControl,
  verbose = FALSE
)

gbmFit1


ggplot(gbmFit1)

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (1:30)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

gbmFit2 <- train(
  Class ~ .,
  data = training,
  method = "gbm",
  trControl = fitControl,
  verbose = FALSE,
  tuneGrid = gbmGrid
)

gbmFit2


trellis.par.set(caretTheme())
ggplot(gbmFit2)



fitControl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 10,
                           ## Estimate class probabilities
                           classProbs = TRUE,
                           ## Evaluate performance using 
                           ## the following function
                           summaryFunction = twoClassSummary)

set.seed(825)
gbmFit3 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 tuneGrid = gbmGrid,
                 ## Specify which metric to optimize
                 metric = "ROC")
gbmFit3

ggplot(gbmFit3)

gbmFit3Classes <- predict(gbmFit3, newdata = testing)

confusionMatrix(gbmFit3Classes, testing$Class)


densityplot(gbmFit3, pch = "|")


















