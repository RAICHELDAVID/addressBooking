<cfoutput>
    <cfset local.excelTemplate = queryNew("title, Fname,Lname, gender,dob,address, street, pincode, emailID, phone, image, hobbies","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar")> 
    <cfset local.excelFilePath = ExpandPath("../assets/uploads/") & "ContactList.xlsx">
    <cfspreadsheet action="write" filename="#local.excelFilePath#" query="local.excelTemplate" sheetname="ContactList" overwrite = "true">
    <cfheader name="Content-Disposition" value="attachment; filename=Plain_Template.xlsx">
    <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#local.excelFilePath#" deleteFile="true">
</cfoutput>
