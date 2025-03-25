#Authors:

  #Jose Camilo Fagua
#jcfaguag@unal.edu.co
#Profesor asistente
#Departamento de Biología
#Universidad Nacional de Colombia

  #Patrick Jantz
#Assistant Research Professor
#Global Earth Observation & Dynamics of Ecosystems Lab (GEODE)
#School of Informatics, Computing & Cyber Systems-Northern Arizona University


#Libriries and packages  
library(data.table)
library(caret)
library(rgdal)
library(raster)
library(dplyr)
library(Metrics)

#Clean environment  
rm(list = ls(all.names = TRUE)) 
gc()
#
#INPUT DATA
#The .csv files of GEDI
read.table = list.files(path = ".", pattern=".csv", full.names=TRUE)
list.table = lapply(read.table, fread)
dim(list.table[[1]])
dim(list.table[[2]])
dim(list.table[[3]])
dim(list.table[[4]])
length(list.table)
CSVs = seq(1,length(list.table),1)
CSVs
#
#The .shp of the study area
REGION = readOGR(dsn = ".", layer = "study_area.shp")
#
#To name variables 
VARS = c("lon_lm_a0","lat_lm_a0",
         #
         "rh_95_a0","rh_50_a0", "pai_0", "fhd_pai_1m_a0", "cover_a0",
         #
         "FOREST_1","year","trte",
         #
         "SENT_1_MEAN_ORINOCO.1","SENT_1_MEAN_ORINOCO.2", 
         "SENT_1_MEAN_ORINOCO.3","SENT_1_MEAN_ORINOCO.4",
         "SENT_1_SD_ORINOCO.1", "SENT_1_SD_ORINOCO.2",
         "SENT_1_SD_ORINOCO.3", "SENT_1_SD_ORINOCO.4",
         "SENT_1_DVAR_ORINOCO.1","SENT_1_DVAR_ORINOCO.2",
         "SENT_1_DVAR_ORINOCO.3","SENT_1_DVAR_ORINOCO.4",
         "SENT_1_SAVG_ORINOCO.1","SENT_1_SAVG_ORINOCO.2",
         "SENT_1_SAVG_ORINOCO.3","SENT_1_SAVG_ORINOCO.4",
         "SENT_2_MEAN_ORINOCO.1","SENT_2_MEAN_ORINOCO.2",
         "SENT_2_MEAN_ORINOCO.3","SENT_2_MEAN_ORINOCO.4",
         "SENT_2_MEAN_ORINOCO.5","SENT_2_MEAN_ORINOCO.6",
         "SENT_2_MEAN_ORINOCO.7","SENT_2_MEAN_ORINOCO.8",
         "SENT_2_MEAN_ORINOCO.9","SENT_2_MEAN_ORINOCO.10",
         "SENT_2_MEAN_ORINOCO.11","SENT_2_MEAN_ORINOCO.12",
         "SENT_2_MEAN_ORINOCO.13","SENT_2_MEAN_ORINOCO.14",
         "SENT_2_MEAN_ORINOCO.15","SENT_2_SD_ORINOCO.1",
         "SENT_2_SD_ORINOCO.2","SENT_2_SD_ORINOCO.3",
         "SENT_2_SD_ORINOCO.4","SENT_2_SD_ORINOCO.5",
         "SENT_2_SD_ORINOCO.6","SENT_2_SD_ORINOCO.7",
         "SENT_2_SD_ORINOCO.8","SENT_2_SD_ORINOCO.9",
         "SENT_2_SD_ORINOCO.10","SENT_2_SD_ORINOCO.11",
         "SENT_2_SD_ORINOCO.12","SENT_2_SD_ORINOCO.13",
         "SENT_2_SD_ORINOCO.14","SENT_2_SD_ORINOCO.15",
         "SENT_2_DVAR_ORINOCO.1","SENT_2_DVAR_ORINOCO.2",
         "SENT_2_DVAR_ORINOCO.3","SENT_2_DVAR_ORINOCO.4",
         "SENT_2_DVAR_ORINOCO.5","SENT_2_DVAR_ORINOCO.6",
         "SENT_2_DVAR_ORINOCO.7","SENT_2_DVAR_ORINOCO.8",
         "SENT_2_DVAR_ORINOCO.9","SENT_2_DVAR_ORINOCO.10",
         "SENT_2_DVAR_ORINOCO.11","SENT_2_DVAR_ORINOCO.12",
         "SENT_2_DVAR_ORINOCO.13","SENT_2_DVAR_ORINOCO.14",
         "SENT_2_DVAR_ORINOCO.15","SENT_2_SAVG_ORINOCO.1",
         "SENT_2_SAVG_ORINOCO.2","SENT_2_SAVG_ORINOCO.3",
         "SENT_2_SAVG_ORINOCO.4","SENT_2_SAVG_ORINOCO.5",
         "SENT_2_SAVG_ORINOCO.6","SENT_2_SAVG_ORINOCO.7",
         "SENT_2_SAVG_ORINOCO.8","SENT_2_SAVG_ORINOCO.9",
         "SENT_2_SAVG_ORINOCO.10","SENT_2_SAVG_ORINOCO.11",
         "SENT_2_SAVG_ORINOCO.12","SENT_2_SAVG_ORINOCO.13",
         "SENT_2_SAVG_ORINOCO.14","SENT_2_SAVG_ORINOCO.15",
         "PALSAR_ORINOCO.1","PALSAR_ORINOCO.2","PALSAR_DVAR_ORINOCO.1",
         "PALSAR_DVAR_ORINOCO.2","PALSAR_SAVG_ORINOCO.1","PALSAR_SAVG_ORINOCO.2") 

