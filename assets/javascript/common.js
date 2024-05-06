$(document).ready(function() {
    $('#loginBtn').click(function(e) {
        e.preventDefault();
        var strUsername = $("#strUsername").val();
        var strPassword = $("#strPassword").val();

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
                    $("#successMsg").text('Login successful!');
                    setTimeout(function() {
                        window.location.href = "../views/homePage.cfm";
                    }, 1000);
                } else {
                    $("#errorMsg").text('Invalid username or password!');
                }
            },
        });
    });
    return false;
});