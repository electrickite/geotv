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


</script>

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
var tv{$tv->id}FeatureGroup;

/**
 * Return marker with that
 *   - popups help on mouse over
 *   - removes at clikc
 *   - moves at drag
 */
function newMarker(featureGroup, latlng){
       return new L.marker(latlng,
{literal}
       {draggable: true}
{/literal}
       )
       .bindPopup("{$geotv.markerHelp}")
       .on('click', function(e){ // erase point
           featureGroup.removeLayer(this);
           featureGroupToData();
       })
       .on('dragend', function(e){ // save point after moved
            featureGroupToData();
       })
       .on('mouseout', function(e){
          this.closePopup();
       })
       .on('mouseover', function(e){
          this.openPopup();
       })
       .addTo( featureGroup );
}

function initializeGlobalsTV{$tv->id}() {
  tv{$tv->id}Input = document.getElementById("tv{$tv->id}");
  try {
    tv{$tv->id}Data = JSON.parse(tv{$tv->id}Input.value);
    if (tv{$tv->id}Data.points === null || typeof tv{$tv->id}Data.points !== 'object') {
      throw "Parsing Error";
    }
  } catch (e) {
    tv{$tv->id}Data = {
      lat: tv{$tv->id}params.centerLat,
      lng:  tv{$tv->id}params.centerLng,
      zoom: tv{$tv->id}params.zoom,
      points: []
    };
  }
}

function initializeMapTV{$tv->id}() {
    removeMarkers();

  if( typeof(tv{$tv->id}Map) == "undefined" )
  {
      tv{$tv->id}Map = L.map('tv{$tv->id}-map-canvas').setView([
                                 tv{$tv->id}params.centerLat,
                                 tv{$tv->id}params.centerLng ],
                                 tv{$tv->id}params.zoom
                                 );
   }
  if( typeof(tv{$tv->id}FeatureGroup) == "undefined" )
  {
   tv{$tv->id}FeatureGroup = L.featureGroup(); //TODO: use this for all points deletion
   tv{$tv->id}FeatureGroup.addTo(tv{$tv->id}Map);
   }

 tv{$tv->id}Map.getPane('mapPane').style.zIndex=0;

{literal}
     L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    })
{/literal}
    .addTo(tv{$tv->id}Map);

// RESTORE saved
// -------------

// 1- get previous saved points
  var points = tv{$tv->id}Data.points;

// 2- transform in map points
  for(i=0; i<points.length; i++) {
{literal}
       var point = {lat: points[i].lat, lng: points[i].lng};
{/literal}
// 3- and save in new table 
        newMarker( tv{$tv->id}FeatureGroup, point);
  }

// WHAT to do if map clicked
// -------------------------

  tv{$tv->id}Map.on('click', function(e){
    // 0- remove if not multiple
    if ( ! tv{$tv->id}params.allowMultiple) {
      removeMarkers();
    }
    // 1- add new point
    newMarker(tv{$tv->id}FeatureGroup, e.latlng);


    // 2- then add to Datapoints for future saving
    featureGroupToData();

  }); // END on mapclick

  // reset map only after timeout 
  setTimeout(function(){ resetMap(tv{$tv->id}Map); }, 100);
} // end of initializeMapTV

function resetMap(m) {
  // fix display bug,
  tv{$tv->id}Map.invalidateSize();
  // Center map on contained points
  if( tv{$tv->id}FeatureGroup.getLayers().length > 0 )
  {
      tv{$tv->id}Map.fitBounds( tv{$tv->id}FeatureGroup.getBounds() );
  }
   //var x = m.getZoom();
   //var c = m.getCenter();
   //m.setZoom(x);
   //m.setCenter(c);
}

// Just remove markers from map.
// Modx Data  update is done else where
function removeMarkers() {
    if( typeof(tv{$tv->id}FeatureGroup) == "undefined" )
        return;

    //TODO: try this instead tv{$tv->id}FeatureGroup.clearLayers();
    tv{$tv->id}FeatureGroup.eachLayer(function(l){
        tv{$tv->id}FeatureGroup.removeLayer(l);
    });
}

function featureGroupToData()
{
      // reset data
      tv{$tv->id}Data.points = [];

      // refresh data
      tv{$tv->id}FeatureGroup.eachLayer(function(e){
        {literal}
            var point = {lat: e._latlng.lat, lng: e._latlng.lng};
        {/literal}
          tv{$tv->id}Data.points.push(point);
          });

// 3- ready to save in form
    tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);
    MODx.fireResourceFormChange();

    var jsonData = JSON.stringify(tv{$tv->id}Data);

    if (
      typeof(tv{$tv->id}Data.points) != "undefined"
      && Object.prototype.toString.call(tv{$tv->id}Data.points) === '[object Array]'
      && tv{$tv->id}Data.points.length > 0
      && tv{$tv->id}Input.value != jsonData
    ) {
      tv{$tv->id}Input.value = jsonData;
      MODx.fireResourceFormChange();
    }
}


function clearGeoTV{$tv->id}() {
  document.getElementById('tv{$tv->id}').value = "";
  initializeGlobalsTV{$tv->id}();
  initializeMapTV{$tv->id}();
  removeMarkers(); // remove markers
  featureGroupToData() // update modx data
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
