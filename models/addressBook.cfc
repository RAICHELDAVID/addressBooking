<cfcomponent>
    <cffunction name="doLoginAuthenticate" access="public" returntype="query">
        <cfargument name="strEmail" type="string" required="true">
        <cfargument name="strPassword" type="string" required="true">
        <cfset var hashValue = hash(arguments.strPassword)>
        <cfquery name="getUser">
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
        <cfquery name="getUser">
            SELECT username,emailID FROM usertable
            WHERE username=<cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">
            OR emailID=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn getUser>
    </cffunction>

    <cffunction  name="selectData"  access="remote" returnformat="json">
        <cfargument name="personid" required="true" type="integer">
        <cfquery name="selectData">
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
        <cfset responseData["hobbies"] = []>
        <cfquery name="local.getHobbyNames">
            SELECT ht.hname
            FROM person_hobbies ph
            INNER JOIN hobbyTable ht ON ph.hid = ht.hid
            WHERE ph.personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfloop query="local.getHobbyNames">
            <cfset arrayAppend(responseData["hobbies"], getHobbyNames.hname)>
        </cfloop>
        <cfreturn responseData>
    </cffunction>

    <cffunction  name="isEmailExist" returntype="query">
        <cfargument  name="strEmailID" required="true" type="string">
        <cfquery name="getEmail">
            SELECT 1 FROM person
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
        <cfquery name="addToTable">
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
        <cfquery name="displayDataQuery">
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
        <cfquery name="deleteData">
            DELETE FROM person_hobbies
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            DELETE FROM person
            WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"message":true}>
    </cffunction>

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
        <cfset var formattedDate = DateFormat(arguments.strBirthday, "dd-mm-yyyy")>
        <cfset var local.hobbyList = "">
        <cfif len(trim(arguments.hobbies))>
            <cfset local.hobbyList = arguments.hobbies>
        </cfif>
        <cfif arguments.personid eq 0>
            <cfset local.uploadPath = expandPath("../assets/uploads/")>
            <cffile action="upload" destination="#local.uploadPath#" nameConflict="MakeUnique" filefield="pictureFile">
            <cfset local.image = cffile.serverFile>
        <cfelse>
            <cfquery name="getExistingImage">
                SELECT image
                FROM person
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.image = getExistingImage.image>
        </cfif>
        <cfif IsNumeric(arguments.personid) and arguments.personid gt 0>
            <cfquery name="editPageQuery">
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

            <cfquery name="local.getExistingHobbies">
                SELECT hid
                FROM person_hobbies 
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.existingHobbiesList = ValueList(local.getExistingHobbies.hid)>
            <cfloop list="#local.hobbyList#" index="hobby">
                <cfif not listFind(local.existingHobbiesList, hobby)>
                    <cfquery>
                        INSERT INTO person_hobbies (personid, hid)
                        VALUES (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.personid#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#hobby#">
                        )
                    </cfquery>
                </cfif>
            </cfloop>

            <cfquery name="deleteHobbies">
                DELETE FROM person_hobbies
                WHERE personid = <cfqueryparam value="#arguments.personid#" cfsqltype="cf_sql_integer">
                AND hid NOT IN (
                    <cfqueryparam value="#local.hobbyList#" cfsqltype="cf_sql_integer" list="true">
                )
            </cfquery>
            <cfreturn {"success": true, "message": "UPDATED!!"}>
        <cfelseif (arguments.personid eq 0)>
            <cfquery name="addPageQuery">
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
                )
                    SELECT SCOPE_IDENTITY() AS personid
            </cfquery>
            <cfset local.personid = addPageQuery.personid>
            <cfloop list="#local.hobbyList#" index="hobby">
                <cfquery>
                    INSERT INTO person_hobbies (personid, hid)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.personid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#hobby#">
                    )
                </cfquery>
            </cfloop>
            <cfreturn {"success": true, "message": "Inserted!!"}>
        </cfif>
    </cffunction>
    
    <cffunction name="getHobbies" access="remote" returnformat="json">
        <cfset var result = []> 
        <cfquery name="local.hobbies" datasource="demo">
            SELECT hid, hname
            FROM hobbyTable
            ORDER BY hname
        </cfquery>
        <cfloop query="local.hobbies">
            <cfset hobby = {
                "hid": local.hobbies.hid,
                "hname": local.hobbies.hname
            }>
            <cfset arrayAppend(result, hobby)>
        </cfloop>
        <cfreturn serializeJSON(result)>
    </cffunction>

    <cffunction name="excelRead" access="remote" returnformat="json">
        <cfargument name="excelFile" required="true" type="any">
        <cfset local.path = ExpandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.path#" nameconflict='makeunique'>
        <cfset session.uploadedFilePath = cffile.serverDirectory & "/" & cffile.serverFile>
        <cfspreadsheet action="read" src="#session.uploadedFilePath#" query="excelData" headerrow="1" rows="2-100">
        <cfset local.result = []>
        <cfset local.hobbyValidation = []>
        <cfquery name="deleteExistingExcelPerson">
            DELETE FROM excelPerson
            WHERE userid=<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset local.excelHeaders = excelData.getColumnNames()>
        <cfloop query="excelData">
            <cfif not len(trim(excelData.title))>
                <cfset arrayAppend(local.result, local.excelHeaders[1] &" missing")>
            </cfif>
            <cfif not len(trim(excelData.Fname))>
                <cfset arrayAppend(local.result, local.excelHeaders[2] &" missing")>
            </cfif>
            <cfif not len(trim(excelData.Lname))>
                <cfset arrayAppend(local.result, local.excelHeaders[3] &" missing")>
            </cfif>
            <cfif not len(trim(excelData.gender))>
                <cfset arrayAppend(local.result, local.excelHeaders[4] &" missing")>
            </cfif>
            <cfif not len(excelData.dob)>
                <cfset arrayAppend(local.result, local.excelHeaders[5] &" missing")>
            </cfif>
            <cfif not len(trim(excelData.address))>
                <cfset arrayAppend(local.result, local.excelHeaders[6] &" missing")>
            </cfif>
            <cfif not len(trim(excelData.street))>
                <cfset arrayAppend(local.result, local.excelHeaders[7] &" missing")>
            </cfif>
            <cfif not len(excelData.pincode)>
                <cfset arrayAppend(local.result, local.excelHeaders[8] &" missing")>
            </cfif>
            <cfif not len(excelData.phone)>
                <cfset arrayAppend(local.result, local.excelHeaders[10] &" missing")>
            </cfif>
            <cfif not len(excelData.image)>
                <cfset arrayAppend(local.result, local.excelHeaders[11] &" missing")>
            </cfif>
            <cfif not len(excelData.hobbies)>
                <cfset arrayAppend(local.result, local.excelHeaders[12] & " missing")>
            <cfelse>
                <cfloop list="#excelData.hobbies#" index="hobby">
                    <cfquery name="local.hobbyInDatabase">
                        SELECT hname
                        FROM hobbyTable
                        WHERE hname = <cfqueryparam value="#hobby#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    <cfif local.hobbyInDatabase.recordCount eq 0>
                        <cfset arrayAppend(local.hobbyValidation, "cannot add Hobby '#hobby#'")>
                    </cfif>
                </cfloop>
            </cfif>
            <cfset var local.formattedDate = DateFormat(excelData.dob, "dd-mm-yyyy")>
            <cfif not len(excelData.emailID)>
                <cfset arrayAppend(local.result, local.excelHeaders[9] &" missing")>
            <cfelse>
                <cfquery name="local.getEmail">
                    SELECT personid FROM person
                    WHERE emailID=<cfqueryparam value="#excelData.emailID#" cfsqltype="cf_sql_varchar">
                </cfquery> 
                <cfif local.getEmail.recordCount gt 0 && arrayIsEmpty(local.result)>
                    <cfquery name="editPageQuery">
                        UPDATE person
                        SET
                        title = <cfqueryparam value="#excelData.title#" cfsqltype="cf_sql_varchar">,
                        Fname = <cfqueryparam value="#excelData.Fname#" cfsqltype="cf_sql_varchar">,
                        Lname = <cfqueryparam value="#excelData.Lname#" cfsqltype="cf_sql_varchar">,
                        gender = <cfqueryparam value="#excelData.gender#" cfsqltype="cf_sql_varchar">,
                        dob = <cfqueryparam value="#local.formattedDate#" cfsqltype="cf_sql_date">,
                        address = <cfqueryparam value="#excelData.address#" cfsqltype="cf_sql_varchar">,
                        street = <cfqueryparam value="#excelData.street#" cfsqltype="cf_sql_varchar">,
                        pincode = <cfqueryparam value="#excelData.pincode#" cfsqltype="cf_sql_integer">,
                        emailID = <cfqueryparam value="#excelData.emailID#" cfsqltype="cf_sql_varchar">,
                        phone = <cfqueryparam value="#excelData.phone#" cfsqltype="cf_sql_varchar">,
                        image = <cfqueryparam value="#excelData.image#" cfsqltype="cf_sql_varchar">
                        WHERE personid = <cfqueryparam value="#local.getEmail.personid#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset arrayAppend(local.result,"updated")>
                </cfif>
                
            </cfif>
            <cfif arrayIsEmpty(local.result)>
                <cfquery name="local.person">
                    INSERT INTO person (title, Fname, Lname, gender, dob, address, street, pincode, emailID, phone, userid, image)
                    VALUES (
                        <cfqueryparam value="#excelData.title#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.Fname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.Lname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.gender#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.dob#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.address#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.street#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.pincode#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#excelData.emailID#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.phone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#excelData.image#" cfsqltype="cf_sql_varchar">
                    )
                        SELECT SCOPE_IDENTITY() AS personid
                </cfquery>
                    <cfset local.personID = local.person.personid>
                    <cfset local.hobbyList = listToArray(excelData.hobbies, ",")>
                    <cfloop array="#local.hobbyList#" index="hobby">
                        <cfquery  name="getHid">
                            SELECT hid
                            FROM hobbytable
                            WHERE hname = <cfqueryparam value="#trim(hobby)#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfif getHid.recordCount>
                            <cfquery >
                                INSERT INTO person_hobbies (personid, hid)
                                VALUES (
                                    <cfqueryparam value="#local.personID#" cfsqltype="cf_sql_integer">,
                                    <cfqueryparam value="#getHid.hid#" cfsqltype="cf_sql_integer">
                                )
                            </cfquery>
                        </cfif>
                    </cfloop>
                    <cfset arrayAppend(local.result,"added")>
            </cfif>
            <cfif !arrayIsEmpty(local.result)>
               <cfloop array="#local.hobbyValidation#" index="item">
                    <cfset arrayAppend(local.result, item)>
                </cfloop>
                <cfquery name="insertValidationData">
                    INSERT INTO excelPerson (title, Fname, Lname, gender, dob, address, street, pincode, emailID, phone, image,hobbies, ValidationResult,userid)
                    VALUES (
                        <cfqueryparam value="#excelData.title#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.Fname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.Lname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.gender#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.dob#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.address#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.street#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.pincode#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#excelData.emailID#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.phone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.image#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#excelData.hobbies#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arrayToList(local.result)#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
                <cfset arrayClear(local.result)>
                <cfset arrayClear(local.hobbyValidation)>
            </cfif>
        </cfloop>
        <cfreturn {"success": true}>
    </cffunction>
    <cffunction name="googleLogin" access="remote" returnType="query">
        <cfargument name="emailID" required="true" type="string">
        <cfquery name="googleLogin" >
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
        <cfquery name="saveSSO" >
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
