<?php
if(!class_exists('GeoTVOutputRender')) {
    class GeoTVOutputRender extends modTemplateVarOutputRender {
        public function process($value, array $params = array()) {
            $wrapperTpl = isset($params['wrapperTpl']) ? $params['wrapperTpl'] : null;
            $areaTpl = isset($params['areaTpl']) ? $params['areaTpl'] : null;
            $pointTpl = isset($params['pointTpl']) ? $params['pointTpl'] : null;
            $areaSep = isset($params['areaSep']) ? $params['areaSep'] : '';
            $pointSep = isset($params['pointSep']) ? $params['pointSep'] : '';

            $data = json_decode($value);
            $areas = array();

            if (is_object($data) && isset($data->areas)) {
                foreach ($data->areas as $area) {
                    $points = array();

                    foreach ($area as $point) {
                        if ($pointTpl) {
                            $points[] = $this->modx->getChunk($pointTpl, array(
                                'latitude' => $point->lat,
                                'longitude' => $point->lng,
                            ));
                        } else {
                            $points[] = $point->lat.$point->lng;
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
return 'GeoTVOutputRender';
