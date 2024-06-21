<cfcomponent>
    <cffunction name="doLoginAuthenticate" access="public" returntype="query">
        <cfargument name="strEmail" type="string" required="true">
        <cfargument name="strPassword" type="string" required="true">
        <cfset var hashValue = hash(arguments.strPassword)>
        <cfquery name="getUser" datasource="demo">
            SELECT emailID, password,fullname,userid,image
            FROM usertable
            WHERE emailID = <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
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
            SELECT personid,title,Fname,Lname,gender,dob,address,street,pincode,emailID,phone,image FROM person 
            WHERE personid=<cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset parsedDate = ParseDateTime(selectData.dob)>
        <cfset formattedDate = DateFormat(parsedDate, "yyyy-MM-dd")>
        <cfset responseData={}>
        <cfset responseData["personid"] = selectData.personid>
        <cfset responseData["title"] = selectData.title>
        <cfset responseData["Fname"] = selectData.Fname>
        <cfset responseData["Lname"] = selectData.Lname>
        <cfset responseData["gender"] = selectData.gender>
        <cfset responseData["dob"] = formattedDate>
        <cfset responseData["address"] = selectData.address>
        <cfset responseData["street"] = selectData.street>
        <cfset responseData["pincode"] = selectData.pincode>
        <cfset responseData["emailID"] = selectData.emailID>
        <cfset responseData["phone"] = selectData.phone>
        <cfset responseData["image"] = selectData.image>

        <cfset hobbiesQuery = getHobbiesId(personid)>
       <cfset hobbies= []>
        <cfoutput query="hobbiesQuery">
            <cfset arrayAppend(hobbies, hobbiesQuery.hid)>
        </cfoutput>
   <cfset responseData["hobbies"] = []>
<cfloop array="#hobbies#" index="hid">
    <cfquery name="getHobbyName" datasource="demo">
        SELECT hname
        FROM hobbyTable
        WHERE hid = <cfqueryparam value="#hid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif getHobbyName.recordCount>
        <cfset arrayAppend(responseData["hobbies"], getHobbyName.hname)>
    </cfif>
