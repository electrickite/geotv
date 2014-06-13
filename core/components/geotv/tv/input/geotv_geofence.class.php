<?php
if(!class_exists('GeoTVInputRender')) {
    class GeoTVInputRender extends modTemplateVarInputRender {
        public function getTemplate() {
            return $this->modx->getObject('modNamespace','geotv')->getCorePath().'tv/input/tpl/geotv_geofence.tpl';
        }
        public function process($value,array $params = array()) {
            $params['centerLat'] = floatval($this->modx->getOption('centerLat', $params, 39, true));
            $params['centerLng'] = floatval($this->modx->getOption('centerLng', $params, -95, true));
            $params['zoom'] = intval($this->modx->getOption('zoom', $params, 3, true));

            $lang = $this->modx->lexicon->fetch('geotv.', true);
            $this->modx->smarty->assign('geotv', $lang);

            $this->setPlaceholder('params', $params);
        }
    }
}
return 'GeoTVInputRender';
