<?php
require_once dirname(__FILE__) . '/../../lib/geotv_input.class.php';

if(!class_exists('GeoTVFenceInputRender')) {
    class GeoTVFenceInputRender extends GeoTVInputRender {
        public function getTemplate() {
            $osm = $this->modx->getOption('geotv.enable_osm');
            if( $osm == 1 )
                return $this->modx->getObject('modNamespace','geotv')->getCorePath().'tv/input/tpl/geotv_geofence_osm.tpl';
            else
                return $this->modx->getObject('modNamespace','geotv')->getCorePath().'tv/input/tpl/geotv_geofence.tpl';
        }
    }
}
return 'GeoTVFenceInputRender';
