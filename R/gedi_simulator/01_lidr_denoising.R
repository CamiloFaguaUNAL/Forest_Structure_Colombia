# install.packages('lasR', repos = 'https://r-lidar.r-universe.dev')

library(lidR)

# Define a path to the folder with the las Files
input_folder = "B:/Colombia_ALS/raw"

# Define a path to the output folder
output_folder = "B:/Colombia_ALS/denoised"

# Create the las catalogue
ctg = lidR::readLAScatalog(input_folder)
opt_output_files(ctg) <- paste0(output_folder, "/{ORIGINALFILENAME}")

# Classify noise
ctg = classify_noise(ctg, algorithm = sor(10, 2))
