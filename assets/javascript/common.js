
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
      $.ajax({
         type: 'post',
         url: 'controllers/addressBook.cfc?method=validateSignUp',
         data: {
            strName: strName,
            strEmail: strEmail,
            strUsername: strUsername,
            strPassword: strPassword,
            strConfirmPassword: strConfirmPassword

         },
         dataType: 'json',
         success: function (response) {
            if (response.success) {
               saveUser(strName, strEmail, strUsername, strPassword, strConfirmPassword);
            } else {
               $("#message").html(response.message.join('<br>')).css("color", "red");
            }
         },

      });
      saveUser = function (strName, strEmail, strUsername, strPassword, strConfirmPassword) {
         $.ajax({
            type: 'post',
            url: 'models/addressBook.cfc?method=saveUser',
            data: {
               strName: strName,
               strEmail: strEmail,
               strUsername: strUsername,
               strPassword: strPassword,
               strConfirmPassword: strConfirmPassword
            },
            dataType: 'json',
            success: function (response) {
               if (response.success) {
                  $("#message").text(response.message).css("color", "green");
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
      formData.append('pictureFile', $('input[type=file]')[0].files[0]); 

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
         url: "models/addressBook.cfc?method=savePage",
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
               console.log(response.dob);
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

  function handleCredentialResponse(response) {
   console.log("Encoded JWT ID token: " + response.credential);
   $.ajax({
     url: './controllers/addressBook.cfc?method=verify',
     type: 'POST',
     contentType: 'application/json',
     data: JSON.stringify({ token: response.credential }),
     success: function (response) {
       if (response.success) {
         window.location.href = '?action=listPage';
       } else {
         console.error('Login failed');
       }
     },
     error: function () {
       console.error('Login failed');
     }
   });
 }

 google.accounts.id.initialize({
   client_id: '678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com',
   callback: handleCredentialResponse
 });

 $('#googleIcon').click(function () {
   google.accounts.id.prompt();
 });



   $('.uploadBtn').click(function (e){
      e.preventDefault();
      var excelFile = $('#excelFile')[0].files[0];
      $.ajax({
         type:'post',
         url:'./models/addressBook.cfc?method=excelRead',
         data:excelFile,
         datatype:'json',
         success:function(response){

         }
      });
   });

  
});
