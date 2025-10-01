# Code for generating maps (rasters at 25m of spatial resolution) of forest vertical structure for Colombia (South America) from GEDI spaceborne LiDAR.
In this site, we make available the main scripts used to build five national maps at 25m resolution of five forest structural metrics for Colombia, South America, for the year 2020.  We mapped canopy height (CH), the height of half the cumulative returned energy from GEDI (RH50), total canopy cover (COVER), foliage height diversity (FHD), and total plant area index (PAI). The associated journal publication can be found here: J Camilo Fagua, Patrick Jantz, Patrick Burns, Samuel M Jantz, John B. Kilbride, and Scott J Goetz. Maps of forest vertical structure for Colombia, a megadiverse country. Sci Data XX, XX (2025). https://doi.org/XXXX. Maps can be accessed at the links of Google Earth Engine listed at the end and in Zenodo (https://zenodo.org/records/15493516).

To build these maps, the first step is to create the remote sensing predictors, which are of three types: Sentinel-1, Sentinel-2, and ALOS-PALSAR. The GEE folder contains the JavaScript-codes used to process and create the Sentinel-1 and ALOS-PALSAR mosaic-predictors in Google Earth Engine while Folder PYTHON contains the Python-codes for processing and creating the Sentinel-2 mosaic-c in Google Earth Engine.

The second step involves creating the random forest models, predicting the maps, and obtaining the errors based on the sample data (validation using sample data-VSD). The R folder contains the R-script used for the modeling and prediction of CH (MODEL_RF_CH.R) and the R-script used for its VSD (VSD_validation.R). The other models, maps, and validations, COVER, FHD, PAI, and RH50, can be created in the same form based on the CH_modeling.R and VSD_validation.R scripts.

We also included in the R folder a subfolder called gedi_simulator with the scripts used to simulate GEDI footprints using discrete return ALS-LiDAR.


![MAP_SEQUENCE](https://github.com/user-attachments/assets/d4cc9ad4-6ce5-42d3-b7b6-cd4e797915c2)

Maps of forest vertical structure can are also accessible in Google Earth Engine 

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_1_1

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_1_2

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_2_1

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_2_2

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_2_3

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_3_1

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_3_2

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_3_3

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_4_1

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_4_2

projects/ee-jantzenator/assets/colombia_forest_structure/rh50/RH_50_COLOMBIA_FOREST_4_3

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_1_1

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_1_2

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_1_3

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_2_1

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_2_2

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_2_3

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_3_1

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_3_2

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_3_3

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_4_1

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_4_2

projects/ee-jantzenator/assets/colombia_forest_structure/pai/PAI_COLOMBIA_FOREST_4_3

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_1_1

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_1_2

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_1_3

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_2_1

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_2_2

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_2_3

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_3_1

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_3_2

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_3_3

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_4_1

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_4_2

projects/ee-jantzenator/assets/colombia_forest_structure/cover/COVER_COLOMBIA_FOREST_4_3

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_1_1

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_1_2

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_1_3

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_2_1

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_2_2

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_2_3

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_3_1

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_3_2

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_3_3

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_4_1

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_4_2

projects/ee-jantzenator/assets/colombia_forest_structure/ch/CH_COLOMBIA_FOREST_4_3
