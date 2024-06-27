<cfinclude  template="header.cfm">
<cfinclude  template="homeNavigation.cfm">
<cfset variables.image = session.sso ? session.image : ("../assets/uploads/" & session.image)>
<cfoutput>
    <cfif session.login>
		<div class="listContainer"></div>
		<div class="d-flex">
			<div class="leftSpace"></div>
			<div class="d-flex justify-content-end printDiv">
				<div class="d-flex justify-content-end listDiv">
					<a href="../views/pdfDownload.cfm" target="_blank" class="printNone"><img src="../assets/images/pdf.JPG" id="pdf" alt="pdf"></a>
					<a href="../views/excelDownload.cfm" class="printNone"><img src="../assets/images/excel.JPG" id="excel" alt="excel"></a>
					<a href="" class="printNone"><span class="material-symbols-outlined print" id="print">print</span></a>
				</div>
			</div>
			<div class="rightSpace"></div>
		</div>
		<div class="listContainer"></div>
		<div class="d-flex mainContainer">
			<div class="d-flex flex-column leftSection ">
				<div class="printNone"> 
					<img src="#variables.image#" id="userImage"  alt="user" width="100" height="100">
				</div>
				<div class="printNone">
					<p id="name">
						<cfoutput>#session.fullname#</cfoutput>..
					</p>
				</div>
				<div class="printNone">
					<button type="button" class="btn btn-primary createBtn"  data-toggle="modal" data-target="##createModal">CREATE CONTACT</button>
					<button type="button" class="btn btn-primary upload"  data-toggle="modal" data-target="##uploadModal">UPLOAD EXCEL</button>
				</div>
			</div>
			<div class="modal fade" id="uploadModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div>
							<h5 class="modal-title text-center mt-3" id="exampleModalLabel">UPLOAD EXCEL</h5>
						</div>
						<div class="modal-body">
						<div class="float-end">
							<a href="dataExcelRead.cfm" target="_blank" class="btn btn-primary btn-lg active" role="button" aria-pressed="true">Template with data</a>
							<a href="plainExcelRead.cfm" target="_blank" class="btn btn-success btn-lg active" role="button" aria-pressed="true">Plain template</a>
						</div>
							<form action="listPage.cfm" method="post" enctype="multipart/form-data" id="formUpload">
								<div class="d-flex flex-column">
									<label>Upload File</label>
									<input type="file" class="mt-3" name="excelFile" id="excelFile">                      
								</div>
							</form>
							<p id="validationMessageExcel"></p>
						</div>
