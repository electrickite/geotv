<?php
/**
 * GeoTV plugin for GeoTV extra
 *
 * @package geotv
 */

$corePath = $modx->getObject('modNamespace', 'geotv')->getCorePath();
$modx->lexicon->load('geotv:default');

switch ($modx->event->name) {
    case 'OnTVInputRenderList':
        $modx->event->output($corePath.'tv/input/');
        break;
    case 'OnTVOutputRenderList':
        $modx->event->output($corePath.'tv/output/');
        break;
    case 'OnTVInputPropertiesList':
        $modx->event->output($corePath.'tv/inputoptions/');
        break;
    case 'OnTVOutputRenderPropertiesList':
        $modx->event->output($corePath.'tv/properties/');
        break;
    case 'OnManagerPageBeforeRender':
        break;
}