VARS
#
list.table_2 = list()
#
IMG = list()
count = 1

for(i in 1:length(CSVs)) {
  T_1 = list.table[[i]]
  T_1 = T_1 %>% select(VARS)
  list.table_2[[i]] = T_1
}

# Main table  
TABLA = rbindlist(list.table_2, use.names=TRUE, fill=TRUE)
dim(TABLA)
names(TABLA)

#Reduce non-forest data based on Colombia's 2020 forest coverage
TABLA_2 = subset(TABLA, FOREST_1 == 1)
dim(TABLA_2)
names(TABLA_2)
dim(TABLA_2)
n = round(nrow(TABLA_2)/20)

TABLA_3 = subset(TABLA, FOREST_1 == 0)
TABLA_3 = TABLA_3[sample(nrow(TABLA_3), n), ]
dim(TABLA_3)
#
TABLA_4 = rbind(TABLA_2, TABLA_3)
names(TABLA_4)

TABLA_4 = TABLA_4[complete.cases(TABLA_4), ]
names(TABLA_4)
dim(TABLA_4)

#Extraction of predictors to the main table
point.to.clip = SpatialPointsDataFrame(coords = TABLA_4[,c("lon_lm_a0","lat_lm_a0" )], data = TABLA_4,
                                       proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))


points.cliped = crop(point.to.clip, REGION)
dim(points.cliped)
class(points.cliped)
#
TABLA_4 = data.frame(points.cliped)
names(TABLA_4)
head(TABLA_4)
dim(TABLA_4)

TABLA_4 = TABLA_4[sample(nrow(TABLA_4), 1500000), ]
dim(TABLA_4)

write.csv(TABLA_4,"TABLE_USED_TO_MODEL.csv", 
          row.names = T)

#Data partitioning
set.seed(1)
trainIndex <- createDataPartition(TABLA_4$rh_95_a0, p = .8, 
list = FALSE, 
times = 1)
#
TABLA_4 = TABLA_4[ trainIndex,]
names(TABLA_4)
Test  = TABLA_4[-trainIndex,]
write.csv(Test,"DATA_TO_TEST.csv", row.names = T)

# Read predicors

S1_mean = brick("SENT_1_MEAN_ORINOCO.tif")
S1_sd = brick("SENT_1_SD_ORINOCO.tif")
S1_dvar = brick("SENT_1_DVAR_ORINOCO.tif")
S1_savg = brick(".SENT_1_SAVG_ORINOCO.tif")
#
S2_mean = brick(".SENT_2_MEAN_ORINOCO.tif")
S2_sd = brick("SENT_2_SD_ORINOCO.tif")
S2_dvar = brick("SENT_2_DVAR_ORINOCO.tif")
S2_savg = brick("SENT_2_SAVG_ORINOCO.tif")
#
PALSAR = brick("PALSAR_ORINOCO.tif")
PALSAR_dvar = brick("PALSAR_DVAR_ORINOCO.tif")
PALSAR_savg = brick("PALSAR_SAVG_ORINOCO.tif")

RASTER.PREDICTORS = stack(S1_mean,S1_sd,S1_dvar,S1_savg,
                          S2_mean,S2_sd,S2_dvar,S2_savg,
                          PALSAR,PALSAR_dvar,PALSAR_savg)



names(RASTER.PREDICTORS)

