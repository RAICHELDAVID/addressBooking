<cfif structKeyExists(session, "exportPath") and session.exportPath neq "">
    <cfheader name="Content-Disposition" value="attachment; filename=exported_data.xlsx">
    <cfcontent file="#session.exportPath#" type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
</cfif>

