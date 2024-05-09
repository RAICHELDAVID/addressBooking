<div class="listContainer"></div>
<div class="d-flex">
	<div class="leftSpace"></div>
	<div class="d-flex justify-content-end printDiv">
		<div class="d-flex justify-content-end listDiv">
			<a href=""><img src="./assets/images/pdf.JPG" id="pdf" alt="pdf"></a>
			<a href=""><img src="./assets/images/excel.JPG" id="pdf" alt="excel"></a>
			<a href=""><span class="material-symbols-outlined print">print</span></a>
		</div>
	</div>
	<div class="rightSpace"></div>
</div>
<div class="listContainer"></div>
<div class="d-flex mainContainer">
	<div class="d-flex flex-column leftSection">
		<div>
			<img src="./assets/images/user.JPG" id="user"  alt="user">
		</div>
		<div>
			<p>
				<cfoutput>#session.fullname#</cfoutput>
			</p>
		</div>
		<div>
			<button type="button" class="btn btn-primary" id="createBtn" data-toggle="modal" data-target="#createModal">CREATE CONTACT</button>
		</div>
	</div>
	<div class="modal" id="createModal">
		<div class="modal-dialog">
			<div class="modal-content flex-row">
				<div class="modalLeft"></div>
				<div class="modal-header">
					<div class="modal-title-div">
						<h4 class="modal-title">CREATE CONTACT</h4>
					</div>
					<form action="index.cfm?action=listPage" method="post" id="formID">
						<div class="mt-4 personContact">
							<p>Personal Contact</p>
						</div>
						<div class="d-flex justify-content-between mt-3 titleLabel">
							<div class="d-flex flex-column">
								<label>Title *</label>
								<select name="strTitle" id="strTitle">
									<option selected disabled hidden></option>
									<option value="Mr">Mr</option>
									<option value="Mrs">Mrs</option>
									<option value="Ms">Ms</option>
								</select>
							</div>
							<div class="d-flex flex-column">
								<label>First Name *</label>
								<input type="text" name="strFirstName" id="strFirstName" value="#variables.strFirstName#"  placeholder="Your First Name">
							</div>
							<div class="d-flex flex-column">
								<label>Last Name *</label>
								<input type="text" name="strLastName" id="strLastName"  placeholder="Your Last Name">
							</div>
						</div>
						<div class="d-flex justify-content-between mt-4 titleLabel">
							<div class="d-flex flex-column">
								<label>Gender *</label>
								<select name="strGender" id="strGender">
									<option selected disabled hidden></option>
									<option value="Male">Male</option>
									<option value="Female">Female</option>
								</select>
							</div>
							<div class="d-flex flex-column">
								<label>Date Of Birth *</label>
								<input type="date" id="strBirthday" name="strBirthday">                        
							</div>
						</div>
						<div class="d-flex justify-content-between mt-4 titleLabel">
							<div class="d-flex flex-column">
								<label>Upload Photo</label>
								<input type="file" name="pictureFile" id="photoFile">                        
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
								<input type="text" id="intPincode" name="intPincode" placeholder="Your pincode">
							</div>
						</div>
						<div class="d-flex justify-content-between mt-4 titleLabel">
							<div class="d-flex flex-column">
								<label>Email ID *</label>
								<input type="text" id="strEmailID" name="strEmailID" placeholder="Your Email ID">                        
							</div>
							<div class="d-flex flex-column">
								<label>Phone number *</label>
								<input type="" id="intPhoneNumber" name="intPhoneNumber" placeholder="Your Phone number">                        
							</div>
						</div>
						<input type="hidden" name="personid" value="#personid#">
						<input type="submit" class="btn btn-primary" id="formBtn" value="submit">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">CLOSE</button>
					</form>
					<p id="validationMessage"></p>
				</div>
				<div class="modal-footer">
					<img src="./assets/images/user.JPG" id="user"  alt="user"> 
				</div>
			</div>
		</div>
	</div>
	<div class="d-flex flex-column rightSection">
		<cfoutput>
			<table>
				<thead>
					<tr>
						<th>Name</th>
						<th>Email</th>
						<th>Phone number</th>
					</tr>
				</thead>
				<tbody>
					<cfset persons = EntityLoad("person")>
					<cfloop array="#persons#" index="person">
						<tr>
							<td>#person.getFname()# #person.getLname()#</td>
							<td>#person.getemailID()#</td>
							<td>#person.getphone()#</td>
						    <td><button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="##createModal" data-id="#person.getpersonid()#"><a href='?action=listPage&personid=#person.getpersonid()#' class="">EDIT</a></button></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</cfoutput>
	</div>
</div>
</body>
</html>