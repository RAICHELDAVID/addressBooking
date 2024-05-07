<cfinclude template="header.cfm">
<cfinclude template="homeNavigation.cfm">
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
            <p><cfoutput>#session.fullname#</cfoutput></p>
        </div>
        <div>
            <button type="submit" id="createBtn">CREATE CONTACT</button>
        </div>
    </div>
    <div class="d-flex flex-column rightSection">
    hello
    </div>
</div>
</body>
</html>