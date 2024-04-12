# SVM

## Matriz de Confusão

|                    | red soil| cotton crop| grey soil| damp grey soil| vegetation stubble| very damp grey soil|
|:-------------------|--------:|-----------:|---------:|--------------:|------------------:|-------------------:|
|red soil            |      304|           0|         2|              5|                  9|                   1|
|cotton crop         |        0|         126|         0|              0|                  1|                   0|
|grey soil           |        1|           0|       262|             27|                  1|                  16|
|damp grey soil      |        0|           0|         7|             60|                  0|                  29|
|vegetation stubble  |        1|          13|         0|              0|                116|                  11|
|very damp grey soil |        0|           1|         0|             33|                 14|                 244|

## Resultados

|Propriedade    |     Valor|
|:--------------|---------:|
|Accuracy       | 0.8660436|
|Kappa          | 0.8339089|
|AccuracyLower  | 0.8461848|
|AccuracyUpper  | 0.8842089|
|AccuracyNull   | 0.2383178|
|AccuracyPValue | 0.0000000|
|McnemarPValue  |       NaN|