</cfloop>
        <cfreturn responseData>
    </cffunction>

    <cffunction name="getHobbiesId" access="public" returntype="query">
        <cfargument name="personid" type="numeric" required="true">

        <cfquery name="selectHobbiesId" datasource="demo">
            SELECT hid
            FROM person_hobbies
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn selectHobbiesId>
    </cffunction>



    <cffunction  name="isEmailExist" returntype="query">
        <cfargument  name="strEmailID" required="true" type="string">
        <cfquery name="getEmail" datasource="demo">
            SELECT emailID FROM person
            WHERE emailID=<cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar"> UNION
            SELECT emailID FROM usertable
            WHERE emailID=<cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn getEmail>
    </cffunction>

    <cffunction  name="saveUser" access="remote" returnformat="json">
        <cfargument  name="strName" required="true" type="string">
        <cfargument  name="strEmail" required="true" type="string">
        <cfargument  name="strUsername" required="true" type="string">
        <cfargument  name="strPassword" required="true" type="string">
        <cfargument  name="strConfirmPassword" required="true" type="string">
        <cfargument name="adminPictureFile" required="true" type="any">
        <cfset local.hashedPassword=hash(arguments.strPassword)>
        <cfset local.uploadPath = expandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique" filefield="adminPictureFile">
        <cfset local.image = cffile.serverFile>
        <cfquery name="addToTable" datasource="demo">
            INSERT INTO usertable(fullname,emailID,username,password,confirmpassword,image)
            VALUES (
                <cfqueryparam value="#arguments.strName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        <cfreturn {"success":true,"message":"Successful registration"}>
    </cffunction>

    <cffunction name="displayData" access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        
 <cfquery name="displayDataQuery" datasource="demo">
    SELECT CONCAT(p.title, ' ', p.Fname, ' ', p.Lname) AS name,
        p.gender,
        p.dob,
        CONCAT(p.address, ' ', p.street) AS address,
        p.pincode,
        p.emailID,
        p.phone,
        p.image,
        h.hid,
        ht.hname AS hobbyName  
    FROM person p
    LEFT JOIN person_hobbies h ON p.personid = h.personid
    LEFT JOIN hobbyTable ht ON h.hid = ht.hid  
    WHERE p.personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
</cfquery>
<cfreturn displayDataQuery>
    </cffunction>


    <cffunction name="deleteData" access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        <cfquery name="deleteData" datasource="demo">
            DELETE FROM person_hobbies
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            DELETE FROM person
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">


        </cfquery>
        <cfreturn {"message":true}>
    </cffunction>

    <!---<cffunction name="savePage" access="remote" returnformat="json">
        <cfargument name="personid" required="false" type="integer">
        <cfargument name="strTitle" required="true" type="string">
        <cfargument name="strFirstName" required="true" type="string">
        <cfargument name="strLastName" required="true" type="string">
        <cfargument name="strGender" required="true" type="string">
        <cfargument name="strBirthday" required="true" type="string">
        <cfargument name="strAddress" required="true" type="string">
        <cfargument name="strStreet" required="true" type="string">
        <cfargument name="intPincode" required="true" type="integer">
        <cfargument name="strEmailID" required="true" type="string">
        <cfargument name="intPhoneNumber" required="true" type="string">
        <cfargument name="pictureFile" required="false" type="any">
        <cfargument name="hobbies" type="string" required="true">
<!---         <cfdump  var="#arguments.hobbies#"> --->
        <cfset var formattedDate = DateFormat(arguments.strBirthday, "dd-mm-yyyy")>
        <cfset local.hobbyList = listToArray(arguments.hobbies)>
<!---         <cfdump  var="#hobbyList[1]#" abort> --->
        <cfif arguments.personid eq 0>
            <cfset local.uploadPath = expandPath("../assets/uploads/")>
            <cffile action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique" filefield="pictureFile">
            <cfset local.image = cffile.serverFile>
        <cfelse>
            <cfquery name="getExistingImage" datasource="demo">
                SELECT image
                FROM person
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.image = getExistingImage.image>
        </cfif>
        <cfif IsNumeric(arguments.personid) and arguments.personid gt 0>
            <cfquery name="editPageQuery" datasource="demo">
                UPDATE person
                SET
                title = <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                Fname = <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                Lname = <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                gender = <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                dob = <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_varchar">,
                address = <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,                
                street = <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                pincode = <cfqueryparam value="#arguments.intPincode#" cfsqltype="cf_sql_integer">,                
                emailID = <cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar">,
                phone = <cfqueryparam value="#arguments.intPhoneNumber#" cfsqltype="cf_sql_varchar">,
                image = <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">
                <!---hobbies=<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">--->
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="deleteData" datasource="demo">
                DELETE FROM hobbies
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer"> 
            </cfquery>
            <cfif arrayLen(local.hobbyList) GT 0>
                <cfloop from="1" to="#ArrayLen(local.hobbyList)#" index="i">
                    <cfquery name="addHobbies" datasource="demo">
                        INSERT INTO hobbies(personid,hobby)
                        VALUES (
                            <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#local.hobbyList[i]#" cfsqltype="cf_sql_varchar">
                        )
                    </cfquery>
                </cfloop>
            </cfif>
            <cfreturn {"success": true, "message": "UPDATED!!"}>
        <cfelseif (arguments.personid eq 0)>
            <cfquery name="addPageQuery" datasource="demo">
                INSERT INTO person(title, Fname, Lname, gender,dob, address, street, pincode, emailID, phone,image, userid)
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
                    <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    <!---<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">--->
                )
                    SELECT SCOPE_IDENTITY() AS personid
            </cfquery>
            <cfset local.personid = addPageQuery.personid>
            <cfloop from="1" to="#ArrayLen(local.hobbyList)#" index="i">
                <cfquery name="addHobbies" datasource="demo">
                    INSERT INTO hobbies(personid,hobby)
                    VALUES (
                        <cfqueryparam value="#local.personid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#local.hobbyList[i]#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
            </cfloop>


            <cfreturn {"success": true, "message": "Inserted!!"}>
        </cfif>
    </cffunction>--->

<!---<cffunction name="savePage" access="remote" returnformat="json">
        <cfargument name="personid" required="false" type="integer">
        <cfargument name="strTitle" required="true" type="string">
        <cfargument name="strFirstName" required="true" type="string">
        <cfargument name="strLastName" required="true" type="string">
        <cfargument name="strGender" required="true" type="string">
        <cfargument name="strBirthday" required="true" type="string">
        <cfargument name="strAddress" required="true" type="string">
        <cfargument name="strStreet" required="true" type="string">
        <cfargument name="intPincode" required="true" type="integer">
        <cfargument name="strEmailID" required="true" type="string">
        <cfargument name="intPhoneNumber" required="true" type="string">
        <cfargument name="pictureFile" required="false" type="any">
        <cfargument name="hobbies" type="string" required="true">
<!---         <cfdump  var="#arguments.hobbies#"> --->
       <cfset var formattedDate = DateFormat(arguments.strBirthday, "dd-mm-yyyy")>
        <cfset local.hobbyList = listToArray(arguments.hobbies)>
<!---     <cfdump var="#local.hobbyList#" label="Hobby List"> --->
 
        <cfif arguments.personid eq 0>
            <cfset local.uploadPath = expandPath("../assets/uploads/")>
            <cffile action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique" filefield="pictureFile">
            <cfset local.image = cffile.serverFile>
        <cfelse>
            <cfquery name="getExistingImage" datasource="demo">
                SELECT image
                FROM person
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.image = getExistingImage.image>
        </cfif>
        <cfif IsNumeric(arguments.personid) and arguments.personid gt 0>
            <cfquery name="editPageQuery" datasource="demo">
                UPDATE person
                SET
                title = <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                Fname = <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                Lname = <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                gender = <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                dob = <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_varchar">,
                address = <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,                
                street = <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                pincode = <cfqueryparam value="#arguments.intPincode#" cfsqltype="cf_sql_integer">,                
                emailID = <cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar">,
                phone = <cfqueryparam value="#arguments.intPhoneNumber#" cfsqltype="cf_sql_varchar">,
                image = <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">
                <!---hobbies=<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">--->
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset hobbiesname=[]>
            <cfloop array="#local.hobbyList#" index="hname">
                <cfquery name="getHobbyId" datasource="demo">
                    SELECT hid
                    FROM hobbyTable
                    WHERE hname = <cfqueryparam value="#hname#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfif getHobbyId.recordCount>
                    <cfset arrayAppend(hobbiesname, getHobbyId.hid)>
                </cfif>
            </cfloop>
            <cfloop array="#local.hobbyList#" index="hobbyID">
            <cfquery name="checkHobbyExistence" datasource="demo">
                SELECT COUNT(*)
                FROM hobbies
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
                AND hid = <cfqueryparam value="#hobbyID#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <cfif checkHobbyExistence.hobbyCount EQ 0>
                <cfquery name="addHobby" datasource="demo">
                    INSERT INTO hobbies (personid, hid)
                    VALUES (
                        <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#hobbyID#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
            </cfif>
        </cfloop>

            <cfreturn {"success": true, "message": "UPDATED!!"}>
        <cfelseif (arguments.personid eq 0)>
            <cfquery name="addPageQuery" datasource="demo">
                INSERT INTO person(title, Fname, Lname, gender,dob, address, street, pincode, emailID, phone,image, userid)
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
                    <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    <!---<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">--->
                )
                    SELECT SCOPE_IDENTITY() AS personid
            </cfquery>
            <cfset local.personid = addPageQuery.personid>
            <cfloop array="#local.hobbyList#" index="hobbyName">
            <cfquery name="getHobbyID" datasource="demo">
                SELECT hid
                FROM hobbyTable
                WHERE hname = <cfqueryparam value="#hobbyName#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif getHobbyID.recordCount>
                <cfquery datasource="demo">
                    INSERT INTO person_hobbies (personid, hid)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.personid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#getHobbyID.hid#">
                    )
                </cfquery>
            </cfif>
        </cfloop>
