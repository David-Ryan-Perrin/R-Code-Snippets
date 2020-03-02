library(caret)
data("iris")

library("AppliedPredictiveModeling")

transparentTheme(trans = 0.4)
str(iris)

featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = "pairs",
            # add a key at the top
            auto.key = list(columns = 3))

transparentTheme(trans = .9)
featurePlot(x = iris[, 1:4], 
            y = iris$Species,
            plot = "density", 
            ## Pass in options to xyplot() to 
            ## make it prettier
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")), 
            adjust = 1.5, 
            pch = "|", 
            layout = c(4, 1), 
            auto.key = list(columns = 3))