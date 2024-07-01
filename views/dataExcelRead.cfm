<cfif structKeyExists(session, "uploadedFilePath")>
    <cfif session.uploadedFilePath neq "">
        <cfheader name="Content-Disposition" value='attachment; filename="#getFileInfo(session.uploadedFilePath).name#"'>
        <cfif listLast(session.uploadedFilePath, ".") eq "xls" or listLast(session.uploadedFilePath, ".") eq "xlsx">
            <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#session.uploadedFilePath#">
        <cfelse>
            <cfcontent type="application/octet-stream" file="#session.uploadedFilePath#">
        </cfif>
    <cfelse>
        <cfoutput>no excel found.</cfoutput>
    </cfif>
</cfif>
