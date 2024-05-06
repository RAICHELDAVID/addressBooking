<!---<cfinclude  template="header.cfm">
<cfinclude  template="Loginnavigation.cfm">
<div class="d-flex loginDiv">
    <div class="d-flex">
        <div class="formLeft"> 
            <img src="./assets/images/logo.png" alt="Image" width="100" height="100">
        </div>
        <div class="">
            <span>LOGIN</span>
            <form action="index.cfm?action=login" method="post">
                <input type="text" name="strUsername" placeholder="Username">
                <input type="password" name="strPassword" placeholder="Password">
                
            </form>
        </div>
    </div>
</div>

--->


<cfinclude template="header.cfm">
<cfinclude template="Loginnavigation.cfm">
<div class="d-flex justify-content-center align-items-center loginMainContainer">
    <div class="loginCenter">
        <div class="leftContent">
            <img src="./assets/images/logo.png" alt="Image" width="100" height="100">
        </div>
        <div class="rightContent">
            <span>LOGIN</span>
            <form action="index.cfm?action=login" method="post">
                <input type="text" name="strUsername" placeholder="Username"><br><br>
                <input type="password" name="strPassword" placeholder="Password"><br><br>
                <button type="submit" name="login" id="loginBtn">LOGIN</button>
                <p id="successMsg" style="color:green;" class="pt-2"> </p>
                <p id="errorMsg" style="color:red;"> </p>
            </form>
            <span id="signuptext">Or Sign In Using</span><br>
            <div class="iconDiv">
                <a href=""><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="40px" height="40px"><path fill="#224787" d="M512 256C512 114.6 397.4 0 256 0S0 114.6 0 256C0 376 82.7 476.8 194.2 504.5V334.2H141.4V256h52.8V222.3c0-87.1 39.4-127.5 125-127.5c16.2 0 44.2 3.2 55.7 6.4V172c-6-.6-16.5-1-29.6-1c-42 0-58.2 15.9-58.2 57.2V256h83.6l-14.4 78.2H287V510.1C413.8 494.8 512 386.9 512 256h0z"/>
                </svg></a>
                <a href=""><img src="./assets/images/googleicon.JPG" alt="Logo" width="45" height="45" class="d-inline-block align-text-top logoImage"></a>
            </div>
            <div class="registerDiv">
                <span>Don't have an account?<a href="">Register Here</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
