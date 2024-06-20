<cfcontent type="application/pdf">
<cfheader name="Content-Disposition" value="attachment; filename=list_of_data.pdf">
<cfdocument format="PDF">
    <html>
    <head>
        <title>List of Data</title>
    </head>
    <body>
        <h1>List of Data</h1>
        <cfoutput>
            <table>
                <thead>
                    <tr>
                        <th></th>
                        <th>Name</th>
                        <th>Gender</th>
                        <th>Address</th>
                        <th>Email</th>
                        <th>Phone number</th>
                        <th>Hobbies</th>
                    </tr>
                </thead>
                <tbody>
                    <cfset persons = EntityLoad("person")>
                    <cfloop array="#persons#" index="person">
                        <cfif session.userid eq person.getuserid()>
                            <tr>
                                <td><img src="../assets/uploads/#person.getimage()#" alt="image" width="50" height="50"></td>
                                <td style="padding:10px;">#person.getFname()# #person.getLname()#</td>
                                <td style="padding:10px;">#person.getgender()#</td>
                                <td>#person.getaddress()#,#person.getstreet()#,#person.getpincode()#</td>
                                <td>#person.getemailID()#</td>
                                <td>#person.getphone()#</td>
                                <td>
                                    <cfset hobbies = EntityLoad("hobbies", { person = person})>
                                    <cfif arrayLen(hobbies)>
                                        <cfloop array="#hobbies#" index="hobbies">
                                            #hobbies.gethobby()#,
                                        </cfloop>
                                    </cfif>
                               </td>    
                            </tr>
                        <cfelse>
                            <cfcontinue>	
                        </cfif>
                    </cfloop>
                </tbody>
            </table>
        </cfoutput>
    </body>
    </html>
</cfdocument>