<cfabort>
            <cfreturn {"success": true, "message": "Inserted!!"}>
        </cfif>
    </cffunction>--->

    <cffunction name="savePage" access="remote" returnformat="json">
    <cfargument name="personid" required="false" type="integer">
    <cfargument name="strTitle" required="true" type="string">
    <cfargument name="strFirstName" required="true" type="string">
    <cfargument name="strLastName" required="true" type="string">
    <cfargument name="strGender" required="true" type="string">
    <cfargument name="strBirthday" required="true" type="string">
    <cfargument name="strAddress" required="true" type="string">
    <cfargument name="strStreet" required="true" type="string">
    <cfargument name="intPincode" required="true" type="integer">
    <cfargument name="strEmailID" required="true" type="string">
    <cfargument name="intPhoneNumber" required="true" type="string">
    <cfargument name="pictureFile" required="false" type="any">
    <cfargument name="hobbies" type="string" required="true">

    <!--- Parse birthday to a date object for database insertion --->
    <cfset var formattedDate = DateFormat(arguments.strBirthday, "dd-mm-yyyy")>

    <!--- Convert hobbies string to array if not already --->
    <cfset var local.hobbyList = []>
    <cfif len(trim(arguments.hobbies))>
        <cfset local.hobbyList = listToArray(arguments.hobbies)>
    </cfif>

    <!--- Initialize image variable --->
    <cfif arguments.personid eq 0>
        <cfset local.uploadPath = expandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique" filefield="pictureFile">
        <cfset local.image = cffile.serverFile>
    <cfelse>
        <cfquery name="getExistingImage" datasource="demo">
            SELECT image
            FROM person
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset local.image = getExistingImage.image>
    </cfif>

    <!--- Update or insert data into person table --->
    <cfif IsNumeric(arguments.personid) and arguments.personid gt 0>
        <cfquery name="editPageQuery" datasource="demo">
            UPDATE person
            SET
            title = <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
            Fname = <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
            Lname = <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
            gender = <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
            dob = <cfqueryparam value="#formattedDate#" cfsqltype="cf_sql_date">,
            address = <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,
            street = <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
            pincode = <cfqueryparam value="#arguments.intPincode#" cfsqltype="cf_sql_integer">,
            emailID = <cfqueryparam value="#arguments.strEmailID#" cfsqltype="cf_sql_varchar">,
            phone = <cfqueryparam value="#arguments.intPhoneNumber#" cfsqltype="cf_sql_varchar">,
            image = <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>

  
