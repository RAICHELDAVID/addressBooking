<cfscript>
    cfparam(name="url.action", default="", pattern="");

    switch(lcase(url.action)){
        case "login":
            include "/views/header.cfm";
            include "/views/Loginnavigation.cfm";
            include "/views/login.cfm";
            break;

        case "signup":
            include "/views/header.cfm";
            include "/views/Loginnavigation.cfm";
            include "/views/signup.cfm";
            break;

        case "listPage":
            include "/views/header.cfm";
            include "/views/homeNavigation.cfm";
            include "/views/listPage.cfm";
            break;

        case "pdf":
            include "/views/pdfDownload.cfm";
            break;

        case "excel":
            include "/views/excelDownload.cfm";
            break;

        case "error404":
            include "/views/header.cfm";
            include "/views/error404.cfm";
            break;

        default:
            include "/views/header.cfm";
            include "/views/error404.cfm";
            break;
    }

</cfscript>
