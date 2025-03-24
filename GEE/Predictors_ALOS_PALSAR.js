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

var aoi = ee.FeatureCollection('users/jf2238/Grid_of_degrade_COL_ORIG_FID_in_string');
//
//To dates
var start_1 = ee.Date('2019-01-01');
var finish_1 = ee.Date('2019-12-31');
//
var start_2 = ee.Date('2020-01-01');
var finish_2 = ee.Date('2020-12-31');

//ALOS/PALSAR
var imagery_1 = ee.ImageCollection('JAXA/ALOS/PALSAR/YEARLY/SAR')
    .filterDate(start_1, finish_1)
    //.select('HH','HV')
    //.filterBounds(aoi)
    
var imagery_2 = ee.ImageCollection('JAXA/ALOS/PALSAR/YEARLY/SAR')
    .filterDate(start_2, finish_2)
    //.select('HH','HV')
    //.filterBounds(aoi)
    
    
//To obtain metrics  
var imagery_3 =  imagery_1.merge(imagery_2).select('HH','HV');
//if you need to combine multiple years, .merge() will work, but you need to sort the image collections by date:

//To obtain texture

function texture(img){
  var img_16bit = img.int16()
  return img_16bit.glcmTexture({size: 3});
}

var mosaic_texture = imagery_3.map(texture)

var TEXTURE_savg = mosaic_texture.select(['HH_savg','HV_savg']).mean();

var TEXTURE_dvar = mosaic_texture.select(['HH_dvar','HV_dvar']).mean();