<cftransaction>
    <!-- Step 1: Identify Existing Hobbies -->
    <cfquery name="getExistingHobbies" datasource="demo">
        SELECT hid
        FROM person_hobbies
        WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Step 2: Identify New Hobbies -->
    <cfquery name="getNewHobbies" datasource="demo">
        SELECT h.hid
        FROM hobbyTable h
        LEFT JOIN person_hobbies ph ON h.hid = ph.hid AND ph.personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        WHERE ph.hid IS NULL
        AND h.hname IN (<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar" list="true">)
    </cfquery>

    <!-- Step 3: Delete Existing Duplicates -->
    <cfquery name="deleteDuplicates" datasource="demo">
        WITH Duplicates AS (
            SELECT id, personid, hid,
                ROW_NUMBER() OVER(PARTITION BY personid, hid ORDER BY id) AS RowNum
            FROM person_hobbies
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        )
        DELETE FROM Duplicates
        WHERE RowNum > 1;
    </cfquery>

    <!-- Step 4: Add New Hobbies -->
    <cfquery name="addNewHobbies" datasource="demo">
        INSERT INTO person_hobbies (personid, hid)
        SELECT <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer"> AS personid, h.hid
        FROM hobbyTable h
        LEFT JOIN person_hobbies ph ON h.hid = ph.hid AND ph.personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        WHERE ph.hid IS NULL
        AND h.hname IN (<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar" list="true">);
    </cfquery>
</cftransaction>
<cfreturn {"success": true, "message": "UPDATED!!"}>
        <cfelseif (arguments.personid eq 0)>
            <cfquery name="addPageQuery" datasource="demo">
                INSERT INTO person(title, Fname, Lname, gender,dob, address, street, pincode, emailID, phone,image, userid)
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
                    <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    <!---<cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">--->
                )
                    SELECT SCOPE_IDENTITY() AS personid
            </cfquery>
            <cfset local.personid = addPageQuery.personid>
            <cfloop array="#local.hobbyList#" index="hobbyName">
            <cfquery name="getHobbyID" datasource="demo">
                SELECT hid
                FROM hobbyTable
                WHERE hname = <cfqueryparam value="#hobbyName#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif getHobbyID.recordCount>
                <cfquery datasource="demo">
                    INSERT INTO person_hobbies (personid, hid)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.personid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#getHobbyID.hid#">
                    )
                </cfquery>
            </cfif>
        </cfloop>
            <cfreturn {"success": true, "message": "Inserted!!"}>
        </cfif>



 
