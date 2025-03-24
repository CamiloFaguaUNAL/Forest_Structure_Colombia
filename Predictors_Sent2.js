/******************************
 * Authors:
 * 
Jose Camilo Fagua
jcfaguag@unal.edu.co
Profesor asistente
Departamento de Biología
Universidad Nacional de Colombia

Patrick Jantz
Assistant Research Professor
Global Earth Observation & Dynamics of Ecosystems Lab (GEODE)
School of Informatics, Computing & Cyber Systems-Northern Arizona University
******************************/


/******************************
 * INPUT DATA
******************************/



// Study Area (can be any .shp that is uploaded to GEE where it becomes a FeatureCollection)
var aoi = ee.FeatureCollection(/*'the .shp of the study area'*/);
print('aoi',aoi)

// General definitions for imagery selection 
var start_date_1 = ee.Date('2019-01-01');
var end_date_1 = ee.Date('2020-12-31');
var CLOUD_FILTER = 40 //
var CLD_PRB_THRESH = 20 // 
var NIR_DRK_THRESH = 0.15
var CLD_PRJ_DIST = 2
var BUFFER = 100
//


/******************************
 * PROCESSING 
******************************/

// Function to link between imagery collections
function preserveId(image) {
  return image.set('original_id', image.get('system:index'));
}

// Sentinel 2
var S2_SR = (ee.ImageCollection('COPERNICUS/S2_SR')
        .filterBounds(aoi)
        .filter(ee.Filter.eq('SENSING_ORBIT_DIRECTION', 'DESCENDING'))
        .filterDate(start_date_1, end_date_1)
        .map(preserveId)
        .filter(ee.Filter.lte('CLOUDY_PIXEL_PERCENTAGE', CLOUD_FILTER))) 
 

// Sentnel 2-filter for cloudless.
var S2_cloudless = (ee.ImageCollection('COPERNICUS/S2_CLOUD_PROBABILITY')
        .filterBounds(aoi)
        .map(preserveId)
        .filterDate(start_date_1, end_date_1))
        
//Function to Join the filtered s2_cloudless collection to the SR collection by the 'system:index' property.
var S2_SR_cloudless = ee.ImageCollection(ee.Join.saveFirst('s2_cloudless').apply({
        'primary': S2_SR,
        'secondary': S2_cloudless,
        'condition': ee.Filter.equals({
            'leftField': 'system:index',
            'rightField': 'system:index'
        })
}))

// Function to add the s2_cloudless probability layer and derived cloud mask as bands to an S2 SR image input.
function preserveId_2(img) {
  // Get s2cloudless image, subset the probability band.
    var cld_prb = ee.Image(img.get('s2_cloudless')).select("probability")
    //Condition s2cloudless by the probability threshold value.
    var is_cloud = cld_prb.gt(CLD_PRB_THRESH).rename('clouds')
    //Add the cloud probability layer and cloud mask as image bands.
    return img.addBands(ee.Image([cld_prb, is_cloud]))
}

//Function to add dark pixels, cloud projection, and identified shadows as bands to an S2 SR image input
function add_shadow_bands(img) {
    //Identify water pixels from the SCL band.
    var not_water = img.select('SCL').neq(6)
    //Identify dark NIR pixels that are not water (potential cloud shadow pixels).
    var SR_BAND_SCALE = 1e4
    var dark_pixels = img.select('B8').lt(NIR_DRK_THRESH*SR_BAND_SCALE).multiply(not_water).rename('dark_pixels')
    //Determine the direction to project cloud shadow from clouds (assumes UTM projection).
    var shadow_azimuth = ee.Number(90).subtract(ee.Number(img.get('MEAN_SOLAR_AZIMUTH_ANGLE')));
    //Project shadows from clouds for the distance specified by the CLD_PRJ_DIST input.
    var cld_proj = (img.select('clouds').directionalDistanceTransform(shadow_azimuth, CLD_PRJ_DIST*10)
        .reproject({'crs': img.select(0).projection(), 'scale': 100})
        .select('distance')
        .mask()
        .rename('cloud_transform'))
    //Identify the intersection of dark pixels with cloud shadow projection.
    var shadows = cld_proj.multiply(dark_pixels).rename('shadows')
    //Add dark pixels, cloud projection, and identified shadows as image bands.
    return img.addBands(ee.Image([dark_pixels, cld_proj, shadows]))
}

//Function to rename bands
function band_rename(img){
  return img.select(
  ['B2','B3','B4','B5','B6','B7','B8','B8A','B11','B12','QA60','probability','clouds','dark_pixels',
  'cloud_transform','shadows'],
  ['BLUE','GREEN','RED','RED_EDGE_1','RED_EDGE_2','RED_EDGE_3','NIR','RED_EDGE_4','SWIR_1','SWIR_2','QA60',
  'probability','clouds','dark_pixels',
  'cloud_transform','shadows']);
} 

// function to calculate NDVI
function ndvi_calc(img){
  return img.normalizedDifference(['NIR', 'RED'])
            .select([0],['NDVI']);
}

// Function to calculate EVI
var evi_calc=function(img){
  var num = ee.Image((img.select(['NIR']).subtract(img.select(['RED']))).multiply(ee.Image(2.5)))
  var den = ee.Image(img.select(['NIR']).add(img.select(['RED']).multiply(6.0)).subtract(img.select(['BLUE']).multiply(7.5)).add(1.0))
  return (num.divide(den)).select([0],['EVI'])
};

