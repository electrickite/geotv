<div id="tv{$tv->id}-map-canvas" style="height:300px; width:100%; margin-top:54x; padding:0px"><p>{$geotv.loading}</p></div>
<a href="#" onclick="clearGeoTV{$tv->id}(); return false;">{$geotv.clear}</a>
<input id="tv{$tv->id}" name="tv{$tv->id}" type="hidden" value='{$tv->get("value")|escape}'>

<link rel="stylesheet"
      href="https://unpkg.com/leaflet@1.2.0/dist/leaflet.css"
      integrity="sha512-M2wvCLH6DSRazYeZRIm1JnYyh22purTM+FDB5CsyxtQJYeKq83arPe5wgbNmcFXGqiSH2XR8dT/fJISVA1r/zQ=="
      crossorigin=""/>
 <script src="https://unpkg.com/leaflet@1.2.0/dist/leaflet.js"
      integrity="sha512-lInM/apFSqyy1o6s89K4iQUKg6ppXEgsVxT35HbzUupEVRh2Eu9Wdl4tHj7dZO0s1uvplcYGmt3498TtHq+log=="
      crossorigin=""></script>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.2/leaflet.draw.css"
    integrity="sha256-XzD3RpaHPv7lzX9qt+2n1j5cWj48O24KsgaGYpKN8x8="
    crossorigin="anonymous" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.2/leaflet.draw.js"
    integrity="sha256-jzmB6xy6L0YPzPeu+ccUiPKp3UE+qRmo5xmq5BbnSv0="
    crossorigin="anonymous"></script>

<script type="text/javascript">
// <![CDATA[
var tv{$tv->id}params = {
{foreach from=$params key=k item=v name='p'}
 '{$k}': {if is_numeric($v)}{$v}{else}'{$v|escape:"javascript"}'{/if}{if NOT $smarty.foreach.p.last},{/if}
{/foreach}
};

// Set up some globals
var tv{$tv->id}EventAdded = false;
var tv{$tv->id}Map;
var tv{$tv->id}Input;
var tv{$tv->id}Data;
var tv{$tv->id}Polygons = new Array();
var tv{$tv->id}DrawCtrl = undefined;
var tv{$tv->id}EditableLayer = undefined;
var tv{$tv->id}AddLayer;

function initializeGlobalsTV{$tv->id}() {
  tv{$tv->id}Input = document.getElementById("tv{$tv->id}");
  try {
    tv{$tv->id}Data = JSON.parse(tv{$tv->id}Input.value);
    if (tv{$tv->id}Data.areas === null || typeof tv{$tv->id}Data.areas !== 'object') {
      throw "Parsing Error";
    }
  } catch (e) {
    tv{$tv->id}Data = {
      lat: tv{$tv->id}params.centerLat,
      lng:  tv{$tv->id}params.centerLng,
      zoom: tv{$tv->id}params.zoom,
      areas: []
    };
  }
}

