<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>

<portlet:defineObjects />

<portlet:resourceURL var="detailMatrixUrl" id="matrixDetails"></portlet:resourceURL>

<%-- We'll fill the list dynamically via ajax call using resourceURL --%>
<div id="matrixDetails">Select a Matrix from the Matrix Table for Details</div>

<script type="text/javascript">

    $(document).ready(function(){
        var detailMatrixUrl = '<%=detailMatrixUrl%>';

        // Bind matrix_selected event on page load so that It can catch the event being called from another portlet
        Liferay.on(
                'matrix_selected',
                function(data) {
                    // When event is being executed, get the selected matrix  via ajax call using resourceURL
                    getMatrix(detailMatrixUrl, data.matrixName);
                }
        );
    });

    function getMatrix(detailMatrixUrl, matrixName)
    {
        var param="&name="+matrixName;

        $.ajax({
            type:"GET",
            url:detailMatrixUrl,
            cache:false,
            async:false,
            dataType: "json",
            data:param,
            success: function(data){
                var htmlText="";
                var count=0;
                var matrix = JSON.parse(data);
                htmlText+="<p><h1>"+ matrixName +"</h1></p>";
                htmlText+="<p>Name:"+matrix._matrixName+"<br/>";
                htmlText+="Position X:"+matrix._positionX+" - Position Y:"+matrix._positionY+"<br/>";
                htmlText+="Type:"+matrix._dataType+" - Value:"+matrix._dataValue+"<br/></p>";

                // Replace html data on #state element which we've already placed above
                $("#matrixDetails").html(htmlText);
            }
        });
    }

</script>
