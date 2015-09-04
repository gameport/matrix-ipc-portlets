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

<portlet:resourceURL var="displayMatrixUrl" id="displayMatrix"></portlet:resourceURL>

<%-- We'll fill the list dynamically via ajax call using resourceURL --%>
<div id="matrixList"></div>

<script type="text/javascript">
    $(document).ready(function(){
        var displayMatrixUrl = '<%=displayMatrixUrl%>';

        // On load of page we'll load the category via ajax call by using resourceURL
        loadMatrix(displayMatrixUrl);
    });


    function loadMatrix(displayMatrixUrl)
    {
        var param="&COMMAND=GetMatrix";

        $.ajax({
            type:"GET",
            url:displayMatrixUrl,
            cache:false,
            async:false,
            dataType: "json",
            data:param,
            success: function(data){
                // Replace html data on #matrix element which we've already placed above with the aui data table
                YUI().use('datatable-base','datatable-scroll','datatable-sort', function(T) {
                    var columns = [
                        {
                            key: '_matrixName',
                            label: 'Matrix Name'
                        }/*,{
                         key: '_positionX',
                         label: 'Position X'
                         },{
                         key: '_positionY',
                         label: 'Position Y'
                         },{
                         key: '_dataType',
                         label: 'Data Type'
                         },{
                         key: '_dataValue',
                         label: 'Data Value'
                         }*/];

                    // preparing matrices list
                    matrices = $.parseJSON(data);

                    myDataTable = new T.DataTable(
                            {
                                columnset: columns,
                                recordset: matrices,
                                sortBy: ['_matrixName'],
                                height: '80%',
                                width: '90%',
                                scrollable: 'y'
                            }
                    ).render('#matrixList');

                    T.delegate('click', function(e) {
                        var selectedMatrixName = this.getRecord(e.target).get("_matrixName");
                        // Fire the matrix_selected event of matrix Portlet by passing selected matrix name.
                        Liferay.fire('matrix_selected',
                                {
                                    matrixName : selectedMatrixName
                                }
                        );
                    }, '#matrixList', 'td', myDataTable);

                });
            }
        });
    }

</script>
