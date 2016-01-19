<?php
if(!class_exists('GeoTVPointOutputRender')) {
    class GeoTVPointOutputRender extends modTemplateVarOutputRender {
        public function process($value, array $params = array()) {
            $wrapperTpl = isset($params['wrapperTpl']) ? $params['wrapperTpl'] : null;
            $pointTpl = isset($params['pointTpl']) ? $params['pointTpl'] : null;
            $pointSep = isset($params['pointSep']) ? $params['pointSep'] : '';

            $data = json_decode($value);
            $points = array();

            if (is_object($data) && isset($data->points)) {
                foreach ($data->points as $point) {
                    if ($pointTpl) {
                        $points[] = $this->modx->getChunk($pointTpl, array(
                            'latitude' => $point->lat,
                            'longitude' => $point->lng,
                        ));
                    } else {
                        $points[] = $point->lat.$point->lng;
                    }
                }

                $pointsString = implode($pointSep, $points);

                if ($wrapperTpl) {
                    $output = $this->modx->getChunk($wrapperTpl, array(
                        'points' => $pointsString,
                    ));
                } else {
                    $output = $pointsString;
                }

                return $output;
            }
        }
    }
}
return 'GeoTVPointOutputRender';
