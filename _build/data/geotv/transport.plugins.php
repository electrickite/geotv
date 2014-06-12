<?php
/**
 * plugins transport file for GeoTV extra
 *
 * @package geotv
 * @subpackage build
 */

if (! function_exists('stripPhpTags')) {
    function stripPhpTags($filename) {
        $o = file_get_contents($filename);
        $o = str_replace('<' . '?' . 'php', '', $o);
        $o = str_replace('?>', '', $o);
        $o = trim($o);
        return $o;
    }
}
/* @var $modx modX */
/* @var $sources array */
/* @var xPDOObject[] $plugins */


$plugins = array();

$plugins[1] = $modx->newObject('modPlugin');
$plugins[1]->fromArray(array (
  'id' => 1,
  'description' => 'Plugin adds geofencing TV',
  'name' => 'GeoTV',
), '', true, true);
$plugins[1]->setContent(file_get_contents($sources['source_core'] . '/elements/plugins/geotv.plugin.php'));

return $plugins;
