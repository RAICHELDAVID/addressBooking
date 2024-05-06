<cfcomponent>
    <cffunction name="doLoginAuthenticate" access="remote" returntype="query">
        <cfargument name="strUsername" type="string" required="true">
        <cfargument name="strPassword" type="string" required="true">
        <!---<cfset var hashValue = hash(arguments.strPassword)>--->
        
        <cfquery name="getUser" datasource="demo">
            SELECT username, password
            FROM usertable
            WHERE username = <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">
            AND password = <cfqueryparam value="#hashValue#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn getUser>
    </cffunction>
</cfcomponent>