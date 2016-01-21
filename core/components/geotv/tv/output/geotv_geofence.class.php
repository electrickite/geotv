<?php
if(!class_exists('GeoTVFenceOutputRender')) {
    class GeoTVFenceOutputRender extends modTemplateVarOutputRender {
        public function process($value, array $params = array()) {
            $locale = localeconv();

            $wrapperTpl = isset($params['wrapperTpl']) ? $params['wrapperTpl'] : null;
            $areaTpl = isset($params['areaTpl']) ? $params['areaTpl'] : null;
            $pointTpl = isset($params['pointTpl']) ? $params['pointTpl'] : null;
            $areaSep = isset($params['areaSep']) ? $params['areaSep'] : '';
            $pointSep = isset($params['pointSep']) ? $params['pointSep'] : '';
            $decimalSep = isset($params['decimalSep']) ? $params['decimalSep'] : $locale['decimal_point'];

            $data = json_decode($value);
            $areas = array();

            if (is_object($data) && isset($data->areas)) {
                foreach ($data->areas as $area) {
                    $points = array();

                    foreach ($area as $point) {
                        $latitude = number_format($point->lat, 8, $decimalSep, '');
                        $longitude = number_format($point->lng, 8, $decimalSep, '');

                        if ($pointTpl) {
                            $points[] = $this->modx->getChunk($pointTpl, array(
                                'latitude' => $latitude,
                                'longitude' => $longitude,
                            ));
                        } else {
                            $points[] = $latitude.$longitude;
                        }
                    }

                    $pointString = implode($pointSep, $points);
                    if ($areaTpl) {
                        $areas[] = $this->modx->getChunk($areaTpl, array(
                            'points' => $pointString,
                        ));
                    } else {
                        $areas[] = $pointString;
                    }
                }

                $areaString = implode($areaSep, $areas);
                if ($wrapperTpl) {
                    $output = $this->modx->getChunk($wrapperTpl, array(
                        'areas' => $areaString,
                    ));
                } else {
                    $output = $areaString;
                }

                return $output;
            }
        }
    }
}
return 'GeoTVFenceOutputRender';
