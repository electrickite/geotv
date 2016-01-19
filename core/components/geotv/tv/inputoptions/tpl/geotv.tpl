<div id="tv-input-properties-form{$tv}"></div>
{literal}

<script type="text/javascript">
// <![CDATA[
var params = {
{/literal}{foreach from=$params key=k item=v name='p'}
 '{$k}': '{$v|escape:"javascript"}'{if NOT $smarty.foreach.p.last},{/if}
{/foreach}{literal}
};
var oc = {'change':{fn:function(){Ext.getCmp('modx-panel-tv').markDirty();},scope:this}};

MODx.load({
    xtype: 'panel'
    ,layout: 'form'
    ,cls: 'form-with-labels'
    ,autoHeight: true
    ,border: false
    ,labelAlign: 'top'
    ,labelSeparator: ''
    ,items: [{
        xtype: 'combo-boolean'
        ,fieldLabel: '{/literal}{$geotv.allowMultiple}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.allowMultipleDesc}{literal}'
        ,name: 'inopt_allowMultiple'
        ,hiddenName: 'inopt_allowMultiple'
        ,id: 'inopt_allowMultiple{/literal}{$tv}{literal}'
        ,value: params['allowMultiple'] == 0 || params['allowMultiple'] == 'false' ? false : true
        ,width: 200
        ,listeners: oc
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'inopt_allowMultiple{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.allowMultipleDesc}{literal}'
        ,cls: 'desc-under'
    },{
        xtype: 'numberfield'
        ,fieldLabel: '{/literal}{$geotv.centerLat}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.centerLatDesc}{literal}'
        ,name: 'inopt_centerLat'
        ,hiddenName: 'inopt_centerLat'
        ,id: 'inopt_centerLat{/literal}{$tv}{literal}'
        ,value: params['centerLat'] || ''
        ,width: 200
        ,maxValue: 90
        ,minValue: -90
        ,decimalPrecision: 8
        ,listeners: oc
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'inopt_centerLat{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.centerLatDesc}{literal}'
        ,cls: 'desc-under'
    },{
        xtype: 'numberfield'
        ,fieldLabel: '{/literal}{$geotv.centerLng}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.centerLngDesc}{literal}'
        ,name: 'inopt_centerLng'
        ,hiddenName: 'inopt_centerLng'
        ,id: 'inopt_centerLng{/literal}{$tv}{literal}'
        ,value: params['centerLng'] || ''
        ,width: 200
        ,maxValue: 180
        ,minValue: -180
        ,decimalPrecision: 8
        ,listeners: oc
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'inopt_centerLng{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.centerLngDesc}{literal}'
        ,cls: 'desc-under'
    },{
        xtype: 'numberfield'
        ,fieldLabel: '{/literal}{$geotv.zoom}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.zoomDesc}{literal}'
        ,name: 'inopt_zoom'
        ,hiddenName: 'inopt_zoom'
        ,id: 'inopt_zoom{/literal}{$tv}{literal}'
        ,value: params['zoom'] || ''
        ,width: 200
        ,allowNegative: false
        ,allowDecimals: false
        ,maxValue: 30
        ,listeners: oc
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'inopt_zoom{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.zoomDesc}{literal}'
        ,cls: 'desc-under'
    }]
    ,renderTo: 'tv-input-properties-form{/literal}{$tv}{literal}'
});
// ]]>
</script>
{/literal}
