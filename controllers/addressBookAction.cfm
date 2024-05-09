<cfset variables.strFirstName="">
<cfset variables.strLastName="">
<cfset variables.strBirthday="">
<cfset variables.strAddress="">
<cfset variables.strStreet="">
<cfset variables.intPincode="">
<cfset variables.strEmailID="">
<cfset variables.intPhoneNumber="">
<cfset personid=0>
<cfif structKeyExists(url, "personid")>
    <cfset personid = url.personid>
    <cfset local.result = createObject("component", "models.addressBook").displayData(personid)>
    <cfset variables.strFirstName = local.result.Fname>
    <!---<cfset variables.strLastName = local.result.strLastName>
    <cfset variables.strBirthday = local.result.strBirthday>
    <cfset variables.strAddress = local.result.strAddress>
    <cfset variables.strStreet = local.result.strStreet>
    <cfset variables.intPincode = local.result.intPincode>
    <cfset variables.strEmailID = local.result.strEmailID>
    <cfset variables.intPhoneNumber = local.result.intPhoneNumber>--->
</cfif>




