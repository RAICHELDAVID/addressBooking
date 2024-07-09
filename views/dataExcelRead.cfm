<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset spreadsheetObj = spreadsheetNew()>
    <cfset excelData = queryNew("title, Fname,Lname, gender,dob, address, street, pincode, emailID, phone, image, hobbies","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar")> 
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
                    <cfset hobbiesList &=' '&hobbyRecord.gethname()>
                </cfloop>
            </cfif>
 
            <cfset queryAddRow(excelData, 1)>
            <cfset querySetCell(excelData, "title", title)>
            <cfset querySetCell(excelData, "Fname", Fname)>
            <cfset querySetCell(excelData, "Lname", Lname)>
            <cfset querySetCell(excelData,"gender",gender)>
            <cfset querySetCell(excelData,"dob",dob)>
            <cfset querySetCell(excelData, "address", address)>
            <cfset querySetCell(excelData,'street',street)>
            <cfset querySetCell(excelData,'pincode',pincode)>
            <cfset querySetCell(excelData, "emailID", emailID)>
            <cfset querySetCell(excelData,'phone',phone)>
            <cfset querySetCell(excelData,'image',image)>
            <cfset querySetCell(excelData,'hobbies',hobbiesList)>
        </cfif>
    </cfloop>

<cfset excelFile = url.filename & "_" & createUUID() & ".xlsx">
<cfspreadsheet action="write" filename="#expandPath('./')#/#excelFile#" query="excelData">
<cfheader name="Content-Disposition" value="attachment; filename=#url.filename#.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="D:\addressBooking\views\#excelFile#" deleteFile="true">
</cfoutput>