<!--- 						<a href="resultExcel.cfm" target="_blank" class="btn btn-secondary btn-lg active" role="button" aria-pressed="true">Result</a> --->
						<div class="modal-footer">
							<button type="button" class="btn btn-primary uploadBtn">UPLOAD</button>
							<button type="button" class="btn btn-secondary" data-dismiss="modal">CLOSE</button>
						</div>
					</div>
				</div>
			</div>
			<div class="modal" id="createModal">
				<div class="modal-dialog">
					<div class="modal-content flex-row">
						<div class="modalLeft"></div>
						<div class="modal-header">
							<div class="modal-title-div">
								<h4 class="modal-title" id="modalTitle">CREATE CONTACT</h4>
								
							</div>
							<form action="listPage.cfm" method="post" enctype="multipart/form-data" id="formID">
								<div class="mt-4 personContact">
									<p>Personal Contact</p>
								</div>
								<div class="d-flex justify-content-between mt-3 titleLabel">
									<div class="d-flex flex-column">
										<label>Title *</label>
										<select name="strTitle" id="strTitle" value="">
											<option selected value=""></option>
											<option value="Mr">Mr</option>
											<option value="Mrs">Mrs</option>
											<option value="Ms">Ms</option>
										</select>
									</div>
									<div class="d-flex flex-column">
										<label>First Name *</label>
										<input type="text" name="strFirstName" id="strFirstName"  placeholder="Your First Name">
									</div>
									<div class="d-flex flex-column">
										<label>Last Name *</label>
										<input type="text" name="strLastName" id="strLastName"  placeholder="Your Last Name">
									</div>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="d-flex flex-column">
										<label>Gender *</label>
										<select name="strGender" id="strGender" value="">
											<option selected value=""></option>
											<option value="Male">Male</option>
											<option value="Female">Female</option>
										</select>
									</div>
									<div class="d-flex flex-column">
										<label>Date Of Birth *</label>
										<input type="date" id="strBirthday" name="strBirthday" value="">                        
									</div>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="d-flex flex-column">
										<label>Upload Photo</label>
										<input type="file" name="pictureFile" id="pictureFile">                      
									</div>
								</div>
								<div class="mt-4 personContact">
									<p>Contact Details</p>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="d-flex flex-column">
										<label>Address *</label>
										<input type="text" id="strAddress" name="strAddress" placeholder="Your Address">                        
									</div>
									<div class="d-flex flex-column">
										<label>Street *</label>
										<input type="text" id="strStreet" name="strStreet" placeholder="Your Street Name">                        
									</div>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="d-flex flex-column">
										<label>Pincode *</label>
										<input type="text" id="intPincode" name="intPincode" maxlength="6" placeholder="Your pincode">
									</div>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="d-flex flex-column">
										<label>Email ID *</label>
										<input type="text" id="strEmailID" name="strEmailID" placeholder="Your Email ID">                        
									</div>
									<div class="d-flex flex-column">
										<label>Phone number *</label>
										<div class="d-flex">
											<input type="text" class="countryCode" value="+91" readonly>
											<input type="text" id="intPhoneNumber" name="intPhoneNumber" maxlength="10" placeholder="Your Phone number">
										</div>                        
									</div>
								</div>
								<div class="d-flex justify-content-between mt-4 titleLabel">
									<div class="">
										<label>Hobbies </label><br>
     									<select multiple id="hobbiesSelect" name="hobbies"></select>
									</div>
								</div><br>
								<input type="hidden" name="personid" id="personid" value="0">
								<input type="submit" class="btn btn-primary" id="formBtn" value="Submit">
								<button type="button" class="btn btn-secondary" data-dismiss="modal" id="formClose">Close</button>
							</form>
							<p id="validationMessage"></p>
						</div>
						<div class="modal-footer">
							<img src="../assets/images/user.JPG" id="userImageEdit" width="100" height="100"  alt="user"> 
						</div>
					</div>
				</div>
			</div>
			<div class="d-flex flex-column rightSection">
				<cfoutput>
					<table>
						<thead>
							<tr>
								<th></th>
								<th>Name</th>
								<th>Email</th>
								<th>Phone number</th>
							</tr>
						</thead>
						<tbody>
							<cfset persons = EntityLoad("person")>
							<cfloop array="#persons#" index="person">
								<cfif session.userid eq person.getuserid()>
									<tr>
										<td><img src="../assets/uploads/#person.getimage()#" alt="image" width="50" height="50"></td>
										<td>#person.getFname()# #person.getLname()#</td>
										<td>#person.getemailID()#</td>
										<td>#person.getphone()#</td>
										<td class="printNone"><button type="button" class="btn btn-outline-primary editModalBtn" personid="#person.getpersonid()#" data-target="##createModal" data-toggle="modal">EDIT</button></td>
										<td class="printNone"><button type="button" class="btn btn-outline-primary deleteLink" personid="#person.getpersonid()#">DELETE</button></td>
										<td class="printNone"><button type="button" class="btn btn-outline-primary viewLink" personid="#person.getpersonid()#" data-target="##editModal" data-toggle="modal">VIEW</button></td>
									</tr>
								<cfelse>
									<cfcontinue>	
								</cfif>
							</cfloop>
						</tbody>
					</table>
				</cfoutput>
				<div class="modal" id="editModal">
					<div class="modal-dialog">
						<div class="modal-content flex-row">
							<div class="modalLeft"></div>
							<div class="modal-header">
								<div class="modal-title-div">
									<h4 class="modal-title">CONTACT DETAILS</h4>
								</div>
								<div id="tableContainer"></div>
								<div class="text-center mt-2">
									<button type="button" class="btn closeBtn" data-dismiss="modal">CLOSE</button>
								</div>
							</div>
							<div class="modal-footer">
								<img src="" id="userImageView" alt="User Image" width="100" height="100">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</body>
		</html>
	<cfelse>
		<cflocation  url="/views/login.cfm">	
	</cfif>
</cfoutput>
