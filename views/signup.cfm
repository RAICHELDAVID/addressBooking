<cfinclude  template="header.cfm">
<cfinclude  template="Loginnavigation.cfm">
<div class="d-flex justify-content-center align-items-center loginMainContainer">
    <div class="loginCenter">
        <div class="leftContent">
            <img src="../assets/images/logo.png" alt="Image" width="100" height="100">
        </div>
        <div class="rightContent">
            <span>SIGN UP</span>
            <form action="signup.cfm" method="post">
                <input type="text" name="strName" id="strName" placeholder="Full Name"><br><br>
                <input type="email" name="strEmail" id="strEmail" placeholder="Email ID"><br><br>
                <input type="text" name="strUsername" id="strUsername" placeholder="Username"><br><br>
                <input type="password" name="strPassword" id="strPassword" placeholder="Password"><br><br>
                <input type="password" name="strConfirmPassword" id="strConfirmPassword" placeholder="Confirm Password"><br><br>
				<input type="file" name="adminPictureFile" id="adminPictureFile"><br><br>                   
                <button type="submit" name="signup" id="signupBtn">REGISTER</button>
                <p id="message" class="pt-2 text-center"> </p>
            </form>
        </div>
    </div> 
</div>
</body>
</html>