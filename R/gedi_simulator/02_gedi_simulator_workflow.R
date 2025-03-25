
# devtools::install_github("carlos-alberto-silva/rGEDI", dependencies = TRUE)
# devtools::install_github("caiohamamura/Rgedisimulator", dependencies = TRUE)

library(sf)
library(lidR)  
library(terra)
library(spatstat.geom)
library(concaveman)
library(exactextractr)
library(rGEDI)
library(rGEDIsimulator)

library(foreach)
library(doParallel)




# Generate a folder if it doesn't already exist
create_folder = function(folder_path) {
  if (!dir.exists(folder_path)) {
    dir.create(folder_path, recursive = TRUE)
  }
}

# Get the cell centroids that fall w/in the polygon
get_centroids_within_polygon = function(polygon, raster_path) {
  
  # Read the raster (in a way that doesn't load the full data into memory)
  r = rast(raster_path)
  
  # Reproject the polygon to match the raster's coordinate reference system
  polygon_raster_crs = st_transform(polygon, crs(r))
  
  # Use exact_extract to determine coverage fraction of each cell. This avoids
  # loading the entire raster into memory.
  coverage_list = exact_extract(
    r, 
    polygon_raster_crs, 
    include_xy = TRUE
  )
  
  # We only have one polygon here, so get the first element of the list.
  coverage_df = coverage_list[[1]]
  
  # Keep only the rows where coverage_fraction == 1 (fully within the polygon).
  coverage_df = coverage_df[coverage_df$coverage_fraction == 1, ]
  
  # Convert these centers to an sf object using the raster's CRS.
  centroids_sf = st_as_sf(coverage_df, coords = c("x", "y"), crs = crs(r))
  
  # Reproject the centroids back to the original polygon's CRS
  centroids_sf = st_transform(centroids_sf, st_crs(polygon))
  
  return(centroids_sf)
  
}


# Compute simulated waveforms
run_gedi_wfs_with_als = function (als_path, 
                                  als_crs, 
                                  raster_path, 
                                  output_coords_folder,
                                  output_waveform_folder,
                                  output_metrics_folder,
                                  output_geojson_folder) {
  
  # Create the output folders (if they don't exist)
  create_folder(output_coords_folder)
  create_folder(output_waveform_folder)
  create_folder(output_metrics_folder)
  create_folder(output_geojson_folder)
  
  # Get the input file path name w/out extension
  als_basename = tools::file_path_sans_ext(basename(als_path))
  
  # Reading and plot ALS file 
  als_data = lidR::readLAS(als_path)
  lidR::st_crs(als_data) = als_crs
  
  # Get the concave hull
  concave_hull = lidR::st_concave_hull(als_data)
  rm(als_data)
  
  # Get the centroids to extract
  centroids = get_centroids_within_polygon(concave_hull, raster_path)
  
  # Extract X and Y coordinates as a DataFrame
  coords_matrix = st_coordinates(centroids)
  coords_df = data.frame(
    X = coords_matrix[,1], 
    Y = coords_matrix[,2]
  )
  
  # Save the coordinates as a TXT file (required by WFS)
  output_coord_path = file.path(output_coords_folder, paste0(als_basename, ".txt"))
  write.table(
    x = coords_df, 
    file = output_coord_path, 
    row.names = FALSE, 
    col.names = FALSE, 
    quote = FALSE
  )
  
  # Run the GEDI Waveform Simulator
  output_wf_path = file.path(output_waveform_folder, paste0(als_basename, ".h5"))
  wf_simulator_out <- gediWFSimulator(
    input = als_path,
    output = output_wf_path,
    listCoord = output_coord_path,
    keepOld = FALSE
  )
  
  # Compute the relevant GEDI metrics from the waveform
  output_wf_path = file.path(output_metrics_folder, paste0(als_basename))
  wf_metrics_df = gediWFMetrics(
    input = wf_simulator_out,
    outRoot = output_wf_path
  )
  
  # Save the simulated GEDI metrics as a geojson
  output_geojson_path = file.path(output_geojson_folder, paste0(als_basename, ".geojson"))
  geo_df = sf::st_as_sf(wf_metrics_df, coords = c("lon", "lat"), crs = als_crs)
  sf::st_write(geo_df, output_geojson_path, driver = "GeoJSON",  append=FALSE)
  
  # Close the waveform object
  close(wf_simulator_out)

}

################################################################################
################################################################################
################################################################################

# Define the folder that contains the las files
las_folder = "B:/Colombia_ALS/denoised"

# Define the CRS associated with the LAS data
crs_code = 32618

# Define the raster layer that will be used for validation
reference_raster_path = "C:/Users/johnb/Desktop/demo_lidar/demonstration_raster/FHD_CHOCO.tif"

# Define the where the outputs will be stored (folders will be created)
coords_folder = "B:/Colombia_ALS/simulator_outputs/simulated_coordinates"
waveform_folder = "B:/Colombia_ALS/simulator_outputs/simulated_waveforms"
metrics_folder = "B:/Colombia_ALS/simulator_outputs/simulated_metrics"
geojson_folder = "B:/Colombia_ALS/simulator_outputs/simulated_metrics_geojson"

# Make the output folders if necessary
folders = c(coords_folder, waveform_folder, metrics_folder, geojson_folder)
for (f in folders) {
  if (!dir.exists(f)) {
    dir.create(f, recursive = TRUE)
  }
}

# Get all LAS files in the folder
las_files = list.files(las_folder, pattern = "\\.las$", full.names = TRUE)

# Get all of the completed GEOJSON files
geojson_files = list.files(geojson_folder, pattern = "\\.geojson$", full.names = TRUE)

# Drop any LAS files that were already processed
las_files_needed = las_files[!tools::file_path_sans_ext(basename(las_files)) %in%
                                tools::file_path_sans_ext(basename(geojson_files))]

# Define a location to log files that threw errors during processing
error_log_path = "B:/Colombia_ALS/simulator_error_log.txt"

# Drop any LAS files that previously threw errors
error_files_noext = tools::file_path_sans_ext(basename(readLines(error_log_path)))
las_files_needed = las_files_needed[!tools::file_path_sans_ext(basename(las_files_needed)) %in% error_files_noext]

# Run in parallel
pkg_list = c(
  "sf", "lidR", "terra", "spatstat.geom", "concaveman", 
  "exactextractr", "rGEDI", "rGEDIsimulator"
  )
foreach(las_file = las_files_needed, .packages = pkg_list) %dopar% {
  tryCatch({
   run_gedi_wfs_with_als(
     als_path = las_file,
     als_crs = crs_code,
     raster_path = reference_raster_path,
     output_coords_folder = coords_folder,
     output_waveform_folder = waveform_folder,
     output_metrics_folder = metrics_folder,
     output_geojson_folder = geojson_folder
   )
  }, error = function(e) {
   cat(las_file, file = error_log_path, append = TRUE, sep = "\n")
  })
}

# Stop the cluster when done
stopCluster(cl)
