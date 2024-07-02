
$(document).ready(function () {
   $('#loginBtn').click(function (e) {
      e.preventDefault();
      $("#message").empty().css("color", "");

      var strEmail = $("#strEmail").val().trim();
      var strPassword = $("#strPassword").val().trim();

      if (strEmail === '' || strPassword === '') {
         $("#message").text('Username and password are required.').css("color", "red");
         return;
      }

      $.ajax({
         type: "POST",
         url: "./controllers/addressBook.cfc?method=doLogin",
         dataType: "json",
         data: {
            strEmail: strEmail,
            strPassword: strPassword
         },
         success: function (response) {
            if (response.message == true) {
               $("#message").text('Login successful!').css("color", "green");
               setTimeout(function () {
                  window.location.href = "?action=listPage";
               }, 1000);
            } else {
               $("#message").text('Invalid username or password!').css("color", "red");
            }
         },
         error: function (xhr, status, error) {
            $("#message").text('An error occurred. Please try again later.').css("color", "red");
         }
      });
   });
   $('#signupBtn').click(function (event) {
      event.preventDefault();
      var strName = $("#strName").val().trim();
      var strEmail = $("#strEmail").val().trim();
      var strUsername = $("#strUsername").val().trim();
      var strPassword = $("#strPassword").val().trim();
      var strConfirmPassword = $("#strConfirmPassword").val().trim();
      var formData = new FormData();
      formData.append('strName',strName);
      formData.append('strEmail',strEmail);
      formData.append('strUsername',strUsername);
      formData.append('strPassword',strPassword);
      formData.append('strConfirmPassword',strConfirmPassword);
      formData.append('adminPictureFile', $('#adminPictureFile')[0].files[0]);
      $.ajax({
         type: 'post',
         url: 'controllers/addressBook.cfc?method=validateSignUp',
         data: formData,
         processData: false,
         contentType: false,
         dataType: "json",
         success: function (response) {
            if (response.success) {
               saveUser(formData);
            } else {
               $("#message").html(response.message.join('<br>')).css("color", "red");
            }
         },

      });
      saveUser = function (formData) {

         $.ajax({
            type: 'post',
            url: 'models/addressBook.cfc?method=saveUser',
            processData: false,
            contentType: false,
            dataType: "json",
            data: formData,
            success: function (response) {
               if (response.success) {
                  $("#message").text(response.message).css("color", "green");
                  $('#userImage').attr('src','./assets/uploads/'+response.image);
               }
            }
            
         })

      }
   });
   $('#formBtn').click(function (e) {
      e.preventDefault();
      var personid = $('#personid').val();
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

      if (strTitle === '' || strFirstName === '' || strLastName === '' || strGender === '' || strBirthday === '' || strAddress === '' || strStreet === '' || intPincode === '' || strEmailID === '' || intPhoneNumber === '') {
         $("#validationMessage").text('All fields are required').css("color", "red");
         return false;
      }
      var formData = new FormData();

      formData.append('personid', personid);
      formData.append('strTitle',  strTitle);
      formData.append('strFirstName',strFirstName);
      formData.append('strLastName',strLastName);      
      formData.append('strGender', strGender);
      formData.append('strBirthday', strBirthday);      
      formData.append('strAddress', strAddress);
      formData.append('strStreet', strStreet);      
      formData.append('intPincode', intPincode);
      formData.append('intPhoneNumber', intPhoneNumber);
      formData.append('strEmailID', strEmailID);
      formData.append('pictureFile', $('#pictureFile')[0].files[0]); 
      

      $.ajax({
         type: "POST",
         url: "./controllers/addressBook.cfc?method=savePageValidation",
         data: formData,
         processData: false,
         contentType: false,
         dataType: "json",
         success: function (response) {
            if (response.success==true) {
               savePage(formData);

            } else {
               $("#validationMessage").html(response.message.join('<br>')).css("color", "red");
            }
         },
      });

      return false;
   });

   function savePage(formData) {
      $.ajax({
         type: 'POST',
         url: "./models/addressBook.cfc?method=savePage",
         processData: false,
         contentType: false,
         dataType: "json",
         data: formData,
         success: function (response) {

            if (response.success == true) {

               $('#validationMessage').text(response.message).css("color", "green");
               setTimeout(function () {
                  window.location.href = "?action=listPage";
               }, 1000);
            } else {
               $('#validationMessage').text(response.message).css("color", "red");
            }
         },
         error: function (xhr, status, error) {
            console.log(xhr.responseText);
            alert("An error occurred while saving the page.");
         }
      });
   }
   $('.createBtn').click(function (e) {
      e.preventDefault();
      $("#formID").get(0).reset();
      $('#userImageEdit').attr('src', './assets/images/user.JPG'); 
      
  });
  

   $('.editModalBtn').click(function (e) {
      e.preventDefault();
      var personid = $(this).attr('personid');
      $.ajax({
         type: "POST",
         url: "./models/addressBook.cfc?method=selectData",
         data: {
            personid: personid
         },
         dataType: "json",
         success: function (response) {
            if (response) {
               $('#modalTitle').text('EDIT CONTACT')
               $('#personid').val(response.personid);
               $('#strTitle').val(response.title);
               $('#strFirstName').val(response.Fname);
               $('#strLastName').val(response.Lname);
               $('#strGender').val(response.gender);
               $('#strBirthday').val(response.dob);
               $('#strAddress').val(response.address);
               $('#strStreet').val(response.street);
               $('#intPincode').val(response.pincode);
               $('#strEmailID').val(response.emailID);
               $('#intPhoneNumber').val(response.phone);
               
               $('#userImageEdit').attr('src','./assets/uploads/'+response.image);
            }
         }
      });
   });
   
   $('.deleteLink').click(function (e) {
      e.preventDefault();
      var personid = $(this).attr('personid');
      if (confirm("click OK to delete this row?")) {
         $.ajax({
            type: "POST",
            url: "./models/addressBook.cfc?method=deleteData",
            data: {
               personid: personid
            },
            dataType: "json",
            success: function (response) {
               if (response) {
                  $(e.target).closest("tr").remove();
               }
            },

         });

      }
      return false;
   });
   $('.viewLink').click(function (e) {
      e.preventDefault();
      var personid = $(this).attr('personid');
      $.ajax({
          type: "POST",
          url: "./models/addressBook.cfc?method=displayData",
          data: {
              personid: personid
          },
          dataType: "json",
          success: function (response) {
              var imageUrl = './assets/uploads/' + response.DATA[0][7]; 
              $('#userImageView').attr('src', imageUrl);
              var tableHtml = "<table>";
              $.each(response.COLUMNS, function (index, columnName) {
               
                  tableHtml += "<tr>";
                  tableHtml += "<th>" + columnName + "</th>";
                  tableHtml += "<td>" + response.DATA[0][index] + "</td>";
                  tableHtml += "</tr>";
              });
              tableHtml += "</table>";
              $("#tableContainer").html(tableHtml);
          },
         error: function (xhr, textStatus, errorThrown) {
              console.error("Error:", errorThrown);
          }
      });
  });
   $('#print').click(function () {
      printContent('landscape');
   });

   function printContent(orientation) {
      var css = `
      @page {
          size: ${orientation};
      }
      .printNone {
        display: none;
    }
    .printable {
        display: block;

    }
    th,td{
      font-size: x-large;
    }
  `;
      var style = document.createElement('style');
      style.media = 'print';
      if (style.styleSheet) {
         style.styleSheet.cssText = css;
      } else {
         style.appendChild(document.createTextNode(css));
      }

      var head = document.head || document.getElementsByTagName('head')[0];
      head.appendChild(style);

      window.print();
   }


 $('.uploadBtn').click(function (e) {
   e.preventDefault();
   var excelFile = $('#excelFile')[0].files[0];
   var formData = new FormData();
   formData.append('excelFile', excelFile);
   $.ajax({
       type: 'post',
       url: './models/addressBook.cfc?method=excelRead',
       data: formData,
       contentType: false,
       processData: false,
       dataType: 'json',
       success: function (response) {
           if (response.success) {
               alert(response.message);
               setTimeout(function () {
                   window.location.href = "?action=listPage";
               }, 1000);
           }
       }
   });
});



/*$(document).ready(function () {
   let params = {}
let regex = /([^&=]+)=([^&]*)/g,m;
while (m = regex.exec(location.href)){
	params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
}
if (Object.keys(params).length>0){
	localStorage.setItem('authInfo',JSON.stringify(params));
   window.history.pushState({},document.title,"/"+"http://127.0.0.1:8500/addressBooking-branch10/addressBooking/?action=listpage");

   
}
let info = JSON.parse(localStorage.getItem('authInfo'));


/*if (info) {
   console.log(info['access_token']);
   console.log(info['expires_in']);
   $.ajax({
       url: "https://www.googleapis.com/oauth2/v3/userinfo",
       headers: {
           "Authorization": `Bearer ${info['access_token']}`
       },
       success: function(data) {
           var formData = new FormData();
           formData.append('strEmail', data.email);
           formData.append('strFullName', data.name);
           formData.append('strUserName', data.name);
           formData.append('strPassword','NULL');
           formData.append('intSubID', data.sub);
           formData.append('fileUserPhoto',data.picture);
           formData.append('bolEmailValid', data.email_verified);
           $.ajax({
               url: './controllers/addressBook.cfc?method=googleLogin',
               type: 'post',
               data: formData,
               contentType: false, 
               processData: false, 
               dataType: 'json',
               success:function(response){
                   if(response.success && response.msg!=''){
                       googleLoginCheck(formData)
                   }
                   else if(response.success && response.msg=='')
                       window.location.href="?action=listpage";
                   else
                       alert('some issue');
               }
           });
       }
   });
}*/


// console.log(JSON.parse(localStorage.getItem('authInfo')));
// console.log(info['access_token']);
// console.log(info['expires_in']);

// fetch("https://www.googleapis.com/oauth2/v3/userinfo",{
// 	headers : {
// 		"Authorization" : `Bearer ${info['access_token']}`
// 	}
// })

// .then((data) => data.json())
// .then((info)=>{
// 	console.log(info)
// 	document.getElementById('name').innerHtml += info.name 
// })
//});


// $('#googleLogin').on('click', function () {
//    signIn();
// });

// function signIn() {
//    let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";

//    let $form = $('<form>')
//        .attr('method', 'GET')
//        .attr('action', oauth2Endpoint);

//    let params = {
//        "client_id": "678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com",
//        "redirect_uri": "http://127.0.0.1:8500/addressBooking-branch10/addressBooking/?action=listpage",
//        "response_type": "token",
//        "scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
//        "include_granted_scopes": "true",
//        "state": 'pass-through-value'
//    };

//    $.each(params, function (name, value) {
//        $('<input>')
//            .attr('type', 'hidden')
//            .attr('name', name)
//            .attr('value', value)
//            .appendTo($form);
//    });

//    $form.appendTo('body').submit();
// }

// });



// $(document).ready(function() {
//    if (location.search.includes("action=listpage")) {
//        let params = {};
//        let regex = /([^&=]+)=([^&]*)/g, m;
//        while ((m = regex.exec(location.href)) !== null) {
//            params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
//        }
//        if (Object.keys(params).length > 0) {
//            localStorage.setItem('authInfo', JSON.stringify(params));
//            window.history.pushState({}, document.title, "/addressBook/?action=listpage");
//        }
//        let info = JSON.parse(localStorage.getItem('authInfo'));
//        if (info) {
//            console.log(info['access_token']);
//            console.log(info['expires_in']);
//            $.ajax({
//                url: "https://www.googleapis.com/oauth2/v3/userinfo",
//                headers: {
//                    "Authorization": `Bearer ${info['access_token']}`
//                },
//                success: function(data) {
//                    var formData = new FormData();
//                    formData.append('strEmail', data.email);
//                    formData.append('strFullName', data.name);
//                    formData.append('strUserName', data.name);
//                    formData.append('strPassword','NULL');
//                    formData.append('intSubID', data.sub);
//                    formData.append('fileUserPhoto',data.picture);
//                    formData.append('bolEmailValid', data.email_verified);
//                    $.ajax({
//                        url: './controllers/addressBook.cfc?method=googleLogin',
//                        type: 'post',
//                        data: formData,
//                        contentType: false, 
//                        processData: false, 
//                        dataType: 'json',
//                        success:function(response){
//                            if(response.success && response.msg!=''){
//                                googleLoginCheck(formData)
//                            }
//                            else if(response.success && response.msg=='')
//                                window.location.href="?action=listpage";
//                            else
//                                alert('some issue');
//                        }
//                    });
//                }
//            });
//        }
//    }
//    function googleLogin(formData){
//        $.ajax({
//            url: './controllers/addressBook.cfc?method=dologin',
//            type: 'post',
//            data: formData,
//            contentType: false, 
//            processData: false, 
//            dataType: 'json',
//            success:function(response){
//                if(response.success){
//                    window.location.href="?action=listpage"; 
//                }
//                else
//                    alert('something went wrong');
//            }
//        });
//    }

//    function googleLoginCheck(formData){
//        $.ajax({
//            url: './models/addressBook.cfc?method=saveUser',
//            type: 'post',
//            data: formData,
//            contentType: false, 
//            processData: false, 
//            dataType: 'json',
//            success: function(response) {
//                if(response.success ){
//                    googleLogin(formData);
//                }
//            }
//        });
//    }



// $(document).ready(function () {
//    let params = {};
//    let regex = /([^&=]+)=([^&]*)/g,m;

//    while ((m = regex.exec(location.href)) !== null) {
//        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
//    }

//    if (Object.keys(params).length > 0) {
//        localStorage.setItem('authInfo', JSON.stringify(params));
//        window.history.pushState({}, document.title, "/AddressBook/");
//    }

//    let info = JSON.parse(localStorage.getItem('authInfo'));

//    if (info) {
//        $.ajax({
//            url: "https://www.googleapis.com/oauth2/v3/userinfo",
//            headers: {
//                "Authorization": `Bearer ${info['access_token']}`
//            },
//            success: function (data) {
//                var email = data.email;
//                var fullName = data.name;
//                var img = data.picture;
//                $.ajax({
//                    url: './controllers/addressBook.cfc?method=googleLogin',
//                    type: 'post',
//                    data: {
//                        email: email,
//                        fullName: fullName,
//                        img: img
//                    },
//                    dataType: "json",
//                    success: function (response) {
//                        if (response.success) {
//                            window.location.href = "?action=listpage";
//                        }
//                    },
//                    error: function (xhr, status, error) {
//                        alert("An error occurred: " + error);
//                    }
//                });
//            }
//        });
//    }

});





