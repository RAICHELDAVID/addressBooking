<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset spreadsheetObj = spreadsheetNew()>
    <cfset spreadsheetAddRow(spreadsheetObj, "title, Fname,Lname, gender,dob, address, street, pincode, emailID, phone, image, hobbies")>
    <cfset currentRow = 2>

    <cfloop array="#persons#" index="person">
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
            <cfset hobbiesList = ''>
            <cfset hobbies = EntityLoad("hobbies", { personid = person})>
            <cfif arrayLen(hobbies)>
                <cfloop array="#hobbies#" index="hobby">
                    <cfset hobbyRecord = entityLoadByPK("hobbytable", hobby.gethid())>
                    <cfset hobbiesList &= hobbyRecord.gethname() & ', '>
                </cfloop>
            </cfif>
            <cfif len(trim(image))>
                <cfset ImageURL = ExpandPath("./assets/uploads/") & image>
            <cfelse>
                <cfset ImageURL = "">
            </cfif>

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
            <cfset spreadsheetSetCellValue(spreadsheetObj, ImageURL, currentRow, 11)>
            <cfset spreadsheetSetCellValue(spreadsheetObj, hobbiesList, currentRow, 12)>
            
            <cfset currentRow = currentRow + 1>
        </cfif>
    </cfloop>
</cfoutput>

<cfset excelFilePath = "persons_" & createUUID() & ".xlsx">
<cfspreadsheet action="write" filename="#excelFilePath#" name="spreadsheetObj">

<cfheader name="Content-Disposition" value="attachment; filename=ContactList.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="D:\addressBooking\views\#excelFilePath#" deleteFile="true">