#To rename variables 
VARS_2 = c("rh_95_a0",
           #
           "SENT_1_MEAN_ORINOCO.1","SENT_1_MEAN_ORINOCO.2", 
           "SENT_1_MEAN_ORINOCO.3","SENT_1_MEAN_ORINOCO.4",
           "SENT_1_SD_ORINOCO.1", "SENT_1_SD_ORINOCO.2",
           "SENT_1_SD_ORINOCO.3", "SENT_1_SD_ORINOCO.4",
           "SENT_1_DVAR_ORINOCO.1","SENT_1_DVAR_ORINOCO.2",
           "SENT_1_DVAR_ORINOCO.3","SENT_1_DVAR_ORINOCO.4",
           "SENT_1_SAVG_ORINOCO.1","SENT_1_SAVG_ORINOCO.2",
           "SENT_1_SAVG_ORINOCO.3","SENT_1_SAVG_ORINOCO.4",
           "SENT_2_MEAN_ORINOCO.1","SENT_2_MEAN_ORINOCO.2",
           "SENT_2_MEAN_ORINOCO.3","SENT_2_MEAN_ORINOCO.4",
           "SENT_2_MEAN_ORINOCO.5","SENT_2_MEAN_ORINOCO.6",
           "SENT_2_MEAN_ORINOCO.7","SENT_2_MEAN_ORINOCO.8",
           "SENT_2_MEAN_ORINOCO.9","SENT_2_MEAN_ORINOCO.10",
           "SENT_2_MEAN_ORINOCO.11","SENT_2_MEAN_ORINOCO.12",
           "SENT_2_MEAN_ORINOCO.13","SENT_2_MEAN_ORINOCO.14",
           "SENT_2_MEAN_ORINOCO.15","SENT_2_SD_ORINOCO.1",
           "SENT_2_SD_ORINOCO.2","SENT_2_SD_ORINOCO.3",
           "SENT_2_SD_ORINOCO.4","SENT_2_SD_ORINOCO.5",
           "SENT_2_SD_ORINOCO.6","SENT_2_SD_ORINOCO.7",
           "SENT_2_SD_ORINOCO.8","SENT_2_SD_ORINOCO.9",
           "SENT_2_SD_ORINOCO.10","SENT_2_SD_ORINOCO.11",
           "SENT_2_SD_ORINOCO.12","SENT_2_SD_ORINOCO.13",
           "SENT_2_SD_ORINOCO.14","SENT_2_SD_ORINOCO.15",
           "SENT_2_DVAR_ORINOCO.1","SENT_2_DVAR_ORINOCO.2",
           "SENT_2_DVAR_ORINOCO.3","SENT_2_DVAR_ORINOCO.4",
           "SENT_2_DVAR_ORINOCO.5","SENT_2_DVAR_ORINOCO.6",
           "SENT_2_DVAR_ORINOCO.7","SENT_2_DVAR_ORINOCO.8",
           "SENT_2_DVAR_ORINOCO.9","SENT_2_DVAR_ORINOCO.10",
           "SENT_2_DVAR_ORINOCO.11","SENT_2_DVAR_ORINOCO.12",
           "SENT_2_DVAR_ORINOCO.13","SENT_2_DVAR_ORINOCO.14",
           "SENT_2_DVAR_ORINOCO.15","SENT_2_SAVG_ORINOCO.1",
           "SENT_2_SAVG_ORINOCO.2","SENT_2_SAVG_ORINOCO.3",
           "SENT_2_SAVG_ORINOCO.4","SENT_2_SAVG_ORINOCO.5",
           "SENT_2_SAVG_ORINOCO.6","SENT_2_SAVG_ORINOCO.7",
           "SENT_2_SAVG_ORINOCO.8","SENT_2_SAVG_ORINOCO.9",
           "SENT_2_SAVG_ORINOCO.10","SENT_2_SAVG_ORINOCO.11",
           "SENT_2_SAVG_ORINOCO.12","SENT_2_SAVG_ORINOCO.13",
           "SENT_2_SAVG_ORINOCO.14","SENT_2_SAVG_ORINOCO.15",
           "PALSAR_ORINOCO.1","PALSAR_ORINOCO.2","PALSAR_DVAR_ORINOCO.1",
           "PALSAR_DVAR_ORINOCO.2","PALSAR_SAVG_ORINOCO.1","PALSAR_SAVG_ORINOCO.2") 




TABLA_4 = subset(TABLA_4, trte == "tr")

TABLA_4 = TABLA_4 %>% select(VARS_2)

head(TABLA_4)
dim(TABLA_4)

TABLA_4 = TABLA_4[complete.cases(TABLA_4), ]
dim(TABLA_4)

names1= c(names(RASTER.PREDICTORS))
names(TABLA_4) = c("rh_95_a0",names1)

#Spatial modeling f he Random Forest regression     
RANGER.REGRE = train(rh_95_a0~., data=TABLA_4, method = "ranger",num.trees = 2000) 
saveRDS(RANGER.REGRE, "CH_model.rds")
RANGER.MAPA = predict(RASTER.PREDICTORS,RANGER.REGRE)

writeRaster(RANGER.MAPA, 
            filename = "CH_MAP.tif", 
            format = "GTiff")

# Table for Validation using sample data (VSD), 

TABLA_TO_TEST = fread("DATA_TO_TEST.csv") 
TABLA = subset(TABLA, trte == "te")
# 
IMG = raster("CH_MAP.tif")
#
point.to.extract = SpatialPointsDataFrame(coords = TABLA[,c("lon_lm_a0","lat_lm_a0" )], data = TABLA,
                                          proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#
extraction.table =extract(IMG, point.to.extract)
TABLA_2 = data.frame(extraction.table,point.to.extract)
#
TABLA_2 = TABLA_2[,c("extraction.table", "rh_95_a0")] 
TABLA_2 = TABLA_2[complete.cases(TABLA_2), ]






