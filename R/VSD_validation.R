#Author:

#Jose Camilo Fagua
#jcfaguag@unal.edu.co
#Profesor asistente
#Departamento de Biología
#Universidad Nacional de Colombia

#Libriries and packages  
library(Metrics)
library(data.table)

#Clean environment  
rm(list = ls(all.names = TRUE)) 
gc()
#
#INPUT DATA
TABLA = fread("DATA_TO_TEST.csv")
TABLA_2 = subset(TABLA, FOREST_1 == 1)
TABLA_3 = data.frame(TABLA_2$rh_95_a0, TABLA_2$ORINOCO_rh_95)
TABLA_3 = TABLA_3[complete.cases(TABLA_3), ]
#
names(TABLA_3) = c("Actual_value", "Predicted_value")
#
#creation of resamples
n = 10
samples_list <- vector("list", n)

for (i in 1:n) {
  samples_list[[i]] <- TABLA_3[sample(nrow(TABLA_3), 1000), ]
}

#Error estimation
RAE = sapply(samples_list, function(sample) rae(sample$Actual_value, sample$Predicted_value))
RRSE = sapply(samples_list, function(sample) rrse(sample$Actual_value, sample$Predicted_value))
MAE = sapply(samples_list, function(sample) mae(sample$Actual_value, sample$Predicted_value))
RMSE = sapply(samples_list, function(sample) rmse(sample$Actual_value, sample$Predicted_value))
#

RAE#Relative Absolute Error
RRSE#Root Relative Squared Error
MAE#Mean Absolute Error
RMSE#Root Mean Squared Error
#
Region = rep("Orinoco", 10)
Variable = rep("CH",10)

TABLA_4 = data.frame(PERC_BIAS,RAE,RMSE,RRSE,RMS,RSE,SMAPE,MAPE,MAE, Region, Variable)
TABLA_4



