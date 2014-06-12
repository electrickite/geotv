<div id="tv{$tv->id}-map-canvas" style="height:300px; width:100%; margin-top:54x; padding:0px"><p>{$geotv.loading}</p></div>
<a href="#" onclick="clearGeoTV{$tv->id}(); return false;">{$geotv.clear}</a>
<input id="tv{$tv->id}" name="tv{$tv->id}" type="hidden" value='{$tv->get("value")|escape}'>

<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>
<script type="text/javascript">
// <![CDATA[
var params = {
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
    if (tv{$tv->id}Data.areas === null || typeof tv{$tv->id}Data.areas !== 'object') {
      throw "Parsing Error";
    }
  } catch (e) {
    tv{$tv->id}Data = {
      lat: params.centerLat,
      lng:  params.centerLng,
      zoom: params.zoom,
      areas: []
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
    drawingMode: google.maps.drawing.OverlayType.POLYGON,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: [
        google.maps.drawing.OverlayType.POLYGON
      ]
    }
  });
  drawingManager.setMap(tv{$tv->id}Map);

  var shapes = new Array();
  var areas = tv{$tv->id}Data.areas;

  for(i=0; i<areas.length; i++) {
    var shapeCoords = new Array();

    for(j=0; j<areas[i].length; j++) {
      var point = areas[i][j];
      shapeCoords.push(new google.maps.LatLng(point.lat, point.lng));
    }

    shapes.push(new google.maps.Polygon({
      paths: shapeCoords
    }));
  }

  for(i=0; i<shapes.length; i++) {
    shapes[i].setMap(tv{$tv->id}Map);
  }

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) {
    var points = [];
    polygon.getPath().forEach(function(elem, index){
        points.push({ lat: elem.lat(), lng: elem.lng() });
    });

    tv{$tv->id}Data.areas.push(points);
    tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);

    MODx.fireResourceFormChange();
  });

  google.maps.event.addListener(tv{$tv->id}Map, 'idle', function() {
    tv{$tv->id}Data.zoom = tv{$tv->id}Map.getZoom();
    tv{$tv->id}Data.lat = tv{$tv->id}Map.getCenter().lat();
    tv{$tv->id}Data.lng = tv{$tv->id}Map.getCenter().lng();

    if (
      typeof(tv{$tv->id}Data.areas) != "undefined"
      && Object.prototype.toString.call(tv{$tv->id}Data.areas) === '[object Array]'
      && tv{$tv->id}Data.areas.length > 0
    ) {
      tv{$tv->id}Input.value = JSON.stringify(tv{$tv->id}Data);
      MODx.fireResourceFormChange();
    }
  });
}

function resetMap(m) {
   x = m.getZoom();
   c = m.getCenter();
   google.maps.event.trigger(m, 'resize');
   m.setZoom(x);
   m.setCenter(c);
}

function clearGeoTV{$tv->id}() {
  document.getElementById('tv{$tv->id}').value = "";
  initializeGlobalsTV{$tv->id}();
  initializeMapTV{$tv->id}();
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