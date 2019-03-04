#Retrieves users in DX AD that haven't logged in for 90 days or more


##############################
#Users in DX
#for STM.DXIDE.com
#Created by: Andrew Wrobel
#Last Updated: 2/13/2019
##############################

#Get-ADUser -Properties mail -Filter {mail -notlike '*'} | Export-csv -path c:\Scripts\CSVs\Users-With_NO-email.csv

#Get-ADUser -filter * -properties passwordlastset, lastlogondate, Enabled -eq "Enabled", mail | sort-object name | select-object Enabled, Name, mail, passwordlastset, passwordneverexpires | Export-csv -path C:\2019Dev\user-password-info.csv

#Get-ADUser -SearchBase "OU=All_Users,DC=dxide,DC=local" -filter {Enabled -eq "Enabled", lastlogondate - -properties SamAccountName, LastLogonDate, created, passwordlastset, passwordneverexpires, Enabled, mail, DistinguishedName | sort-object name | select-object Enabled, Name, mail, SamAccountName, passwordlastset, passwordneverexpires, LastLogonDate, created, DistinguishedName | Export-csv -path C:\2019Dev\user-password-info.csv

Get-ADUser -SearchBase "OU=All_Users,DC=dxide,DC=local" –filter * -Properties created,passwordLastSet,lastlogondate,Enabled,mail | ? {$_.distinguishedname -notmatch 'OU=UTILITY'} | Where { ($_.passwordLastSet –eq $null –or $_.lastlogondate –lt (Get-Date).AddDays(-90)) -and ($_.Enabled -eq 'true')  -and ($_.created –lt (Get-Date).AddDays(-90)) } | sort-object LastLogonDate | select-object Name, Mail, SamAccountName, DistinguishedName, LastLogonDate -OutVariable users | Export-csv -path C:\2019Dev\user-password-info.csv

Write-Host $users

$(
echo '<html>'
echo '     <head>'
echo '          <link rel="stylesheet" type="text/css" href="stylesheet.css">'
echo '     <title>Users In DX</title>'
echo '     </head>'
$s = @"
<style>
* {
  box-sizing: border-box;
}
#myBtn {
  display: none;
  position: fixed;
  bottom: 20px;
  right: 30px;
  z-index: 99;
  border: none;
  outline: none;
  background-color: #00b33c;
  color: white;
  cursor: pointer;
  padding: 15px;
  border-radius: 10px;
}

#myBtn:hover {
  background-color: red;
}
#myInput[type=text] {
  background-image: url('Search.png');
  background-position: 1px 8px;
  background-repeat: no-repeat;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  width: 500px;
  font-size: 40px;
  padding: 15px 1px 15px 75px;
  margin-bottom: 12px;
  -webkit-transition: width 0.4s ease-in-out;
  transition: width 0.4s ease-in-out;
}

#myInput[type=text]:focus {
    width: 80%;
}

#MyTable {
  border-collapse: collapse;
  width: 100%;
  border: 1px solid #ddd;
  font-size: 22px;
  color: #80ffaa;
}
h1, h2, h3, h4 {
  color: #80ffaa;
}

.dropbtn {
    background-color: #4CAF50;
    color: white;
    padding: 16px;
    font-size: 16px;
    border: none;
    cursor: pointer;
}

.dropdown {
    position: relative;
    display: inline-block;
}

.dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 250px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
}

.dropdown-content a {
    color: green;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
}

.dropdown-content a:hover {background-color: #d1d1d1}

.dropdown:hover .dropdown-content {
    display: block;
}

.dropdown:hover .dropbtn {
    background-color: #3e8e41;
}

a.export,
a.export:visited {
  display: inline-block;
  text-decoration: none;
  color: #000;
  background-color: #ddd;
  border: 1px solid #ccc;
  padding: 8px;
}

table th, table td {
  text-align: left;
  padding: 2px;
}

table, tr {
  border-bottom: 1px solid #ddd;
}

table tr.header, table tr:hover {
  background-color: #80ffaa;
  color: black;
  font-weight: bold;
}
a {
  color: #009900;
  font-weight: bold;
  font-style: italic;
}

p {
  color: #80ffaa;
}
</style>
"@
echo $s

 $x = @"
<script>
function myFunction() {
  // Declare variables 
  var input, filter, table, tr, td, i;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("MyTable");
  tr = table.getElementsByTagName("tr");

  // Loop through all table rows, and hide those who don't match the search query
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[1];
    if (td) {
      if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    } 
  }
}



