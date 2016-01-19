<?php
require_once dirname(__FILE__) . '/../../lib/geotv_input.class.php';

if(!class_exists('GeoTVPointInputRender')) {
    class GeoTVPointInputRender extends GeoTVInputRender {
        public function getTemplate() {
            return $this->modx->getObject('modNamespace','geotv')->getCorePath().'tv/input/tpl/geotv_geopoint.tpl';
        }
    }
}
return 'GeoTVPointInputRender';
