component{
    remote  function doLogin(strUsername,strPassword) returnFormat="JSON" {
        var userLogin = createObject("component","models.addressBook").doLoginAuthenticate(strUsername,strPassword)

        if (userLogin.recordCount eq 1) {
          
            return { "message": true };
        } else {
            return { "message": false };
        }
    }
}  
  
