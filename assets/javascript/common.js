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
    $('#formID').submit(function(e) {
        e.preventDefault();
       var strTitle = $("#strTitle").val();
        var strFirstName = $("#strFirstName").val().trim();
        var strLastName = $("#strLastName").val().trim();
        var strGender = $("#strGender").val();
        var strBirthday = $("#strBirthday").val().trim();
        var strAddress = $("#strAddress").val().trim();
        var strStreet = $("#strStreet").val().trim();
       
        var intPincode = parseInt($("#intPincode").val().trim());
        var strEmailID = $("#strEmailID").val().trim();
        
        var intPhoneNumber = parseInt($("#intPhoneNumber").val().trim());
        if (strTitle === '' || strFirstName === '' || strLastName === '' || strGender === '' || strBirthday === '' || strAddress === '' || strStreet === '' || intPincode === ''|| strEmailID === '' || intPhoneNumber === '') {
            $("#validationMessage").text('All fields are required').css("color", "red");
            return false;
        }

        $.ajax({
            type: "POST",
            url: "./controllers/addressBook.cfc?method=savePageValidation",
            dataType: "json",
            data: {
                strFirstName: strFirstName,
                strLastName:strLastName,
                intPincode:intPincode,
                strEmailID:strEmailID,
                intPhoneNumber:intPhoneNumber
            },
            success: function(response) {
                if (response.success) {
                    savePage(strTitle,strFirstName,strLastName,strGender,strBirthday,strAddress,strStreet,intPincode,strEmailID,intPhoneNumber)

                } else {
                    $("#validationMessage").html(response.message.join('<br>')).css("color", "red");
                }
            },
        });
        return false;
    });
    function savePage(strTitle,strFirstName,strLastName,strGender,strBirthday,strAddress,strStreet,intPincode,strEmailID,intPhoneNumber) {
        $.ajax({
            type: 'POST',
            url: "models/addressBook.cfc?method=savePage",
            dataType: "json",
            data: {
                strTitle:strTitle,
                strFirstName: strFirstName,
                strLastName:strLastName,
                strGender:strGender,
                strBirthday:strBirthday,
                strAddress:strAddress,
                strStreet:strStreet,
                intPincode:intPincode,
                strEmailID:strEmailID,
                intPhoneNumber:intPhoneNumber
            },
            success: function(response) {
                if (response.success) {
                    $('#validationMessage').text(response.message).css("color", "green");
                    setTimeout(function() {
                        window.location.href ="?action=listPage";
                    }, 1000);
                } else {
                    $('#validationMessage').text(response.message).css("color", "red");
                }
            },
            error: function(xhr, status, error) {
                console.log(xhr.responseText);
                alert("An error occurred while saving the page.");
            }
        });
    }

$('.editModalBtn').submit(function() {
  
    var personid = $(this).attr('personid');
    $('#personid').val(personid);
    
});



});