function downloadCSV(csv, filename) {
    var csvFile;
    var downloadLink;

    // CSV file
    csvFile = new Blob([csv], {type: "text/csv"});

    // Download link
    downloadLink = document.createElement("a");

    // File name
    downloadLink.download = filename;

    // Create a link to the file
    downloadLink.href = window.URL.createObjectURL(csvFile);

    // Hide download link
    downloadLink.style.display = "none";

    // Add the link to DOM
    document.body.appendChild(downloadLink);

    // Click download link
    downloadLink.click();
}


function exportTableToCSV(filename) {
    var csv = [];
    var rows = document.querySelectorAll("table tr");
    
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll("td, th");
        
        for (var j = 0; j < cols.length; j++) 
            row.push(cols[j].innerText);
        
        csv.push(row.join(","));        
    }

    // Download CSV file
    downloadCSV(csv.join("\n"), filename);
}

window.onscroll = function() {scrollFunction()};

function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        document.getElementById("myBtn").style.display = "block";
    } else {
        document.getElementById("myBtn").style.display = "none";
    }
}

function topFunction() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}
</script>

"@

echo $x

echo '<p><font face="Arial"><font color="Black"> <body bgcolor="#000000" text="#80ffaa">'
echo '<h1><a href="index.html">DX Management Site</a></h1>'
echo '
<div class="dropdown">
  <button class="dropbtn">Menu</button>
  <div class="dropdown-content">
    <a href="PasswordInfo.html">Users In DX</a>
    <a href="AppRequests.html">Recent Requests for App Access</a>
    <a href="Okta_Analytics.html">Okta Analytics</a>
    <a href="OktaEvents.html">Okta Events</a>
    <a href="OktaUsers.html">Okta Users</a>
    <a href="OktaUsersApplications.html">Okta Users Apps</a>
    <a href="Okta_Matrix.html">Okta Matrix</a>
    <a href="OktaUsersGroups.html">Okta Users Groups</a>
    <a href="owadisabled.html">OWA Disabled</a>
    <a href="AltriaDistribution.html">Altria Distribution</a>
    <a href="UsersInGroupsSite.html">Users In Groups</a>
    <a href="UsersInSecurityGroupsSite.html">Users In Security Groups</a>
    <a href="Crowd.html">Crowd Users</a>
    <a href="Udrive_Matrix.html">Udrive Matrix</a>
    <a href="Udrive.html">Udrive</a>
    <a href="SASadmins.html">SAS Admins</a>
<a href="OUfolder.html">OU folders</a>	
<a href="DomainAdmins.html">Domain Admins</a>
<a href="DC_Status.html">Domain Controller Health & Status</a>
<a href="PasswordPolicy.html">Password Policy</a>
<a href="LoginFailures.html">Login Failures</a>
<a href="PastFourteen.html">User Access</a>
<a href="Computers.html">Computers</a>
  </div>
</div>'
 $y = @"
<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names..">
<button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
"@
echo '<h1 align="center"><b>Users In DX</b></h1>'
echo '<br>'
echo '<h3>This page contains all of the users in the DX.</h3>'
echo '<h3>This page updates every 5 minutes.</h3>'
echo $y
echo '<br>'
echo '<hr>'
echo '<br>'
$b = @"
<button onclick="exportTableToCSV('DX_Users.csv')">Export To CSV File</button>
"@
echo $b
$z = @"
<div id="MyTable" style="overflow-x:auto;">
"@

echo $z

Get-ADUser -SearchBase "OU=All_Users,DC=dxide,DC=local" -filter * -properties SamAccountName, LastLogonDate, created, passwordlastset, passwordneverexpires, Enabled, mail, DistinguishedName | sort-object name | select-object Enabled, Name, mail, SamAccountName, passwordlastset, passwordneverexpires, LastLogonDate, created, DistinguishedName | ConvertTo-Html 

echo "</div>"

echo '<h4>Last Updated:</h4>'
echo '<p>' 
Get-Date
echo '</p>'
echo '</body>'
echo '</html>'

) *>&1 >  C:\2019Dev\PasswordInfo.html