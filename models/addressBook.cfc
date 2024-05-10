
<cfcomponent>

    <cffunction name="doLoginAuthenticate" access="public" returntype="query">
        <cfargument name="strUsername" type="string" required="true">
        <cfargument name="strPassword" type="string" required="true">
        <cfset var hashValue = hash(arguments.strPassword)>
        <cfquery name="getUser" datasource="demo">
            SELECT username, password,fullname
            FROM usertable
            WHERE username = <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">
            AND password = <cfqueryparam value="#hashValue#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn getUser>
    </cffunction>

    <cffunction  name="isUserExist" returntype="query">
        <cfargument  name="strUsername" required="true" type="string">
        <cfargument  name="strEmail" required="true" type="string">
        <cfquery name="getUser" datasource="demo">
            SELECT username,emailID FROM usertable
            WHERE username=<cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">
            OR emailID=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn getUser>
    </cffunction>

    <cffunction  name="selectData"  access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        <cfquery name="selectData" datasource="demo">
            SELECT title,Fname,Lname,gender,address,street,pincode,emailID,phone FROM person 
            WHERE personid=<cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset responseData={}>
        <cfset responseData["a"] = selectData.title>
        <cfset responseData["b"] = selectData.Fname>
        <cfset responseData["c"] = selectData.Lname>
        <cfset responseData["d"] = selectData.gender>
        <cfset responseData["f"] = selectData.address>
        <cfset responseData["g"] = selectData.street>
        <cfset responseData["h"] = selectData.pincode>
        <cfset responseData["i"] = selectData.emailID>
        <cfset responseData["j"] = selectData.phone>
    <cfreturn responseData>
    </cffunction>

    <cffunction  name="saveUser" access="remote" returnformat="json">
        <cfargument  name="strName" required="true" type="string">
        <cfargument  name="strEmail" required="true" type="string">
        <cfargument  name="strUsername" required="true" type="string">
        <cfargument  name="strPassword" required="true" type="string">
        <cfargument  name="strConfirmPassword" required="true" type="string">
        <cfset local.hashedPassword=hash(arguments.strPassword)>
        <cfquery name="addToTable" datasource="demo">
            INSERT INTO usertable(fullname,emailID,username,password,confirmpassword)
            VALUES (
                <cfqueryparam value="#arguments.strName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        <cfreturn {"success":true,"message":"inserted!!"}>
    </cffunction>

    <cffunction  name="savePage" access="remote" returnformat="json">
        <cfargument  name="strTitle" required="true" type="string">
        <cfargument  name="strFirstName" required="true" type="string">
        <cfargument  name="strLastName" required="true" type="string">
        <cfargument  name="strGender" required="true" type="string">
        <cfargument  name="strBirthday" required="true" type="string">
        <cfargument  name="strAddress" required="true" type="string">
        <cfargument  name="strStreet" required="true" type="string">
        <cfargument  name="intPincode" required="true" type="integer">
        <cfargument  name="strEmailID" required="true" type="string">
        <cfargument  name="intPhoneNumber" required="true" type="string">
        <cfset formattedDate = DateFormat(arguments.strBirthday, "dd-mm-yyyy")>
        <cfquery name="addToTable" datasource="demo">
            INSERT INTO person(title,Fname,Lname,gender,[Date of Birth],address,street,pincode,emailID,phone,userid)
            VALUES (
                <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,                
                <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.intPincode#" cfsqltype="cf_sql_integer">,                
                <cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.intPhoneNumber#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value=#session.userid# cfsqltype="cf_sql_integer">
            )
        </cfquery>
        <cfreturn {"success":true,"message":"inserted!!"}>
    </cffunction>

    <cffunction name="displayData" access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        <cfquery name="displayDataQuery" datasource="demo">
            SELECT  CONCAT(title,' ',Fname,' ',Lname) AS name,gender,[Date of Birth],concat(address,' ',street) as address,pincode,emailID,phone
            FROM person 
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn displayDataQuery>
    </cffunction>

    <cffunction name="deleteData" access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        <cfquery name="deleteData" datasource="demo">
            DELETE FROM person WHERE personid=<cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"message":true}>
    </cffunction>

</cfcomponent>
