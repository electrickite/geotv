<?php
if(!class_exists('GeoTVInputRender')) {
    class GeoTVInputRender extends modTemplateVarInputRender {
        public function process($value,array $params = array()) {
            $multiple = $this->modx->getOption('allowMultiple', $params, 1, true);

            $params['allowMultiple'] = ($multiple === 0 || $multiple === 'false') ? 0 : 1;
            $params['centerLat'] = json_encode(floatval($this->modx->getOption('centerLat', $params, 39, true)));
            $params['centerLng'] = json_encode(floatval($this->modx->getOption('centerLng', $params, -95, true)));
            $params['zoom'] = json_encode(intval($this->modx->getOption('zoom', $params, 3, true)));
            $params['apiKey'] = urlencode($this->modx->getOption('geotv.api_key'));

            $lang = $this->modx->lexicon->fetch('geotv.', true);
            $this->modx->smarty->assign('geotv', $lang);

            $this->setPlaceholder('params', $params);
        }
    }
}
return 'GeoTVInputRender';
