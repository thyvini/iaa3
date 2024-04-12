# install packages
install.packages("e1071")
install.packages("randomForest")
install.packages("kernlab")
install.packages("mlbench")
install.packages('caret')
install.packages('knitr') # markdown table

# load libraries
library('mlbench')
library('caret')
library('knitr')

# seed for reproduction
seed <- 4
print(paste('Setting seed to ', seed))
set.seed(seed)

# prepare data
print('Preparing dataset...')
data(Satellite)
database <- Satellite
print('Creating data partition...')
indexes <- createDataPartition(database$classes, p=0.80, list=F)
train <- database[indexes,]
test <- database[-indexes,]

# train models
print('Training models...')
formula <- (classes ~ x.17 + x.18 + x.19 + x.20)
print(' -> Random Forest...')
rf <- train(formula, data=train, method='rf')
print(' -> SVM...')
svm <- train(formula, data=train, method='svmRadial')
print(' -> RNA...')
rna <- train(formula, data=train, method='nnet', trace=F)

# predict results
print('Predicting results...')
predict.rf <- predict(rf, test)
predict.svm <- predict(svm, test)
predict.rna <- predict(rna, test)

# function to generate the markdown files
generatePresentation <- function (predicted, testData, modelName, fileName) {
  # generate confusion matrix
  cm <- confusionMatrix(predicted, testData$classes)

  # covert confusion matrix to a printable format
  matrixTable <- paste(knitr::kable(cm$table, 'pipe'), collapse='\n')

  # get overall results in printable format
  overall <- paste(knitr::kable(as.data.frame(cm$overall), 'pipe', col.names=c('Propriedade', 'Valor')), collapse='\n')

  # generate text
  text <- paste(c("# ", toupper(modelName), "\n\n## Matriz de Confusão\n\n", matrixTable, "\n\n## Resultados\n\n", overall), collapse='')

  # create file
  write.table(text, fileName, quote=F, row.names=F, col.names=F)
}

# generate for each model
print('Generating presentation...')
generatePresentation(predict.rf, test, 'random forest', 'iaa3-1-rf.md')
generatePresentation(predict.svm, test, 'svm', 'iaa3-1-svm.md')
generatePresentation(predict.rna, test, 'rna', 'iaa3-1-rna.md')
print('Done.')
