<?php
/**
 * GeoTV MODX Extra system settings transport script
 *
 * @package geotv
 * @subpackage build
 */

$settings = array();

$settings[1]= $modx->newObject('modSystemSetting');
$settings[1]->fromArray(array(
    'key' => 'geotv.api_key',
    'value' => '',
    'xtype' => 'textfield',
    'namespace' => 'geotv',
    'area' => 'maps',
), '', true, true);

return $settings;
