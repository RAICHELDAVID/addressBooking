<cfscript>
    cfparam(name="url.action", default="", pattern="");

    switch(lcase(url.action)){
        case "login":
            /*include "/controllers/readAction.cfm";*/
            include "/views/login.cfm";
            
        break;

        // The provided event could not be matched.
        default:
           // throw( type="InvalidEvent" );
           /* include "/controllers/readAction.cfm";*/
            include "/views/login.cfm";
            
        break;
    }
</cfscript>