<?php
/**
 * GeoTV MODX Extra build script
 *
 * @package geotv
 * @subpackage build
 */

$tstart = explode(' ', microtime());
$tstart = $tstart[1] + $tstart[0];
set_time_limit(0);

/* define package names */
define('PKG_NAME', 'GeoTV');
define('PKG_NAME_LOWER', 'geotv');
define('PKG_VERSION', '1.4.0');
define('PKG_RELEASE', 'rc2');

/* define build paths */
$root = dirname(dirname(__FILE__)) . '/';
$sources = array(
    'root' => $root,
    'build' => $root . '_build/',
    'data' => $root . '_build/data/',
    'resolvers' => $root . '_build/resolvers/',
    'lexicon' => $root . 'core/components/' . PKG_NAME_LOWER . '/lexicon/',
    'docs' => $root.'core/components/' . PKG_NAME_LOWER . '/docs/',
    'elements' => $root.'core/components/' . PKG_NAME_LOWER . '/elements/',
    'source_core' => $root.'core/components/' . PKG_NAME_LOWER,
);
unset($root);

/* set paths to MODX core and include modX base classes */
require_once $sources['build'] . 'build.config.php';
require_once MODX_CORE_PATH . 'model/modx/modx.class.php';

/* create package */
$modx = new modX();
$modx->initialize('mgr');
echo '<pre>'; /* used for nice formatting of log messages */
$modx->setLogLevel(modX::LOG_LEVEL_INFO);
$modx->setLogTarget('ECHO');

$modx->log(modX::LOG_LEVEL_INFO, 'MODX loaded. Beginning package build...'); flush();

$modx->loadClass('transport.modPackageBuilder', '', false, true);
$builder = new modPackageBuilder($modx);
$builder->createPackage(PKG_NAME_LOWER, PKG_VERSION, PKG_RELEASE);
$builder->registerNamespace(PKG_NAME_LOWER, false, true, '{core_path}components/' . PKG_NAME_LOWER . '/');
$modx->log(modX::LOG_LEVEL_INFO, 'Created Transport Package and Namespace'); flush();

/* load system settings */
$settings = include_once $sources['data'] . 'transport.settings.php';
$attributes = array(
    xPDOTransport::UNIQUE_KEY => 'key',
    xPDOTransport::PRESERVE_KEYS => true,
    xPDOTransport::UPDATE_OBJECT => false,
);
if (!is_array($settings)) { $modx->log(modX::LOG_LEVEL_ERROR, 'Adding settings failed'); }
foreach ($settings as $setting) {
    $vehicle = $builder->createVehicle($setting, $attributes);
    $builder->putVehicle($vehicle);
}
$modx->log(modX::LOG_LEVEL_INFO, 'Packaged in '.count($settings).' system settings'); flush();
unset($settings, $attributes);

/* add category */
$category = $modx->newObject('modCategory');
$category->set('id', 1);
$category->set('category', PKG_NAME);
$modx->log(modX::LOG_LEVEL_INFO, 'Packaged in category'); flush();

/* add plugins */
$plugins = include $sources['data'].'transport.plugins.php';
if (!is_array($plugins)) { $modx->log(modX::LOG_LEVEL_ERROR, 'Adding plugins failed.'); }
$category->addMany($plugins, 'Plugins');
$modx->log(modX::LOG_LEVEL_INFO, 'Packaged in '.count($plugins).' plugins'); flush();
unset($plugins);

/* create category vehicle */
$attr = array(
    xPDOTransport::UNIQUE_KEY => 'category',
    xPDOTransport::PRESERVE_KEYS => false,
    xPDOTransport::UPDATE_OBJECT => true,
    xPDOTransport::RELATED_OBJECTS => true,
    xPDOTransport::RELATED_OBJECT_ATTRIBUTES => array (
        'Plugins' => array(
            xPDOTransport::UNIQUE_KEY => 'name',
            xPDOTransport::PRESERVE_KEYS => false,
            xPDOTransport::UPDATE_OBJECT => true,
            xPDOTransport::RELATED_OBJECTS => true,
            xPDOTransport::RELATED_OBJECT_ATTRIBUTES => array (
                'PluginEvents' => array(
                    xPDOTransport::PRESERVE_KEYS => true,
                    xPDOTransport::UPDATE_OBJECT => false,
                    xPDOTransport::UNIQUE_KEY => array('pluginid', 'event'),
                ),
            ),
        ),
    ),
);
$vehicle = $builder->createVehicle($category, $attr);

/* Add resolvers */
$resolvers = glob($sources['resolvers'] . '*.php');
foreach($resolvers as $resolver) {    
    $vehicle->resolve('php', array('source' => $resolver));
    $modx->log(modX::LOG_LEVEL_INFO, 'Added resolver: ' . basename($resolver)); flush();
}

/* add file resolver for core directory */
$vehicle->resolve('file', array(
    'source' => $sources['source_core'],
    'target' => "return MODX_CORE_PATH . 'components/';",
));
$modx->log(modX::LOG_LEVEL_INFO, 'Packaged in file resolvers'); flush();

/* add vehicle to package */
$builder->putVehicle($vehicle);

/* add package information */
$builder->setPackageAttributes(array(
    'license' => file_get_contents($sources['docs'] . 'license.txt'),
    'readme' => file_get_contents($sources['docs'] . 'readme.txt'),
    'changelog' => file_get_contents($sources['docs'] . 'changelog.txt'),
));
$modx->log(modX::LOG_LEVEL_INFO, 'Added package attributes and setup options'); flush();

/* zip up package */
$modx->log(modX::LOG_LEVEL_INFO, 'Packing up transport package zip...');
$builder->pack();

$tend = explode(" ", microtime());
$tend = $tend[1] + $tend[0];
$totalTime = sprintf("%2.4f s", ($tend - $tstart));
$modx->log(modX::LOG_LEVEL_INFO, "\n<br />Package Built<br />\nExecution time: {$totalTime}\n");

exit();
