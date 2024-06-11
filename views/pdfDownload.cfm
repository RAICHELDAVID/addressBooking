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
                        <th>Email</th>
                        <th>Phone number</th>
                    </tr>
                </thead>
                <tbody>
                    <cfset persons = EntityLoad("person")>
                    <cfloop array="#persons#" index="person">
                        <cfif session.userid eq person.getuserid()>
                            <tr>
                                <td><img src="../assets/uploads/#person.getimage()#" alt="image" width="50" height="50"></td>
                                <td>#person.getFname()# #person.getLname()#</td>
                                <td>#person.getemailID()#</td>
                                <td>#person.getphone()#</td>
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
