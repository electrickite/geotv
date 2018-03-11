<?php
/**
 * Event transport file for the GeoTV plugin
 *
 * @package geotv
 * @subpackage build
 */

$events = array();

$events[0]= $modx->newObject('modPluginEvent');
$events[0]->fromArray(array(
    'event' => 'OnTVInputRenderList',
    'priority' => 0,
    'propertyset' => 0,
), '', true, true);

$events[1]= $modx->newObject('modPluginEvent');
$events[1]->fromArray(array(
    'event' => 'OnTVOutputRenderList',
    'priority' => 0,
    'propertyset' => 0,
), '', true, true);

$events[2]= $modx->newObject('modPluginEvent');
$events[2]->fromArray(array(
    'event' => 'OnTVInputPropertiesList',
    'priority' => 0,
    'propertyset' => 0,
), '', true, true);

$events[3]= $modx->newObject('modPluginEvent');
$events[3]->fromArray(array(
    'event' => 'OnTVOutputRenderPropertiesList',
    'priority' => 0,
    'propertyset' => 0,
), '', true, true);

$events[4]= $modx->newObject('modPluginEvent');
$events[4]->fromArray(array(
    'event' => 'OnDocFormPrerender',
    'priority' => 0,
    'propertyset' => 0,
), '', true, true);

return $events;
