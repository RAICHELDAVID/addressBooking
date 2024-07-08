
<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset spreadsheetObj = spreadsheetNew()>
    <cfset spreadsheetAddRow(spreadsheetObj, "Title, Name, Gender, Address, Street, Pincode, EmailID, Phone, ImageName, Hobbies")>
    <cfset currentRow = 2>

    <cfloop array="#persons#" index="person">
        <cfif session.userid eq person.getuserid()>
            <cfset Title = person.gettitle()>
            <cfset Name = person.getFname() & " " & person.getLname()>
            <cfset Gender = person.getgender()>
            <cfset Address = person.getaddress()>
            <cfset Street = person.getstreet()>
            <cfset Pincode = person.getpincode()>
            <cfset EmailID = person.getemailID()>
            <cfset Phone = person.getphone()>
            <cfset ImageName = person.getimage()>
            <cfset hobbiesList = ''>
            <cfset hobbies = EntityLoad("hobbies", { personid = person})>
            <cfif arrayLen(hobbies)>
                <cfloop array="#hobbies#" index="hobby">
                    <cfset hobbyRecord = entityLoadByPK("hobbytable", hobby.gethid())>
                    <cfset hobbiesList &= hobbyRecord.gethname() & ', '>
                </cfloop>
            </cfif>
            <cfif len(trim(ImageName))>
                <cfset ImageURL = ExpandPath("./assets/uploads/") & ImageName>
            <cfelse>
                <cfset ImageURL = "">
            </cfif>

            <cfset spreadsheetSetCellValue(spreadsheetObj, Title, currentRow, 1)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Name, currentRow, 2)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Gender, currentRow, 3)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Address, currentRow, 4)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Street, currentRow, 5)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Pincode, currentRow, 6)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, EmailID, currentRow, 7)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Phone, currentRow, 8)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, ImageURL, currentRow, 9)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, hobbiesList, currentRow, 10)>
            
            <cfset currentRow = currentRow + 1>
        </cfif>
    </cfloop>
</cfoutput>

<cfset excelFilePath = "persons_" & createUUID() & ".xlsx">
<cfspreadsheet action="write" filename="#excelFilePath#" name="spreadsheetObj">

<cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="D:\addressBooking\views\#excelFilePath#" deleteFile="true">
