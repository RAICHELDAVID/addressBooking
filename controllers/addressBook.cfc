component{
    remote function doLogin(strUsername, strPassword) returnFormat="json" {
        var userLogin = createObject("component", "models.addressBook").doLoginAuthenticate(strUsername, strPassword);
        
        if (userLogin.recordCount eq 1) {
            session.fullname = userLogin.fullname;
            return { "message": true };
        } else {
            return { "message": false };
        }
    }

    remote function validateSignUp(strName,strEmail,strUsername,strPassword,strConfirmPassword) returnformat="json"{
        var local.errors = [];
        var regexName = "^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$" 
        var regexEmail = '\w+@\w+\.\w{2,}';
        var regexPassword = '^[a-zA-Z]+[\W_][0-9]+$';

        if (len(trim(strName)) == 0 or len(trim(strEmail)) == 0 or len(trim(strUsername)) == 0 or len(trim(strPassword)) == 0 or len(trim(strConfirmPassword)) == 0) {
            arrayAppend(local.errors, "All fields are required.");
        } else {
            if (!reFind(regexName, strName)) {
                arrayAppend(local.errors, "Name should contain only alphabets.");
            }
            if (!reFind(regexEmail, strEmail)) {
                arrayAppend(local.errors, "email id is in the format abc@abc.com");
            }
            if (!reFind(regexName, strUsername)) {
                arrayAppend(local.errors, "Username should contain only alphabets.");
            } else {
                var variables.result = createObject("component", "models.addressBook").isUserExist(strUsername, strEmail);
                if (variables.result.recordCount > 0) {
                    for (var i = 1; i <= variables.result.recordCount; i++) {
                        if (variables.result.username[i] == strUsername) {
                            arrayAppend(local.errors, "Username already exists.");
                        }
                        if (variables.result.emailID[i] == strEmail) {
                            arrayAppend(local.errors, "Email already exists.");
                        }   
                    }
                }
            }

            if (!reFind(regexPassword, strPassword)) {
                arrayAppend(local.errors, "Password should contain at least one letter,one special character and one digit.");
            }

            if (strConfirmPassword != strPassword){
                arrayAppend(local.errors, "Password is not matching.");
            }
        }

        if (arrayLen(local.errors) > 0) {
            return {
                "success": false,
                "message": local.errors
            };
        } else {
            return {
                "success": true,
                "message": "Successful registration!"
            };
        }
    }

    remote void function logout(){
        structDelete(session,"login");
        session.login=false;
        cflocation(url="?action=login");
    }

}  
  