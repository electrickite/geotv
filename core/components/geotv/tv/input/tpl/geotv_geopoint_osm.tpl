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
var tv{$tv->id}Markers = new Array();

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
console.log("initialize");
    removeMarkers();

  if( typeof(tv{$tv->id}Map) == "undefined" )
      tv{$tv->id}Map = L.map('tv{$tv->id}-map-canvas').setView([
                                 tv{$tv->id}params.centerLat,
                                 tv{$tv->id}params.centerLng ],
                                 tv{$tv->id}params.zoom
                                 );
    console.log("init after");
    {literal}
     L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    })
    {/literal}
    .addTo(tv{$tv->id}Map);

  var points = tv{$tv->id}Data.points;

  for(i=0; i<points.length; i++) {
  {literal}
       var point = {lat: points[i].lat, lng: points[i].lng};
   {/literal}
       tv{$tv->id}Markers.push( new L.marker(point).addTo( tv{$tv->id}Map) );
  }

  tv{$tv->id}Map.on('click', function(e){
    marker = new L.marker(e.latlng).addTo(tv{$tv->id}Map);
  {literal}
    var point = {lat: e.latlng.lat, lng: e.latlng.lng};
  {/literal}


    if (tv{$tv->id}params.allowMultiple) {
      tv{$tv->id}Data.points.push(point);
    } else {
      removeMarkers();
      tv{$tv->id}Data.points = [point];
    }

    tv{$tv->id}Markers.push(marker);
    tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);
    MODx.fireResourceFormChange();

    tv{$tv->id}Data.zoom = tv{$tv->id}Map.getZoom();
    tv{$tv->id}Data.lat = tv{$tv->id}Map.getCenter().lat();
    tv{$tv->id}Data.lng = tv{$tv->id}Map.getCenter().lng();

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
  }); // END on mapclick

  function removeMarkers() {
    for (var i = 0; i < tv{$tv->id}Markers.length; i++) {
        var marker=tv{$tv->id}Markers[i];
        if (typeof marker != "undefined") {
            tv{$tv->id}Map.removeLayer(marker);
        }
    }
  }
}

function resetMap(m) {
   //TODO:
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
    console.log('before load');
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
