# Code for generating maps (rasters at 25m of spatial resolution) of forest vertical structure for Colombia (South America) from GEDI spaceborne LiDAR.
In this site, we make available the main scripts used to build five national maps at 25m resolution of five forest structural metrics for Colombia, South America, for the year 2020.  We mapped canopy height (CH), the height of half the cumulative returned energy from GEDI (RH50), total canopy cover (COVER), foliage height diversity (FHD), and total plant area index (PAI). The associated journal publication can be found here: J Camilo Fagua, Patrick Jantz, Patrick Burns, Samuel M Jantz, John B. Kilbride, and Scott J Goetz. Maps of forest vertical structure for Colombia, a megadiverse country. Sci Data XX, XX (2025). https://doi.org/XXXX. Maps can be accessed at the links of Google Earth Engine listed at the end and in Zenodo (https://zenodo.org/records/15493516).

To build these maps, the first step is to create the remote sensing predictors, which are of three types: Sentinel-1, Sentinel-2, and ALOS-PALSAR. The GEE folder contains the JavaScript-codes used to process and create the Sentinel-1 and ALOS-PALSAR mosaic-predictors in Google Earth Engine while Folder PYTHON contains the Python-codes for processing and creating the Sentinel-2 mosaic-c in Google Earth Engine.

The second step involves creating the random forest models, predicting the maps, and obtaining the errors based on the sample data (validation using sample data-VSD). The R folder contains the R-script used for the modeling and prediction of CH (MODEL_RF_CH.R) and the R-script used for its VSD (VSD_validation.R). The other models, maps, and validations, COVER, FHD, PAI, and RH50, can be created in the same form based on the CH_modeling.R and VSD_validation.R scripts.

We also included in the R folder a subfolder called gedi_simulator with the scripts used to simulate GEDI footprints using discrete return ALS-LiDAR.


![MAP_SEQUENCE](https://github.com/user-attachments/assets/d4cc9ad4-6ce5-42d3-b7b6-cd4e797915c2)

Tile shapefile
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/COLOMBIA_FOREST_TILES
 
CH (canopy height)

https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_1
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_2
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_3
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_4
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_5
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_6
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_7
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_8
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_9
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_10
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_11

COVER (canopy cover)

https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_1
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_2
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_3
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_4
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_5
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_6
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_7
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_8
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_9
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_10
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_11

FHD_PAI (foliage height diversity calculated from plant area index)

https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_1
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_2
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_3
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_4
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_5
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_6
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_7
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_8
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_9
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_10
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/fhd_pai/FHD_PAI_COLOMBIA_FOREST_11

PAI (plant area index)

https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_1
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_2
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_3
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_4
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_5
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_6
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_7
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_8
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_9
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_10
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_11

RH50 (height at which 50% of lidar energy is returned)

https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_1
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_2
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_3
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_4
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_5
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_6
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_7
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_8
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_9
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_10
https://code.earthengine.google.com/?asset=projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH50_COLOMBIA_FOREST_11

