<?php
require_once dirname(__FILE__) . '/../../lib/geotv_input.class.php';

if(!class_exists('GeoTVFenceInputRender')) {
    class GeoTVFenceInputRender extends GeoTVInputRender {
        public function getTemplate() {
            return $this->modx->getObject('modNamespace','geotv')->getCorePath().'tv/input/tpl/geotv_geofence.tpl';
        }
    }
}
return 'GeoTVFenceInputRender';
