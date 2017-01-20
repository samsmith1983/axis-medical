<%@ LANGUAGE="VBScript" CODEPAGE="1252"%>
<!--#Include virtual="/includes/script/util.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<%=drawMetaData(1)%>
<link rel="stylesheet" href="/styles/enqform.css" type="text/css" />
<!--[if lte IE 7]>
<link href="/styles/enqform_ie7ol.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if lte IE 6]>
<link href="/styles/enqform_ie6ol.css" rel="stylesheet" type="text/css" />
<![endif]-->
<script type="text/javascript" src="/script/uni_form.js"></script>
</head>

<body onload="window.focus();">
<script type="text/javascript">
setvalidation(
['Name','Address','Telephone','Email','Enquiry'],
[',1,',',1,','number,1,','email,1,',',1,'],
['Name:','Address:','Telephone:','Email:','Enquiry:']);
</script>
<h1>Enquiry Form</h1>
<form id="formenquiry" method="post" action="formmail.asp" onsubmit="return checkform(this);">
  <p>Please fill in the following form and we will get back to you as soon as possible.</p>
  <fieldset>
	<table cellspacing="0">
	  <tr>
		<th><label for="Name">Name:</label></th>
		<td><input type="text" name="Name" id="Name" /></td>
	  </tr>
	  <tr>
		<th><label for="Address">Address:</label></th>
		<td><textarea name="Address" id="Address" rows="5" cols="14"></textarea></td>
	  </tr>
	  <tr>
		<th><label for="Telephone">Telephone:</label></th>
		<td><input type="text" name="Telephone" id="Telephone" /></td>
	  </tr>
	  <tr>
		<th><label for="Email">Email:</label></th>
		<td><input type="text" name="Email" id="Email" /></td>
	  </tr>
	  <tr>
		<th><label for="Enquiry">Enquiry:</label></th>
		<td><textarea name="Enquiry" id="Enquiry" rows="5" cols="14"></textarea></td>
	  </tr>
	</table>
  </fieldset>
  <table cellspacing="0" class="buttons">
    <tr>
	  <td class="right"><input type="hidden" name="recipient" value="<%=application("EMAIL")%>" />
		<input type="hidden" name="redirect" value="/thankyou.asp" />
		<input type="hidden" name="subject" value="Enquiry from website" />
		<input type="reset" value="Reset" class="reset" /></td>
	  <td><input type="submit" value="Submit" class="submit" /></td>
    </tr>
  </table>
</form>
</body>
</html>
