<div id="tv-output-properties-form{$tv}"></div>
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
    ,autoHeight: true
    ,labelAlign: 'top'
    ,cls: 'form-with-labels'
    ,border: false
    ,items: [{
        xtype: 'textfield'
        ,fieldLabel: '{/literal}{$geotv.wrapperTpl|escape:"javascript"}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.wrapperTplDesc|escape:"javascript"}{literal}'
        ,name: 'prop_wrapperTpl'
        ,id: 'prop_wrapperTpl{/literal}{$tv}{literal}'
        ,value: params['wrapperTpl'] || ''
        ,listeners: oc
        ,width: '98%'
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'prop_wrapperTpl{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.wrapperTplDesc|escape:"javascript"}{literal}'
        ,cls: 'desc-under'
    },{
        xtype: 'textfield'
        ,fieldLabel: '{/literal}{$geotv.pointTpl|escape:"javascript"}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.pointTplDesc|escape:"javascript"}{literal}'
        ,name: 'prop_pointTpl'
        ,id: 'prop_pointTpl{/literal}{$tv}{literal}'
        ,value: params['pointTpl'] || ''
        ,listeners: oc
        ,width: '98%'
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'prop_pointTpl{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.pointTplDesc|escape:"javascript"}{literal}'
        ,cls: 'desc-under'
    },{
        xtype: 'textarea'
        ,fieldLabel: '{/literal}{$geotv.pointSep|escape:"javascript"}{literal}'
        ,description: MODx.expandHelp ? '' : '{/literal}{$geotv.pointSepDesc|escape:"javascript"}{literal}'
        ,name: 'prop_pointSep'
        ,id: 'prop_pointSep{/literal}{$tv}{literal}'
        ,value: params['pointSep'] || ''
        ,listeners: oc
        ,grow: true
        ,width: '98%'
    },{
        xtype: MODx.expandHelp ? 'label' : 'hidden'
        ,forId: 'prop_pointSep{/literal}{$tv}{literal}'
        ,html: '{/literal}{$geotv.pointSepDesc|escape:"javascript"}{literal}'
        ,cls: 'desc-under'
    }]
    ,renderTo: 'tv-output-properties-form{/literal}{$tv}{literal}'
});
// ]]>
</script>
{/literal}
