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
			url: "../controllers/addressBook.cfc?method=doLogin",
			dataType: "json",
			data: {
				strEmail: strEmail,
				strPassword: strPassword
			},
			success: function (response) {
				if (response.message == true) {
					$("#message").text('Login successful!').css("color", "green");
					window.location.href = "/views/listPage.cfm";

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
		formData.append('strName', strName);
		formData.append('strEmail', strEmail);
		formData.append('strUsername', strUsername);
		formData.append('strPassword', strPassword);
		formData.append('strConfirmPassword', strConfirmPassword);
		formData.append('adminPictureFile', $('#adminPictureFile')[0].files[0]);
		$.ajax({
			type: 'post',
			url: '../controllers/addressBook.cfc?method=validateSignUp',
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
				url: '../models/addressBook.cfc?method=saveUser',
				processData: false,
				contentType: false,
				dataType: "json",
				data: formData,
				success: function (response) {
					if (response.success) {
						$("#message").text(response.message).css("color", "green");
						$('#userImage').attr('src', '../assets/uploads/' + response.image);
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
		let hobbiesArray = [];
		$("#hobbies option:selected").each(function() {
			hobbiesArray.push($(this).val());
		});

		
		if (strTitle === '' || strFirstName === '' || strLastName === '' || strGender === '' || strBirthday === '' || strAddress === '' || strStreet === '' || intPincode === '' || strEmailID === '' || intPhoneNumber === '') {
			$("#validationMessage").text('All fields are required').css("color", "red");
			return false;
		}
	
		var formData = new FormData();
		formData.append('personid', personid);
		formData.append('strTitle', strTitle);
		formData.append('strFirstName', strFirstName);
		formData.append('strLastName', strLastName);
		formData.append('strGender', strGender);
		formData.append('strBirthday', strBirthday);
		formData.append('strAddress', strAddress);
		formData.append('strStreet', strStreet);
		formData.append('intPincode', intPincode);
		formData.append('intPhoneNumber', intPhoneNumber);
		formData.append('strEmailID', strEmailID);
		formData.append('pictureFile', $('#pictureFile')[0].files[0]);
		formData.append('hobbies', hobbiesArray.join(','));

		$.ajax({
			type: "POST",
			url: "../controllers/addressBook.cfc?method=savePageValidation",
			data: formData,
			processData: false,
			contentType: false,
			dataType: "json",
			success: function (response) {
				if (response.success == true) {
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
			url: "../models/addressBook.cfc?method=savePage",
			processData: false,
			contentType: false,
			dataType: "json",
			data: formData,
			success: function (response) {

				if (response.success == true) {
					$('#validationMessage').text(response.message).css("color", "green");
					window.location.href = "/views/listPage.cfm";

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
		$('#userImageEdit').attr('src', '../assets/images/user.JPG');

	});
	
	$('.editModalBtn').click(function (e) {
		e.preventDefault();
		var personid = $(this).attr('personid');
		$.ajax({
			type: "POST",
			url: "../models/addressBook.cfc?method=selectData",
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
				
					if(response.hobbies!=""){
						$('.filter-option-inner-inner').text(response.hobbies);
					}
					

					$('#userImageEdit').attr('src', '../assets/uploads/' + response.image);
				}
			}
		});
	});

	$('#formClose').click(function (e) {
		e.preventDefault();
		$("#formID").get(0).reset();
	});

	$('.deleteLink').click(function (e) {
		e.preventDefault();
		var personid = $(this).attr('personid');
		if (confirm("click OK to delete this row?")) {
			$.ajax({
				type: "POST",
				url: "../models/addressBook.cfc?method=deleteData",
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
			url: "../models/addressBook.cfc?method=displayData",
			data: {
				personid: personid
			},
			dataType: "json",
			success: function (response) {
				var imageUrl = '../assets/uploads/' + response.DATA[0][7]; 
				var name = response.DATA[0][0]; 
				var gender = response.DATA[0][1];
				var dob = response.DATA[0][2]; 
				var address = response.DATA[0][3]; 
				var pincode = response.DATA[0][4]; 
				var email = response.DATA[0][5]; 
				var phone = response.DATA[0][6]; 
				
				$('#userImageView').attr('src', imageUrl);
				
				var hobbiesHtml = "";
				$.each(response.DATA, function (index, rowData) {
					hobbiesHtml += rowData[8]; 
					hobbiesHtml += "<br>";
				});
				
				var tableHtml = "<table>";
				tableHtml += "<tr><th>Name</th><td>" + name + "</td></tr>";
				tableHtml += "<tr><th>Gender</th><td>" + gender + "</td></tr>";
				tableHtml += "<tr><th>Date of Birth</th><td>" + dob + "</td></tr>";
				tableHtml += "<tr><th>Address</th><td>" + address + "</td></tr>";
				tableHtml += "<tr><th>Pincode</th><td>" + pincode + "</td></tr>";
				tableHtml += "<tr><th>Email</th><td>" + email + "</td></tr>";
				tableHtml += "<tr><th>Phone</th><td>" + phone + "</td></tr>";
				tableHtml += "<tr><th>Hobbies</th><td>" + hobbiesHtml + "</td></tr>";
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
			url: '../models/addressBook.cfc?method=excelRead',
			data: formData,
			contentType: false,
			processData: false,
			dataType: 'json',
			success: function (response) {
				if (response.success==true) {
					alert(response.message);
					window.location.href = "listPage.cfm";

				}
				else if(response.success==false){
					alert(response.message);
				}
			}
		});
	});

});

$(document).ready(function () {
	$('#googleIcon').on('click', function () {
		signIn();
	});
	let params = {};
	params={"http://addressbook.local/views":"listPage"};
	let regex = /([^&=]+)=([^&]*)/g,
		m;

	while ((m = regex.exec(location.href)) !== null) {
		params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
	}

	if (Object.keys(params).length > 0) {
		localStorage.setItem('authInfo', JSON.stringify(params));
		window.history.pushState({}, document.title, "");
	}
	let info = JSON.parse(localStorage.getItem('authInfo'));

	if (info) {
		$.ajax({
			url: "https://www.googleapis.com/oauth2/v3/userinfo",
			headers: {
				"Authorization": `Bearer ${info['access_token']}`
			},
			success: function (data) {
				var emailID = data.email;
				var name = data.name;
				var image = data.picture;
				$.ajax({
					url: '../controllers/addressBook.cfc?method=googleLogin',
					type: 'post',
					data: {
						emailID: emailID,
						name: name,
						image: image
					},
					dataType: "json",
					success: function (response) {
						if (response.success) {
							window.location.href = "/views/listPage.cfm";
						}
					},
					error: function (xhr, status, error) {
						alert("An error occurred: " + error);
					}
				});
			}
		});
	}
});

function signIn() {
	let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";
	let $form = $('<form>')
		.attr('method', 'GET')
		.attr('action', oauth2Endpoint);
	let params = {
		"client_id": "678283113676-2jr700ekm9hq9akpcmr01n4qto8f67b2.apps.googleusercontent.com",
		"redirect_uri": "https://redirectmeto.com/http://addressbook.local/views/listPage.cfm",
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
}



