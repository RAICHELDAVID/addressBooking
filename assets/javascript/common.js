$(document).ready(function() {
    $('#loginBtn').click(function(e) {
        e.preventDefault();
        $("#message").empty().css("color", "");
        
        var strUsername = $("#strUsername").val().trim();
        var strPassword = $("#strPassword").val().trim();
        
        if (strUsername === '' || strPassword === '') {
            $("#message").text('Username and password are required.').css("color", "red");
            return;
        }

        $.ajax({
            type: "POST",
            url: "./controllers/addressBook.cfc?method=doLogin",
            dataType: "json",
            data: {
                strUsername: strUsername,
                strPassword: strPassword
            },
            success: function(response) {
                if (response.message == true) {
                    $("#message").text('Login successful!').css("color", "green");
                    setTimeout(function() {
                        window.location.href = "?action=listPage";
                    }, 1000);
                } else {
                    $("#message").text('Invalid username or password!').css("color", "red");
                }
            },
            error: function(xhr, status, error) {
                $("#message").text('An error occurred. Please try again later.').css("color", "red");
            }
        });
    });
    $('#signupBtn').click(function(event) {
        event.preventDefault(); 
        var strName = $("#strName").val().trim();
        var strEmail =  $("#strEmail").val().trim();
        var strUsername = $("#strUsername").val().trim();
        var strPassword = $("#strPassword").val().trim();
        var strConfirmPassword=$("#strConfirmPassword").val().trim();
        $.ajax({
            type: 'post',
            url: 'controllers/addressBook.cfc?method=validateSignUp',
            data: {
                strName: strName,
                strEmail: strEmail,
                strUsername: strUsername,
                strPassword: strPassword,
                strConfirmPassword:strConfirmPassword
                 
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    saveUser(strName,strEmail,strUsername,strPassword,strConfirmPassword);
                } else {
                    $("#message").html(response.message.join('<br>')).css("color", "red");
                }
            },

        });
        saveUser=function(strName,strEmail,strUsername,strPassword,strConfirmPassword){
            $.ajax({
                type:'post',
                url:'models/addressBook.cfc?method=saveUser',
                data:{
                    strName: strName,
                    strEmail: strEmail,
                    strUsername: strUsername,
                    strPassword: strPassword,
                    strConfirmPassword:strConfirmPassword
                },
                dataType:'json',
                success:function(response){
                    if(response.success){
                        $("#message").text(response.message).css("color", "green");
                    }
                }
            })
    
        }
    });

});
