<?php
/**
 * GeoTV MODX Extra plugin transport script
 *
 * @package geotv
 * @subpackage build
 */

$plugins = array();

/* create the plugin object */
$plugins[1] = $modx->newObject('modPlugin');
$plugins[1]->set('id', 1);
$plugins[1]->set('property_preprocess', false);
$plugins[1]->set('name', 'GeoTV');
$plugins[1]->set('description', 'Plugin adds geofencing TV');
$plugins[1]->set('category', 0);
$plugins[1]->setContent(file_get_contents($sources['elements'] . 'plugins/geotv.plugin.php'));

$events = include $sources['data'] . 'events/geotv.events.php';
if (is_array($events) && !empty($events)) {
    $plugins[1]->addMany($events);
    $modx->log(xPDO::LOG_LEVEL_INFO, 'Packaged in '.count($events).' Plugin Events for GeoTV plugin'); flush();
} else {
    $modx->log(xPDO::LOG_LEVEL_ERROR, 'Could not find plugin events for GeoTV plugin!');
}
unset($events);

return $plugins;