// $('#googleIcon').on('click', function () {
//    let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";

//    let $form = $('<form>')
//        .attr('method', 'GET')
//        .attr('action', oauth2Endpoint);

//    let params = {
//        "client_id": "678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com",
//        "redirect_uri": "http://127.0.0.1:8500/addressBooking-branch10/addressBooking/?action=listpage",
//        "response_type": "token",
//        "scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
//        "include_granted_scopes": "true",
//        "state": 'pass-through-value'
//    };

//    $.each(params, function (name, value) {
//        $('<input>')
//            .attr('type', 'hidden')
//            .attr('name', name)
//            .attr('value', value)
//            .appendTo($form);
//    });

//    $form.appendTo('body').submit();
// });

//    });

   /*$(document).ready(function () {

   $('#googleIcon').on('click', function () {
      let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";
   
      let $form = $('<form>')
          .attr('method', 'GET')
          .attr('action', oauth2Endpoint);
   
      let params = {
          "client_id": "678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com",
          "redirect_uri": "http://127.0.0.1:8500/addressBooking-branch10/addressBooking/?action=listpage",
          "response_type": "token",
          "scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
          "include_granted_scopes": "true",
          "state": 'pass-through-value'
      };
   
      $.each(params, function (name, value) {
          $('<input>')
              .attr('type', 'hidden')
              .attr('name', name)
              .attr('value', value)
              .appendTo($form);
      });
   
      $form.appendTo('body').submit();
   });
   let params = {}
   let regex = /([^&=]+)=([^&]*)/g,m;
   while (m = regex.exec(location.href)){
      params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
   }
   if (Object.keys(params).length>0){
      localStorage.setItem('authInfo',JSON.stringify(params));
      window.history.pushState({},document.title,"/"+"http://127.0.0.1:8500/addressBooking-branch10/addressBooking/?action=listpage");
   
      
   }
   let info = JSON.parse(localStorage.getItem('authInfo'));
   if (info) {
      console.log(info['access_token']);
      console.log(info['expires_in']);
      $.ajax({
          url: "https://www.googleapis.com/oauth2/v3/userinfo",
          headers: {
              "Authorization": `Bearer ${info['access_token']}`
          },
          success: function(data) {
              var formData = new FormData();
              formData.append('strEmail', data.email);
              formData.append('strFullName', data.name);
              formData.append('strUserName', data.name);
              formData.append('strPassword','NULL');
              formData.append('intSubID', data.sub);
              formData.append('fileUserPhoto',data.picture);
              formData.append('bolEmailValid', data.email_verified);
              $.ajax({
                  url: './controllers/addressBook.cfc?method=googleLogin',
                  type: 'post',
                  data: formData,
                  contentType: false, 
                  processData: false, 
                  dataType: 'json',
                  success:function(response){
                      if(response.success && response.msg!=''){
                          googleLoginCheck(formData)
                      }
                      else if(response.success && response.msg=='')
                          window.location.href="?action=listpage";
                      else
                          alert('some issue');
                  }
              });
          }
      });
   }   
});*/