<cfif structKeyExists(session, "uploadedFilePath")>
    <cfif session.uploadedFilePath neq "">
        <cfspreadsheet action="read" src="#session.uploadedFilePath#" query="spreadsheetData">
        <cfif isQuery(spreadsheetData)>
            <cfset totalRows = spreadsheetData.recordCount>
            <cfif totalRows gt 0>
                <cfset firstRowList = "">
                <cfloop list="#spreadsheetData.columnList#" index="column">
                    <cfset firstRowList &= spreadsheetData[column][1]>
                    <cfif column neq listLast(spreadsheetData.columnList)>
                        <cfset firstRowList &= ",">
                    </cfif>
                </cfloop>
                <cfset firstRowData = spreadsheetNew()>
                <cfset cellIndex = 1>
                <cfloop list="#firstRowList#" index="value" delimiters=",">
                    <cfset spreadsheetSetCellValue(firstRowData, value, 1, cellIndex)>
                    <cfset cellIndex = cellIndex + 1>
                </cfloop>

                <cfheader name="Content-Disposition" value="attachment; filename=first_row.xlsx">
                <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" variable="#spreadsheetReadBinary(firstRowData)#" reset="true">
            </cfif>
        </cfif>
    <cfelse>
        <cfoutput>no excel found.</cfoutput>
    </cfif>
</cfif>