function initializeMapTV{$tv->id}() {

    removePolygons();


    //create map
    if( typeof(tv{$tv->id}Map) == "undefined" )
      tv{$tv->id}Map = L.map('tv{$tv->id}-map-canvas').setView([
                                 tv{$tv->id}params.centerLat,
                                 tv{$tv->id}params.centerLng ],
                                 tv{$tv->id}params.zoom
                                 );
    // Insert background tiles layer
{literal}
     L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    })
{/literal}
    .addTo( tv{$tv->id}Map );

    // Begin inserting Drawing Tools
    if( ! tv{$tv->id}EditableLayer 
        && ! tv{$tv->id}Map.hasLayer( tv{$tv->id}EditableLayer ))
    {
        tv{$tv->id}EditableLayer = new L.FeatureGroup();
        tv{$tv->id}Map.addLayer( tv{$tv->id}EditableLayer );
    }


    var drawPluginOptions = {
      position: 'topright',
      draw: {
        polygon: {
          allowIntersection: false, // Restricts shapes to simple polygons
          drawError: {
            color: '#e1e100', // Color the shape will turn when intersects
            message: '<strong>Oh snap!<strong> you can\'t draw that!' // Message that will show when intersect
          },
          shapeOptions: {
            color: '#97009c'
          }
        },
        // disable toolbar item by setting it to false
        polyline: false,
        circle: false, // Turns off this drawing tool
        circlemarker: false, // Turns off this drawing tool
        rectangle: false,
        marker: false,
        },
      edit: {
        featureGroup: tv{$tv->id}EditableLayer, //REQUIRED!!
        remove: false
      }
    };

    // Initialise the draw control and pass it the FeatureGroup of editable layers
    if( ! tv{$tv->id}DrawCtrl )
    {
        tv{$tv->id}DrawCtrl = new L.Control.Draw(drawPluginOptions);
        tv{$tv->id}Map.addControl( tv{$tv->id}DrawCtrl );
    }

    // From https://github.com/Leaflet/Leaflet.draw/blob/master/src/Leaflet.draw.js

    L.drawLocal.draw.handlers.polygon.tooltip.start = '{$geotv.draw_startpoly}';
    L.drawLocal.draw.handlers.polygon.tooltip.cont = '{$geotv.draw_nextpoly}';
    L.drawLocal.draw.handlers.polygon.tooltip.end = '{$geotv.draw_endpoly}';

    L.drawLocal.draw.toolbar.actions.text = '{$geotv.draw_toolbarcancel}';
    L.drawLocal.draw.toolbar.actions.title = '{$geotv.draw_toolbarcanceltitle}';
    L.drawLocal.draw.toolbar.finish.text = '{$geotv.draw_toolbarfinish}';
    L.drawLocal.draw.toolbar.finish.title = '{$geotv.draw_toolbarfinishtitle}';
    L.drawLocal.draw.toolbar.undo.text = '{$geotv.draw_toolbarundo}';
    L.drawLocal.draw.toolbar.undo.title = '{$geotv.draw_toolbarundotitle}';

    L.drawLocal.draw.toolbar.buttons.polygon = '{$geotv.draw_polybutton}';

    L.drawLocal.edit.handlers.edit.tooltip.text = '{$geotv.draw_handlertext}';
    L.drawLocal.edit.handlers.edit.tooltip.subtext = '{$geotv.draw_handlersubtext}';

    L.drawLocal.edit.toolbar.buttons.edit = '{$geotv.draw_layersedit}';
    L.drawLocal.edit.toolbar.buttons.editDisabled = '{$geotv.draw_layerseditdisabled}';
    L.drawLocal.edit.toolbar.buttons.remove = '{$geotv.draw_layersremove}';
    L.drawLocal.edit.toolbar.buttons.removeDisabled = '{$geotv.draw_layersremovedisabled}';
    L.drawLocal.edit.toolbar.actions.save.text = '{$geotv.draw_layerssave}';
    L.drawLocal.edit.toolbar.actions.save.title = '{$geotv.draw_layerssavetitle}';
    L.drawLocal.edit.toolbar.actions.cancel.text = '{$geotv.draw_layerscancel}';
    L.drawLocal.edit.toolbar.actions.cancel.title = '{$geotv.draw_layerscanceltitle}';
    L.drawLocal.edit.toolbar.actions.clearAll.text = '{$geotv.draw_layersclearall}';
    L.drawLocal.edit.toolbar.actions.clearAll.title = '{$geotv.draw_layersclearalltitle}';


    // ENDOF Map Drawing Tools


    // ----------------------------------
    // RE-DRAW shapes from previous datas
    var areas = tv{$tv->id}Data.areas;

    for(i=0; i<areas.length; i++) {
        var shapeCoords = new Array();

        for(j=0; j<areas[i].length; j++) {
          var point = areas[i][j];
          if( typeof point.lat == "undefined" 
              ||typeof point.lng == "undefined" )
              continue;
          shapeCoords.push([point.lat, point.lng]);
        }

        if (shapeCoords.length == 0 )
        {
            continue;
        } else
        {
            var polygon = L.polygon( shapeCoords );
            tv{$tv->id}Polygons.push(  polygon );
        }
    }

    //setAllShapeMaps( tv{$tv->id}Map );
    setAllShapeMaps( tv{$tv->id}EditableLayer );
    //ENDOF RE-DRAW

    // -----------------------------
    // Add to layer
    //  if draw finished 
    //  or after edited multiple polygons
    tv{$tv->id}Map.on('draw:edited', function(e){
        layers = e.layers;
        layers.eachLayer( tv{$tv->id}AddLayer );
    });
    // after creating new polygon
    tv{$tv->id}Map.on('draw:created', function(e){
        tv{$tv->id}AddLayer(e.layer);
    });

    // -----------------------------
    // Add polygon to default layer:
    //   
    tv{$tv->id}AddLayer = function (layer) {

        //if (type != 'polygon') {
        //  return;
        //}

        // Erase every thing if in singleMode
        if ( ! tv{$tv->id}params.allowMultiple) {
          removePolygons();
        }

        // add polygon to map and store for future use
        tv{$tv->id}EditableLayer.addLayer( layer );
        tv{$tv->id}Polygons.push(  layer );

        polygons2Data();
        tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);

        MODx.fireResourceFormChange();

        tv{$tv->id}Data.zoom = tv{$tv->id}Map.getZoom();
        tv{$tv->id}Data.lat = tv{$tv->id}Map.getCenter().lat;
        tv{$tv->id}Data.lng = tv{$tv->id}Map.getCenter().lng;

        var jsonData = JSON.stringify(tv{$tv->id}Data);

        if (
          typeof(tv{$tv->id}Data.areas) != "undefined"
          && Object.prototype.toString.call(tv{$tv->id}Data.areas) === '[object Array]'
          && tv{$tv->id}Data.areas.length > 0
          && tv{$tv->id}Input.value != jsonData
        ) {
          tv{$tv->id}Input.value = jsonData;
          MODx.fireResourceFormChange();
        }
      } 

  function setAllShapeMaps(layer) {
    for (var i = 0; i < tv{$tv->id}Polygons.length; i++) {
      layer.addLayer( tv{$tv->id}Polygons[i] );
    }
  }

  // Convert polygon array into storable points array
  function polygons2Data(){
    // reset data
    tv{$tv->id}Data.areas = [];
    for (var i = 0; i < tv{$tv->id}Polygons.length; i++) {
        var points = [];
        var layer = tv{$tv->id}Polygons[i];
        layer._latlngs[0].forEach(function(elem, index){
           points.push({ lat: elem.lat, lng: elem.lng });
        });

        tv{$tv->id}Data.areas.push(points);
    }
  }

  function removePolygons() {
    // remove each polygon layer from leaflet map
    for (var i = 0; i < tv{$tv->id}Polygons.length; i++) {
        var polygon=tv{$tv->id}Polygons[i];
        if (typeof polygon != "undefined") {
            tv{$tv->id}EditableLayer.removeLayer(polygon);
        }
    }
    // reset internal storing
    tv{$tv->id}Polygons = new Array()
  }
} //endof initializeMapTV

