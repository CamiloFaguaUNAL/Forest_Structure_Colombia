# Code for generating maps (rasters at 25m of spatial resolution) of forest vertical structure for Colombia (South America) from GEDI spaceborne LiDAR.
Maps can be accessed at the links of Google Earth Engine listed at the end. The associated journal publication can be found here: J Camilo Fagua, Patrick Jantz, Patrick Burns, Samuel M Jantz, John B. Kilbride, and Scott J Goetz. Maps of forest vertical structure for Colombia, a megadiverse country. Sci Data XX, XX (2025). https://doi.org/XXXX
Folder GEE includes the JavaScript-codes used to process the Sentinel-1 and ALOS-PALSAR imagery in Google Earth Engine. Folder PYTHON contains the Python-codes for processing the Sentinel-2 imagery in Google Earth Engine. R folder contains the R-codes used to simulate GEDI footprints from discrete ALS-lidar data.

![MAP_SEQUENCE](https://github.com/user-attachments/assets/d4cc9ad4-6ce5-42d3-b7b6-cd4e797915c2)

Maps of forest vertical structure can are also accessible in Google Earth Engine: 
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