// Function to Soil Adjusted Vegetation Index (SAVI)
var savi_calc=function(img){
  var num = ee.Image((img.select(['NIR']).subtract(img.select(['RED']))))
  var den = ee.Image((img.select(['NIR']).add(img.select(['RED']).add(0.5))).multiply(1.5))
  return (num.divide(den)).select([0],['SAVI'])
};  

// Function to spectral variability vegetation index (SVVI)
var svvi_calc=function(img){
  var term1 = ee.Image(img.select(['BLUE','GREEN','RED','NIR','SWIR_1','SWIR_2'])).reduce(ee.Reducer.stdDev());
  var term2 = ee.Image(img.select(['NIR','SWIR_1','SWIR_2'])).reduce(ee.Reducer.stdDev());
  return (term1.subtract(term2)).select([0],['SVVI'])
};

// Function to Red-edge Normalized Difference Vegetation Index - RNDVI
function rndvi_calc(img){
  return img.normalizedDifference(['NIR', 'RED_EDGE_2'])
            .select([0],['RNDVI']);
}

// Function to add indices to an image
// NDVI, EVI, SAVI, SVVI, RNDVI
var addIndices=function(in_image){
  var temp_image = in_image.float().divide(10000.0)
  return in_image.addBands(ee.Image(ndvi_calc(in_image)).multiply(10000.0).int16())
               .addBands(ee.Image(evi_calc(temp_image)).multiply(10000.0).int16())
               .addBands(ee.Image(savi_calc(temp_image)).multiply(10000.0).int16())
               .addBands(ee.Image(svvi_calc(temp_image)).multiply(10000.0).int16())
               .addBands(ee.Image(rndvi_calc(temp_image)).multiply(10000.0).int16())
}

//4) final mask

var clear = function(image) {
  //For masking pixels with 5% of probability to be clouds 
  var probability = image.select('probability').gt(20)
  var probability_2 = probability.select('probability').not()
  //For masking pixels that are shadows 
  var shadows = image.select('shadows')
  var shadows_2 = shadows.select('shadows').not()
  //
  return ee.Image(image.updateMask(probability_2).updateMask(shadows_2))
};

//5) MOSAIC  

var mosaic = S2_SR_cloudless
            .filterBounds(aoi)
            .map(preserveId_2)
            .map(add_shadow_bands)
            .map(band_rename)
            .map(addIndices)
            .map(clear)
  
  
  
//To obtain metrics          

var mosaic_mean = mosaic.select(['BLUE','GREEN','RED','RED_EDGE_1','RED_EDGE_2','RED_EDGE_3','NIR','RED_EDGE_4','SWIR_1','SWIR_2',
                              'NDVI', 'EVI', 'SAVI', 'SVVI','RNDVI']).mean().clip(aoi);
                              

var mosaic_SD = mosaic.select(['BLUE','GREEN','RED','RED_EDGE_1','RED_EDGE_2','RED_EDGE_3',
                              'NIR','RED_EDGE_4','SWIR_1','SWIR_2','EVI'])
                              .reduce(ee.Reducer.stdDev())
                              .clip(aoi)


var mosaic_MAX = mosaic.select(['BLUE','GREEN','RED','RED_EDGE_1','RED_EDGE_2','RED_EDGE_3',
                               'NIR','RED_EDGE_4','SWIR_1','SWIR_2','EVI'])
                              .reduce(ee.Reducer.max())
                              .clip(aoi)
                              

var mosaic_MIN = mosaic.select(['BLUE','GREEN','RED','RED_EDGE_1','RED_EDGE_2','RED_EDGE_3',
                              'NIR','RED_EDGE_4','SWIR_1','SWIR_2','EVI'])
                              .reduce(ee.Reducer.min())
                              .clip(aoi)

var mosaic_AMPLITUDE = mosaic_MAX.subtract(mosaic_MIN)  

print(mosaic_AMPLITUDE, 'mosaic_AMPLITUDE')


//To obtain texture

//Function texture
function texture(img){
  var img_16bit = img.int16()
  return img_16bit.glcmTexture({size: 3});
}
//


var mosaic_texture = S2_SR_cloudless
            .filterBounds(aoi)
            .map(preserveId_2)
            .map(add_shadow_bands)
            .map(band_rename)
            .map(addIndices)
            .map(clear)
            .map(texture)
            
print('mosaic_texture',mosaic_texture)
            
//7) Structural metrics

var TEXTURA_dvar = mosaic_texture.select(['BLUE_dvar','GREEN_dvar','RED_dvar','RED_EDGE_1_dvar','RED_EDGE_2_dvar',
                                          'RED_EDGE_3_dvar','NIR_dvar','RED_EDGE_4_dvar','SWIR_1_dvar','SWIR_2_dvar',
                                          'EVI_dvar']).mean();  


var TEXTURA_savg = mosaic_texture.select(['BLUE_savg','GREEN_savg','RED_savg','RED_EDGE_1_savg','RED_EDGE_2_savg',
                                         'RED_EDGE_3_savg','NIR_savg','RED_EDGE_4_savg','SWIR_1_savg','SWIR_2_savg',
                                         'EVI_savg']).mean();  
                                          


