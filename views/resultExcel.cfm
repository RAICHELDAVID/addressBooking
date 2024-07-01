<cfoutput>
    <cfset result = EntityLoad("resultExcel")>
    <cfset spreadsheetObj = spreadsheetNew()>
    <cfset spreadsheetAddRow(spreadsheetObj, "title, Fname,Lname,gender,dob, address, street, pincode, emailID, phone, image,hobbies,result")>
    <cfset currentRow = 2>

    <cfloop array="#result#" index="person">
        <cfif session.userid eq person.getuserid()>
            <cfset title = person.gettitle()>
            <cfset Fname = person.getFname()>
            <cfset Lname = person.getLname()>
            <cfset gender = person.getgender()>
            <cfset dob = person.getdob()>
            <cfset address = person.getaddress()>
            <cfset street = person.getstreet()>
            <cfset pincode = person.getpincode()>
            <cfset emailID = person.getemailID()>
            <cfset phone = person.getphone()>
            <cfset image = person.getimage()>
            <cfset hobbies = person.gethobbies()>
            <cfset result = person.getValidationResult()>

            <cfset spreadsheetSetCellValue(spreadsheetObj, title, currentRow, 1)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Fname, currentRow, 2)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, Lname, currentRow, 3)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, gender, currentRow, 4)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, dob, currentRow, 5)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, address, currentRow, 6)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, street, currentRow, 7)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, pincode, currentRow, 8)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, emailID, currentRow, 9)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, phone, currentRow, 10)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, image, currentRow, 11)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, hobbies, currentRow, 12)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, result, currentRow, 13)>
            <cfset currentRow = currentRow + 1>
        </cfif>    
    </cfloop>
</cfoutput>

<cfset excelFilePath ="persons_" & createUUID() & ".xlsx">
<cfspreadsheet action="write" filename="#excelFilePath#" name="spreadsheetObj">

<cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="D:\addressBooking\views\#excelFilePath#" deleteFile="true">
