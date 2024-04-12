# install packages
install.packages("randomForest")
install.packages("kernlab")
install.packages('e1071')
install.packages('caret')
install.packages('knitr')

# load libraries
library(caret)
library(knitr)

# seed for reproduction
seed <- 8
print(paste('Setting seed to ', seed))
set.seed(seed)

# read dataset file
dataset <- read.csv2('http://www.razer.net.br/datasets/Volumes.csv', header=T, dec=',', sep=';')

# prepare data
print('Preparing dataset...')
dataset$NR <- NULL
print('Creating data partition...')
indexes <- createDataPartition(y=dataset$VOL, p=0.80, list=F)
train <- dataset[indexes,]
test <- dataset[-indexes,]

# train models
print('Training models...')
print(' -> Random Forest...')
rf <- caret::train(VOL ~ DAP * DAP * HT, data=train, method='rf')
print(' -> SVM...')
svm <- caret::train(VOL~ DAP * DAP * HT, data=train, method='svmRadial')
print(' -> RNA...')
rna <- caret::train(VOL~ DAP * DAP * HT, data=train, method='nnet')
print(' -> SPURR...')
spurr <- nls(VOL ~ b0 + b1 * DAP * DAP * HT, train, start=list(b0=0.5, b1=0.5))

# predict results
print('Predicting results...')
predict.rf <- predict(rf, test)
predict.svm <- predict(svm, test)
predict.rna <- predict(rna, test)
predict.spurr <- predict(spurr, test)

# generate metrics
r2 <- function(yr, yp) {
  return ( 1 - ( sum( (yr - yp) ^ 2 ) / sum( (yr - mean(yr)) ^ 2 ) ) )
}

erroPadraoEstimativa <- function(yr, yp) {
  n <- length(yr)
  return ( sqrt( sum( (yr - yp) ^ 2 ) / (n - 2) ) )
}

erroPadraoEstimativaPerc <- function(yr, yp) {
  return ( (erroPadraoEstimativa(yr, yp) / mean(yr)) * 100 )
}

print('Generating metrics...')
yr <- test$VOL
results <- data.frame(
  'Random Forest'=c(r2(yr, predict.rf), erroPadraoEstimativa(yr,  predict.rf), erroPadraoEstimativaPerc(yr, predict.rf)),
  'SVM'=c(r2(yr, predict.svm), erroPadraoEstimativa(yr,  predict.svm), erroPadraoEstimativaPerc(yr, predict.svm)),
  'Redes Neurais'=c(r2(yr, predict.rna), erroPadraoEstimativa(yr,  predict.rna), erroPadraoEstimativaPerc(yr, predict.rna)),
  'Modelo Alométrico de SPURR'=c(r2(yr, predict.spurr), erroPadraoEstimativa(yr,  predict.spurr), erroPadraoEstimativaPerc(yr, predict.spurr)),
  row.names = c('R²', 'Erro Padrão da Estimativa', 'Percentual de Erro Padrão da Estimativa')
)

print('Generating presentation...')
table <- knitr::kable(results, 'pipe')
write.table(table, 'iaa3-2.md', quote=F, row.names=F, col.names=F)
print('Done.')