</cffunction>

    <cffunction name="excelRead" access="remote" returnformat="json">
        <cfargument name="excelFile" required="true" type="any">
        <cfset local.path = ExpandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.path#" nameconflict='makeunique'>
        <cfset local.uploadFile = cffile.serverDirectory & "/" & cffile.serverFile>
        <cfspreadsheet action="read" src="#local.uploadFile#" query="excelData" headerrow="1" rows='2-100'>
        <cfset local.columnNames = []>
        <cfloop list="#excelData.ColumnList#" index="columnName">
            <cfset arrayAppend(local.columnNames, columnName)>
        </cfloop>
        <cfset local.arrayCount = arrayLen(local.columnNames)>
        <cfset ArraySort(local.columnNames, "text")>
        <cfquery name="getResult" datasource="demo">
            SELECT column_name
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'person'
            AND column_name NOT IN ('personid', 'userid')
        </cfquery>
        <cfset local.recordCount = getResult.RecordCount>
        <!---<cfif local.arrayCount NEQ local.recordCount>
            <cfreturn {"success": false, "message": "cannot add excel data"}>
        </cfif>--->
        <cfset local.insertedCount = 0>
        <cfset local.skippedCount = 0>
            <cfloop query="excelData">
                <cfset local.title = excelData.title>
                <cfset local.firstName = excelData.Fname>
                <cfset local.lastName = excelData.Lname>
                <cfset local.gender = excelData.gender>
                <cfset local.dob = excelData.dob>
                <cfset local.address = excelData.address>
                <cfset local.street = excelData.street>
                <cfset local.pincode = excelData.pincode>
                <cfset local.emailID = excelData.emailID>
                <cfset local.phone = excelData.phone>
                <cfset local.image = excelData.image>
                 <cfset local.hobbies = excelData.hobbies> 
                <cfset local.emailExistQuery = isEmailExist(local.emailID)>
                <cfif local.emailExistQuery.recordCount eq 0>
                <cfquery name="result" datasource="demo">
                    INSERT INTO person (title, Fname, Lname, gender, dob, address, street, pincode, emailID, phone, userid,image)
                    VALUES (
                        <cfqueryparam value="#local.title#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.firstName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.lastName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.gender#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.dob#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.address#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.street#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.pincode#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#local.emailID#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.phone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">
                    )
                        SELECT SCOPE_IDENTITY() AS personid
                    </cfquery>
            <cfset local.personID = result.personid>
            <cfif len(trim(local.hobbies)) GT 0>
                <cfset local.hobbyList = listToArray(local.hobbies, ",")>
                <cfloop array="#local.hobbyList#" index="hobby">
                    <cfquery datasource="demo">
                        INSERT INTO hobbies (personid, hobby)
                        VALUES (
                            <cfqueryparam value="#local.personID#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#trim(hobby)#" cfsqltype="cf_sql_varchar">
                        )
                    </cfquery>
                </cfloop>
            </cfif>
            
            <cfset local.insertedCount++>
        <cfelse>
            <cfset local.skippedCount++>
            <cfcontinue>
        </cfif>
    </cfloop>
    
    <cfreturn {"success": true, "message": "#local.insertedCount# rows inserted, #local.skippedCount# rows skipped due to duplicate emails."}>
</cffunction>

    <cffunction name="googleLogin" access="remote" returnType="query">
        <cfargument name="emailID" required="true" type="string">
        <cfquery name="googleLogin" datasource="demo">
            select userid,fullname,emailID,username,password,image 
            from usertable
            where emailID=<cfqueryparam value="#arguments.emailID#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn googleLogin>
    </cffunction>

    <cffunction  name="saveSSO" access="remote"  returnformat="json">
        <cfargument name = "emailID" required="true" returnType="string">
        <cfargument name = "name" required="true" returnType="string">
        <cfargument name = "image" required="true" returnType="string">
        <cfquery name="saveSSO" datasource="demo">
            INSERT INTO usertable (fullname,emailID,image)
            values(
                <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.emailID#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.image#" cfsqltype="cf_sql_varchar">
            ) 
        </cfquery>
        <cfreturn {"success":true}>
    </cffunction>
</cfcomponent>
