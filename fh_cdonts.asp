
<%
'This script will test the CDONTS component of a web server

from_address="bob@bobsdomain.co.uk" 'This is a ficticious customers email address
to_address="ENTER YOUR EMAIL ADDRESS HERE" 'Enter your email address inbetween the quotation marks.
' NOTE: This email address must be a valid mailbox hosted with Fasthosts, or the email will be blocked by webserver spam filters.

On Error Resume Next 'Checks for errors
' Now let's send the email
	Dim Mailer
	Set Mailer = Server.CreateObject("CDONTS.NewMail")
	Mailer.To = to_address
	Mailer.From = from_address
	Mailer.Subject = "Test message using cdonts at "& now
	Mailer.Body = "this message was sent using an Fasthosts test script at" &now
	Mailer.MailFormat = 1
	Mailer.BodyFormat = 1
	Mailer.Send
	Set Mailer = Nothing
	CDONTS = true

	if err.number <> 0 then 'Checks for any errors
Response.write("Unable to send mail "& Err.description & err.number) 'Provides an error message. Also displays the error number and a brief description of the error
Response.end()
else
	response.write("Message sent to "& to_address &" from "& from_address &" at "& now) 'Provides confirmation that the email has been sent
end if

%>