<div id="tv{$tv->id}-map-canvas" style="height:300px; width:100%; margin-top:54x; padding:0px"><p>{$geotv.loading}</p></div>
<a href="#" onclick="clearGeoTV{$tv->id}(); return false;">{$geotv.clear}</a>
<input id="tv{$tv->id}" name="tv{$tv->id}" type="hidden" value='{$tv->get("value")|escape}'>

<script type="text/javascript">
  // only load Google Maps API if not loaded
  if (!window.google || !window.google.maps) {
    document.write('<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=drawing"><\/script>');
  }
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
  var mapOptions = {
    center: new google.maps.LatLng(tv{$tv->id}Data.lat, tv{$tv->id}Data.lng),
    zoom: tv{$tv->id}Data.zoom
  };

  tv{$tv->id}Map = new google.maps.Map(document.getElementById('tv{$tv->id}-map-canvas'), mapOptions);

  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.MARKER,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: [
        google.maps.drawing.OverlayType.MARKER
      ]
    }
  });
  drawingManager.setMap(tv{$tv->id}Map);

  var markers = new Array();
  var points = tv{$tv->id}Data.points;

  for(i=0; i<points.length; i++) {
    markers.push(new google.maps.Marker({
      position: new google.maps.LatLng(points[i].lat, points[i].lng),
      map: tv{$tv->id}Map
    }));
  }

  google.maps.event.addListener(drawingManager, 'markercomplete', function(marker) {
    var point = { lat: marker.getPosition().lat(), lng: marker.getPosition().lng() };

    if (tv{$tv->id}params.allowMultiple) {
      tv{$tv->id}Data.points.push(point);
    } else {
      setAllMarkerMaps(null);
      tv{$tv->id}Data.points = [point];
    }

    markers.push(marker);
    tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);
    MODx.fireResourceFormChange();
  });

  google.maps.event.addListener(tv{$tv->id}Map, 'idle', function() {
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
  });

  function setAllMarkerMaps(value) {
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(value);
    }
  }
}

function resetMap(m) {
   var x = m.getZoom();
   var c = m.getCenter();
   google.maps.event.trigger(m, 'resize');
   m.setZoom(x);
   m.setCenter(c);
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
    google.maps.event.addDomListener(window, 'load', initializeMapTV{$tv->id}());

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
