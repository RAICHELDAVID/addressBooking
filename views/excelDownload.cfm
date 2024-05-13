<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset excelData = queryNew("Name, Email, Phone", "varchar, varchar, varchar")>
    <cfloop array="#persons#" index="person">
        <cfset name = person.getFname() & " " & person.getLname()>
        <cfset email = person.getemailID()>
        <cfset phone = person.getphone()>
        <cfset queryAddRow(excelData, 1)>
        <cfset querySetCell(excelData, "Name", name)>
        <cfset querySetCell(excelData, "Email", email)>
        <cfset querySetCell(excelData, "Phone", phone)>
    </cfloop>
</cfoutput>
    <cfset excelFilePath = ExpandPath("./persons.xlsx")>
    <cfspreadsheet action="write" filename="#excelFilePath#" query="excelData" sheetname="Persons">
    <cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
    <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelFilePath#" deleteFile="true">

