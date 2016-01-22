<?php
$locale = localeconv();
$lang = $modx->lexicon->fetch('geotv.', true);
$modx->smarty->assign('geotv', $lang);
$modx->smarty->assign('geotv_decimal_sep_default', $locale['decimal_point']);

$corePath = $modx->getObject('modNamespace', 'geotv')->getCorePath();
return $modx->smarty->fetch($corePath . 'tv/properties/tpl/geotv_geopoint.tpl');
