/* 
 * Copyright (C) 2012 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
/**
 * BufferObject component
 * Creates a BufferObject component
 * @author <a href="mailto:roybraam@b3partners.nl">Roy Braam</a>
 */
Ext.define ("viewer.components.BufferObject",{
    extend: "viewer.components.Component",
    combobox: null,
    radius:null,
    tmc:null,
    vectorLayer:null,
    config: {
        layers:null,
        title:null,
        iconUrl:null
    },    
    constructor: function (conf){        
        viewer.components.BufferObject.superclass.constructor.call(this, conf);
        this.initConfig(conf);
        var config = {
            id: this.name,
            handler:{
                fn: this.mapClicked,
                scope:this
            },
            viewerController: this.viewerController
        };
        this.vectorLayer=viewerController.mapComponent.createVectorLayer({
            id: 'boVectorLayer',
            name:'boVectorLayer',
            geometrytypes:["Circle","Polygon"],
            showmeasures:true,
                style: {
                fillcolor: "0xFF0000",
                fillopacity: 50,
                strokecolor: "0xFF0000",
                strokeopacity: 100
            }
        });
        viewerController.mapComponent.getMap().addLayer(this.vectorLayer);
        this.tmc = Ext.create ("viewer.components.tools.ToolMapClick",config);
        var me = this;
        this.renderButton({
            handler: function(){
                me.buttonClick();
            },
            text: me.title,
            icon: me.iconUrl,
            tooltip: me.tooltip
        });
        this.loadWindow();
        return this;
    }      ,
    buttonClick : function (){
        this.popup.show();
    },
    loadWindow : function(){
        var layers = [];
        for( var i = 0 ; i < this.layers.length;i++){
            var layer = this.viewerController.getLayerByLayerId(this.layers[i]);
            layers.push({
                id: layer.serviceId+"_"+layer.options.name,
                title: layer.options.name,
                layer: layer
            });
        }
        var layerStore = Ext.create('Ext.data.Store', {
            fields: ['id', 'title','layer'],
            data : layers
        });

        this.combobox = Ext.create('Ext.form.ComboBox', {
            fieldLabel: 'Kies kaartlaag',
            store: layerStore,
            queryMode: 'local',
            displayField: 'title',
            valueField: 'layer',
            renderTo: this.getContentDiv()
        });
        this.radius = Ext.create("Ext.form.field.Text",{
            name: "straal" ,
            fieldLabel: "Straal",
            renderTo: this.getContentDiv()
        });
        
        Ext.create("Ext.button.Button",{
            name: "selectObject" ,
            text: "Selecteer object op de kaart",
            renderTo: this.getContentDiv(),
            listeners: {
                click:{
                    scope: this,
                    fn: this.buffer
                }
            }
        });
        
        Ext.create("Ext.button.Button",{
            name: "removeBuffer" ,
            text: "Huidige buffer verwijderen",
            renderTo: this.getContentDiv(),
            listeners: {
                click:{
                    scope: this,
                    //fn: this.removeBuffer
                    fn: this.addWktToMapcomponent
                }
            }
        });
    },
    buffer : function (){
        this.tmc.activateTool();
    },
    mapClicked : function (toolMapClick,comp){
        this.tmc.deactivateTool();
        var coords = comp[1];
        var x = coords.x;
        var y = coords.y;
        console.log("xy", x,y);
    },
    addWktToMapcomponent : function (wkt){
        wkt ="POLYGON((98914.7905763337 576961.290540899,101360.775481459 488905.833956381,166179.375467285 487071.345277537,174128.826408943 570234.832051804,146611.496226281 610593.582986375,98914.7905763337 576961.290540899))";
        var feature = Ext.create("viewer.viewercontroller.controller.Feature",{id: 1, wkt: wkt});
        this.vectorLayer.addFeature(feature);
        
    }
});
