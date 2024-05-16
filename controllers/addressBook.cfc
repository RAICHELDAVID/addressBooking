component{
    remote function doLogin(strEmail, strPassword) returnFormat="json" {
        var local.userLogin = createObject("component", "models.addressBook").doLoginAuthenticate(strEmail, strPassword);
        
        if (local.userLogin.recordCount eq 1) {
            session.userid=local.userLogin.userid;
            session.fullname = local.userLogin.fullname;
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
    remote function savePageValidation(strFirstName, strLastName,intPincode,strEmailID,intPhoneNumber) returnFormat="json" {
        var local.regexPName='^[A-Za-z]+$';
        var local.regexPin='^\d{6}$';
        var local.regexPhone='^\d{10}$';
        var regexEmail = '\w+@\w+\.\w{2,}';

        var local.errors = [];
            if (!reFind(local.regexPName, strFirstName)) {
                arrayAppend(local.errors, "First Name should contain only alphabets.");
            }
            if (!reFind(local.regexPName, strLastName)) {
                arrayAppend(local.errors, "Last Name should contain only alphabets.");
            }

            if (!reFind(local.regexPin, intPincode)) {
                arrayAppend(local.errors, "pincode should be of 6 digits");
            }
            if (!reFind(local.regexPhone, intPhoneNumber)) {
                arrayAppend(local.errors, "phone number contain only 10 digits");
            }
            if (!reFind(regexEmail, strEmailID)) {
                arrayAppend(local.errors, "email id is in the format abc@abc.com");
            }
            else if(personid<=0){
                var variables.result = createObject("component", "models.addressBook").isEmailExist(strEmailID);
                if (variables.result.recordCount > 0) {
                        if (variables.result.emailID == strEmailID) {
                            arrayAppend(local.errors, "Emailid already exists.");
                        }
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
    remote struct function verify(required string token) {
    var result = { success = false, message = "" };
    var googleClientId = "678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com";
    var googleApiUrl = "https://oauth2.googleapis.com/tokeninfo?id_token=" & token;
    var httpResponse = {};

    httpResponse = http method="get" url=googleApiUrl;

    if (httpResponse.statusCode == 200) {
      var response = deserializeJSON(httpResponse.fileContent);
      
      if (response.aud == googleClientId) {
        result.success = true;
        result.message = "Login successful";
        
        
      } else {
        result.message = "Invalid token audience";
      }
    } else {
      result.message = "Token verification failed";
    }
    writeDump(result);
    
    return result;
  }

}
  