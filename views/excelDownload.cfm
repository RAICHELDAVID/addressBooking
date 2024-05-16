<!---<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset excelData = queryNew("Title, Name, gender,address,street,pincode,emailid,phone,image")>
    <cfloop array="#persons#" index="person">
        <cfif session.userid eq person.getuserid()>
            <cfset Title = person.gettitle()>
            <cfset Name = person.getFname() & " " & person.getLname()>
            <cfset gender = person.getgender()>
            <cfset address = person.getaddress()>
            <cfset street = person.getstreet()>
            <cfset pincode = person.getpincode()>
            <cfset emailid = person.getemailID()>
            <cfset phone = person.getphone()>
        
            <cfset queryAddRow(excelData, 1)>
            <cfset querySetCell(excelData, "Title", Title)>
            <cfset querySetCell(excelData, "Name", Name)>
            <cfset querySetCell(excelData, "gender", gender)>
            <cfset querySetCell(excelData, "address", address)>
            <cfset querySetCell(excelData, "street", street)>
            <cfset querySetCell(excelData, "pincode", pincode)>
            <cfset querySetCell(excelData, "emailid", emailid)>
            <cfset querySetCell(excelData, "phone", phone)>
      	<cfelse>
			<cfcontinue>	
		</cfif>
    </cfloop>
</cfoutput>
    <cfset excelFilePath = ExpandPath("./persons.xlsx")>
    <cfspreadsheet action="write" filename="#excelFilePath#" query="excelData" sheetname="Persons">
    <cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
    <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelFilePath#" deleteFile="true">

--->
<!---
<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset excelData = queryNew("Title, Name, Gender, Address, Street, Pincode, EmailID, Phone")>

    <cfset spreadsheetObj = spreadsheetNew()>

    <cfset spreadsheetAddRow(spreadsheetObj, "Title, Name, Gender, Address, Street, Pincode, EmailID, Phone")>

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
        
            <cfset queryAddRow(excelData, 1)>
            <cfset querySetCell(excelData, "Title", Title)>
            <cfset querySetCell(excelData, "Name", Name)>
            <cfset querySetCell(excelData, "Gender", Gender)>
            <cfset querySetCell(excelData, "Address", Address)>
            <cfset querySetCell(excelData, "Street", Street)>
            <cfset querySetCell(excelData, "Pincode", Pincode)>
            <cfset querySetCell(excelData, "EmailID", EmailID)>
            <cfset querySetCell(excelData, "Phone", Phone)>
            <cfset ImageName  = person.getimage()>
                <cfset ImageURL = "../assets/uploads/" & ImageName>
            <cfif ImageURL neq "">
                <cfset spreadsheetAddImage(spreadsheetObj, ImageURL, "100,100,200,200")>
            </cfif>
      	<cfelse>
			<cfcontinue>	
		</cfif>
    </cfloop>
</cfoutput>

<cfset excelFilePath = ExpandPath("./persons.xlsx")>

<!--- Write the spreadsheet object to the file --->
<cfspreadsheet action="write" filename="#excelFilePath#" name="spreadsheetObj">

<!--- Set the appropriate HTTP headers and deliver the Excel file to the user --->
<cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelFilePath#" deleteFile="true">

--->
<cfoutput>
    <cfset persons = EntityLoad("person")>
    <cfset spreadsheetObj = spreadsheetNew()>

    <cfset spreadsheetAddRow(spreadsheetObj, "Title, Name, Gender, Address, Street, Pincode, EmailID, Phone, ImageName")>

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
            <cfset currentRow = currentRow + 1>
        </cfif>
    </cfloop>
</cfoutput>

<cfset excelFilePath ="persons_" & createUUID() & ".xlsx">
<cfspreadsheet action="write" filename="#excelFilePath#" name="spreadsheetObj">

<cfheader name="Content-Disposition" value="attachment; filename=persons.xlsx">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelFilePath#" deleteFile="true">


