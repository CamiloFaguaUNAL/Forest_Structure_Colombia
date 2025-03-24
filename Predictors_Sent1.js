/******************************
 * Authors:
 * 
Jose Camilo Fagua
jcfaguag@unal.edu.co
Profesor asistente
Departamento de Biología
Universidad Nacional de Colombia

Patrick Burns
Senior Research Scientist
Global Earth Observation & Dynamics of Ecosystems Lab (GEODE)
School of Informatics, Computing & Cyber Systems-Northern Arizona University
******************************/

/******************************
 * MODULES
******************************/

// It is a slope raster generated from the ALOS 30m DEM. It is for public use.
var slope_lib = require('users/pb463/NAU_GoetzGroup:01_utilities/modules/S1_slopecorr');//
print('slope_lib', slope_lib)


/******************************
 * INPUT DATA
******************************/

// Sentinel 1
var S1 = ee.ImageCollection("COPERNICUS/S1_GRD_FLOAT")

// DEM to use for slope correction
var dem = ee.Image("JAXA/ALOS/AW3D30/V2_2")

// Dates
var start_date = ee.Date('2020-01-01');
var end_date = ee.Date('2020-12-31');

// Study Area (can be any .shp that is uploaded to GEE where it becomes a FeatureCollection)
var aoi = ee.FeatureCollection(/*'the .shp of the study area'*/);
print('aoi',aoi)

/******************************
 * PROCESSING 
******************************/
// Function to exclude very low values
function mask_lowPow(img) {
  var highPow = img.select('VV').gt(0.0001).and(img.select('VH').gt(0.0001))
  
  return img.updateMask(highPow)
}

// Filter the image collection
var S1_filt = S1
                // Filter to get images collected in interferometric wide swath mode.
                .filter(ee.Filter.eq('instrumentMode', 'IW'))
                // Filter for desired polarisations
                .filter(ee.Filter.listContains('transmitterReceiverPolarisation', 'VV'))
                .filter(ee.Filter.listContains('transmitterReceiverPolarisation', 'VH'))
                // Filter by polygon
                .filterBounds(aoi)
                // Filter date range
                .filterDate(start_date, end_date)
                // Could filter by orbit - DESC time is 0600 local time; ASC time is 1800 local time
                .filterMetadata('orbitProperties_pass', 'equals', 'ASCENDING')
                //.filterMetadata('orbitProperties_pass', 'equals', 'DESCENDING')
                // Could filter by month to exclude wetter times of year (optional)
                //.filter(ee.Filter.calendarRange(1, 2, 'month'))
                // Mask low power values found along some image edges
                .map(mask_lowPow)             
                

// Slope-based correction for Sentinel-1 data
var S1_filt_SC = slope_lib.slope_correction(
    S1_filt ,
    {'model': 'volume',
    'elevation': dem,
    'buffer': 30      // buffer en metros
    }
);


// Function to scale natural values
function scaleNatural(img) {
  var VVVH_scaled = img.select('VV', 'VH').multiply(10000)
  
  return VVVH_scaled.addBands(img.select('angle'))
}

// Function to add VH/VV ratio and VV - VH difference
function add_VVVH_combos(img) {
  var VHdivVV = img.select('VH').divide(img.select('VV')).multiply(10000).rename('VHdivVV')
  var VVminVH = img.select('VV').subtract(img.select('VH')).rename('VVminVH')
  var new_bands = [VHdivVV, VVminVH]
  
  return img.addBands(new_bands)
}

// Function to trim off S1 edges
// ref: https://code.earthengine.google.com/05be4464424a120a7b3cddc34e6d50c4
function erodeEdge(image) {
  return image.clip(image.geometry().buffer(-3000))
}

// Previously constructed processes are applied
var S1_filt_proc = S1_filt_SC.map(scaleNatural)
                             .map(add_VVVH_combos)
                             .map(erodeEdge)
                             

//To obtain metrics

var mosaic_mean = S1_filt_proc.select(['VV','VH','VHdivVV','VVminVH']).mean().clip(aoi);

var mosaic_SD = S1_filt_proc.select(['VV','VH','VHdivVV','VVminVH'])
                              .reduce(ee.Reducer.stdDev())
                              .clip(aoi)
                                 
var mosaic_MAX = S1_filt_proc.select(['VV','VH','VHdivVV','VVminVH'])
                              .reduce(ee.Reducer.max())
                              .clip(aoi)
                              
var mosaic_MIN = S1_filt_proc.select(['VV','VH','VHdivVV','VVminVH'])
                              .reduce(ee.Reducer.min())
                              .clip(aoi)
                                 
var mosaic_AMPLITUDE = mosaic_MAX.subtract(mosaic_MIN)  


//To obtain texture

//10) Function texture
function texture(img){
  var img_16bit = img.int16()
  return img_16bit.glcmTexture({size: 3});
}

// Previously constructed processes are applied
var mosaic_texture = S1_filt_SC.filterBounds(aoi)
                             .map(scaleNatural)
                             .map(add_VVVH_combos)
                             .map(erodeEdge)
                             .map(texture)
                             
var TEXTURA_savg = mosaic_texture.select(['VV_savg','VH_savg','VHdivVV_savg', 'VVminVH_savg']).mean();

var TEXTURA_dvar = mosaic_texture.select(['VV_dvar','VH_dvar','VHdivVV_dvar', 'VVminVH_dvar']).mean();


