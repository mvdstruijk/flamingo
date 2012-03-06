<%--
Copyright (C) 2011 B3Partners B.V.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/taglibs.jsp"%>

<stripes:layout-render name="/WEB-INF/jsp/templates/ext.jsp">
    <stripes:layout-component name="head">
        <title>Geo service</title>
    </stripes:layout-component>
    <stripes:layout-component name="body">

<p>
    <stripes:errors/>
    <stripes:messages/>
</p>

<stripes:form beanclass="nl.b3p.viewer.admin.stripes.GeoServiceActionBean">

<script type="text/javascript">
    var frameParent = getParent();

    <c:if test="${actionBean.serviceDeleted}">
        if(frameParent && frameParent.removeTreeNode && '${actionBean.service.id}' != '') {
            frameParent.removeTreeNode('s${actionBean.service.id}');
        }
    </c:if>
    <c:if test="${actionBean.newService != null}">
        if(frameParent && frameParent.addServiceNode && '${actionBean.service.id}' != '') {
            frameParent.addServiceNode(${actionBean.newService});
        }
    </c:if>
    <c:if test="${actionBean.context.eventName == 'save'}">
        if(frameParent && frameParent.renameNode && '${actionBean.service.name}' != '') {
            frameParent.renameNode('s${actionBean.service.id}','${actionBean.service.name}');
        }
    </c:if>
</script>

<c:if test="${!actionBean.serviceDeleted && actionBean.context.eventName != 'cancel'}">
    <c:set var="edit" value="${!empty actionBean.service.id}"/>

    <stripes:hidden name="category"/>
    <stripes:hidden name="service"/>

    <c:if test="${!edit}"><h1>Nieuwe service toevoegen aan <c:out value="${actionBean.category.name}"/></h1></c:if>
    <c:if test="${edit}"><h1>Service <c:out value="${actionBean.service.name}"/> bewerken</h1></c:if>
    
    <p>
    <script type="text/javascript">
        function checkProtocol() {
            var protocol = Ext.query("select[name='protocol']")[0].value;
            Ext.fly('useUrlTr').setVisible(protocol == "wms");
            Ext.fly('serviceNameTr').setVisible(protocol == "arcims");            
        }

        Ext.onReady(checkProtocol);
    </script>    
    <table>
        <tr>
            <td>URL van de service:</td>
            <td><stripes:text name="url" maxlength="255" size="80" disabled="${edit}"/></td>
        </tr>
        <tr><td>Protocol:</td>
            <td>
                <stripes:select name="protocol" disabled="${edit}" onchange="checkProtocol()" onkeyup="checkProtocol()">
                    <stripes:option value="wms">WMS</stripes:option>
                    <stripes:option value="arcgis">ArcGIS MapServer (REST)</stripes:option>
                    <stripes:option value="arcims">ArcIMS</stripes:option>
                </stripes:select>
            </td>
        </tr>
        <tr id="useUrlTr">
            <td colspan="2">
                <label>
                    <stripes:checkbox name="overrideUrl"/>Gebruik altijd ingevulde URL in plaats van URLs in GetCapabilities
                </label>
            </td>
        </tr>
        <tr id="serviceNameTr">
            <td>Service name:</td>
            <td>
            <label>
                <stripes:text name="serviceName" maxlength="255" size="30" disabled="${edit}"/>
            </label>
            </td>
        </tr>        
        <tr>
            <td>Weergavenaam:</td>
            <td><stripes:text name="name" maxlength="255" size="30"/></td>
        </tr>
        <tr>
            <td>Gebruikersnaam:</td>
            <td><stripes:text name="username" maxlength="255" size="30"/></td>
        </tr>
        <tr>
            <td>Wachtwoord:</td>
            <td><stripes-dynattr:password name="password" autocomplete="off" maxlength="255" size="30"/></td>
        </tr>
        <c:if test="${!edit}">
            <tr>
                <td colspan="2"><i>De weergavenaam wordt bij het inladen van de service
                        automatisch bepaald. Bovenstaand kan optioneel een alternatieve weergavenaam
                        worden ingevuld.</i>
                </td>
            </tr>
        </c:if>
    </table>
    </p>
    
    <c:choose>
        <c:when test="${!edit}">
            <stripes:submit name="add" value="Service inladen"/>
            <stripes:submit name="cancel" value="Annuleren"/>
        </c:when>
        <c:otherwise>
            <stripes:submit name="save" value="Opslaan"/>
            <stripes:submit name="delete" onclick="return deleteServiceConfirm();" value="Verwijder service"/>
            <stripes:submit name="cancel" value="Annuleren"/>
            <script type="text/javascript">
                function deleteServiceConfirm() {
                    return confirm('Weet u zeker dat u deze service wilt verwijderen?');
                }
            </script>
        </c:otherwise>
    </c:choose>
</c:if>
            
</stripes:form>
            
    </stripes:layout-component>
</stripes:layout-render>