<?php
if(!class_exists('GeoTVPointOutputRender')) {
    class GeoTVPointOutputRender extends modTemplateVarOutputRender {
        public function process($value, array $params = array()) {
            $locale = localeconv();

            $wrapperTpl = isset($params['wrapperTpl']) ? $params['wrapperTpl'] : null;
            $pointTpl = isset($params['pointTpl']) ? $params['pointTpl'] : null;
            $pointSep = isset($params['pointSep']) ? $params['pointSep'] : '';
            $decimalSep = isset($params['decimalSep']) ? $params['decimalSep'] : $locale['decimal_point'];

            $data = json_decode($value);
            $points = array();

            if (is_object($data) && isset($data->points)) {
                foreach ($data->points as $point) {
                    $latitude = number_format($point->lat, 8, $decimalSep, '');
                    $longitude = number_format($point->lng, 8, $decimalSep, '');

                    if ($pointTpl) {
                        $points[] = $this->modx->getChunk($pointTpl, array(
                            'latitude' => $latitude ,
                            'longitude' => $longitude,
                        ));
                    } else {
                        $points[] = $latitude.$longitude;
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