function resetMap(m) {
   //var x = m.getZoom();
   //var c = m.getCenter();
   //m.setZoom(x);
   //m.setCenter(c);
}

function clearGeoTV{$tv->id}() {
  document.getElementById('tv{$tv->id}').value = "";
  initializeGlobalsTV{$tv->id}();
  initializeMapTV{$tv->id}();
  MODx.fireResourceFormChange();
}

{literal}
Ext.onReady(function() {
    var fld = MODx.load({
    {/literal}
        xtype: 'textarea'
        ,applyTo: 'tv{$tv->id}'
        ,value: '{$tv->get('value')|escape:'javascript'}'
        ,height: 140
        ,width: '99%'
        ,enableKeyEvents: true
        ,msgTarget: 'under'
        ,allowBlank: {if $params.allowBlank == 1 || $params.allowBlank == 'true'}true{else}false{/if}
    {literal}
        ,listeners: { 'keydown': { fn:MODx.fireResourceFormChange, scope:this}}
    });
    MODx.makeDroppable(fld);
    Ext.getCmp('modx-panel-resource').getForm().add(fld);
    {/literal}

    initializeGlobalsTV{$tv->id}();
    initializeMapTV{$tv->id}();

    var mainTabs = Ext.getCmp("modx-resource-tabs");
    mainTabs.on('tabchange', function(parent,selectedTab){
      resetMap(tv{$tv->id}Map);
    });

    // We need to add the vertical tabs click handler after it has been loaded
    mainTabs.on('afterlayout', function(parent, layout){
      if (!tv{$tv->id}EventAdded) {
        tv{$tv->id}EventAdded = true;
        var vertTabs = Ext.getCmp("modx-resource-vtabs");

        vertTabs.on('tabchange', function(parent,selectedTab){
          resetMap(tv{$tv->id}Map);
        });
      }
    });
});

// ]]>
</script>
