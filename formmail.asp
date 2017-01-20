<%	

		'*************************************************************************
		'	Purpose: WIDA Group formmail.cgi replacement
		'	Project: General
		'	Company: Widagroup LTD (wg3)
		'	Author:  Pete Sheldrake
		'	Original Date: August, 2002
		'	Workfile: formmail.asp
		'
		'	Revision History:
		'   Sept 2002 : Added Referer and Recipient checking security features
		'	 
		'*************************************************************************

		'Example Referers
		'Dim vReferers: vReferers = Array("www.defabs.com", "www.defabs.co.uk")
		Dim vReferers: vReferers = Array("www.axismedical.co.uk","www.axismedical.com","axismedical.widagroup.net","axismedical")
		
		'Example Recipients 
		'Dim vRecipients: vRecipients = Array("defabs.inty.net")
		Dim vRecipients: vRecipients = Array("axismedical.co.uk","axismedical.com","widagroup.com")
		
		'*********************************************************
		' DO NOT EDIT BELOW THIS LINE
		'*********************************************************
		
		Dim sSubject
		Dim sRedirect
		Dim sEmail
		Dim csMailFooter
		
		Dim vRecipientList
		
		Dim sRefusedAddress
		Dim sReferer

		' Call the function that does the work
		Main
		
		'*********************************************************
		
		Function DayOfTheWeek()

		    Select Case Weekday(Date, 1)
		        Case 1
		            DayOfTheWeek = "Sunday"
		        Case 2
		            DayOfTheWeek = "Monday"
		        Case 3
		            DayOfTheWeek = "Tuesday"
		        Case 4
		            DayOfTheWeek = "Wednesday"
		        Case 5
		            DayOfTheWeek = "Thursday"
		        Case 6
		            DayOfTheWeek = "Friday"
		        Case 7
		            DayOfTheWeek = "Saturday"
		            
		    End Select
		    
		End Function

		Function LongDate()

		    LongDate = FormatDateTime(Date, 1)

		End Function

		Function GetDateAndTime()

		    GetDateAndTime = DayOfTheWeek & ", " & LongDate & " at " & Time

		End Function

		Function sendEmail(strTo,strFrom,strSubject,strBody)
			sendEmail = True ' tells the page it was sent OK
			
			On Error Resume Next
			Set objEmail = Server.CreateObject("CDO.Message") ' creates an SMTP object
			
			objEmail.To = strTo
			objEmail.From = strFrom
			objEmail.Subject = strSubject
			objEmail.TextBody = strBody
			objEmail.Send
			
			Set objEmail = Nothing
				
			If Err.Number <> 0 Then ' if there is an error lets display it
				sendEmail = false
				
			End If
			On Error Goto 0
			
		End Function

		Function bValidateReferer
			Dim iCounter
			Dim bURLVerified : bURLVerified = False
			Dim vData
					
			vData = Request.ServerVariables("HTTP_REFERER")
			vData = split(vData,"/")
			sReferer = vData(2)
			vData = ""

			For iCounter = LBound(vReferers) To UBound(vReferers)
				If LCase(sReferer) = LCase(vReferers(iCounter)) Then
					bURLVerified = True
				End If
			Next

			bValidateReferer = bURLVerified

		End Function

		Function bValidateRecipients()
		    Dim iCounter
		    Dim iCounter2
		    Dim bAddressVerified: bAddressVerified = False
		    Dim vData2
		    Dim sRecipient
		            
		    vRecipientList = Request("recipient")
		    vRecipientList = Split(vRecipientList, " ")
		    
		    For iCounter2 = LBound(vRecipientList) To UBound(vRecipientList)
		        vData2 = Split(vRecipientList(iCounter2), "@")
		        sRecipient = vData2(1)
		        vData2 = ""
		        
		        bAddressVerified = False
		        
		        For iCounter = LBound(vRecipients) To UBound(vRecipients)
		            If LCase(sRecipient) = LCase(vRecipients(iCounter)) Then
		                bAddressVerified = True
		                Exit For
		                
		            End If
		            
		        Next
		        
		        If Not bAddressVerified Then
		            sRefusedAddress = vRecipientList(iCounter2)
		            Exit For
		        End If
		        
		    Next
		     
		    bValidateRecipients = bAddressVerified

		End Function

		'*********************************************************
		'  Generation of the final email
		'*********************************************************
		
		Sub Main
			Dim bInError
			Dim iCounter3
			
			sSubject = Request("subject")
			sRedirect = Request("redirect")		
			sEmail = Request("Email")
		
			csMailHeader = "Below is the result of your feedback form.  It was submitted by" & vbCRLF & " (%s) on %dt" & vbCRLF & "-------------------------------------------------------------------------" & vbCRLF
			csMailFooter = vbCRLF & "-------------------------------------------------------------------------" & vbCRLF
		
			If bValidateReferer = True And bValidateRecipients = True Then

				'Build The Header
				sHeader = Replace(csMailHeader, "%s", sEmail)
				sHeader = Replace(sHeader, "%dt", GetDateAndTime)
				sHeader = sHeader
		
				'Build The Body
		
				Dim i
				For i = 1 to Request.Form.Count
					
					If Not Request.Form.Key(i) = "recipient" And Not Request.Form.Key(i) = "redirect" And Not Request.Form.Key(i) = "subject" And Not Request.Form.Key(i) = "email" Then
						sBody = sBody & vbCRLF & Request.Form.Key(i) & ": " & Request.Form.Item(i) & vbCRLF
						
					End If
	
				Next
		
				'Build The Footer
				sFooter = csMailFooter & vbCRLF
		
				'Build the final EMail body
				sEMailBody = sHeader & sBody & sFooter
		
				bInError = False
		
				'Send the Email Message
				For iCounter = LBound(vRecipientList) to UBound(vRecipientList)
					If sendEMail(vRecipientList(iCounter), vRecipientList(iCounter), sSubject, sEMailBody) = False Then												
						bInError = True					
						Exit For
						
					End If
					
				Next

				If bInError = False Then
					'Redirect the browser to the final page
					Response.redirect sRedirect
					
				Else
					ReportBadSendCondition
					
				End If
				
			Else

				If Not bValidateReferer = True Then
					' Report dodgy Recipient				
					ReportBadReferer
					
				Else
					' Report dodgy Recipient
					ReportBadRecipient
				
				End If
				
			End If
			
		End Sub
		
		Sub ReportBadReferer
			%>
				<html>
				  <head>
				    <title>Bad Referrer - Access Denied</title>
				    <style type="text/css">
				    <!--
				       body {
				              background-color: #FFFFFF;
				              color: #000000;
				             }
				       p.c2 {
				              font-size: 80%;
				              text-align: center;
				            }
				       th.c1 {
				               text-align: center;
				               font-size: 143%;
				             }
				       p.c3 {font-size: 80%; text-align: center}
				       div.c2 {margin-left: 2em}
				     -->
				    </style>
				  </head>
				  <body>
				    <table border="0" width="600" bgcolor="#9C9C9C" summary="">
				      <tr bgcolor="#9C9C9C">
				        <th class="c1">Bad Referrer - Access Denied</th>
				      </tr>
				      <tr bgcolor="#CFCFCF">
				        <td>
				          <p>
							  The form attempting to use FormMail resides at <tt><%=Request.ServerVariables("HTTP_REFERER")%></tt>,
							  which is not allowed to access this script.
							</p>
							<p>
							  If you are attempting to configure FormMail to run with this form,
							  you need to add the following to vReferers.
							</p>
							<p>
							  Add <tt>'<%=sReferer%>'</tt> to your <tt><b>vReferers</b></tt> array.
							</p>

				          <hr size="1">
				          <p class="c3">
				            <a href="http://www.widagroup.net/">FormMail</a>&copy; 2002 Wida Group Limited
				          </p>
				        </td>
				      </tr>
				    </table>
				  </body>
				</html>
					
			<%		
		End Sub
		
		Sub ReportBadRecipient
			%>
				<html>
				  <head>
				    <title>Error: Bad or Missing Recipient</title>
				    <style type="text/css">
				    <!--
				       body {
				              background-color: #FFFFFF;
				              color: #000000;
				             }
				       p.c2 {
				              font-size: 80%;
				              text-align: center;
				            }
				       th.c1 {
				               text-align: center;
				               font-size: 143%;
				             }
				       p.c3 {font-size: 80%; text-align: center}
				       div.c2 {margin-left: 2em}
				     -->
				    </style>
				  </head>
				  <body>
				    <table border="0" width="600" bgcolor="#9C9C9C" summary="">
				      <tr bgcolor="#9C9C9C">
				        <th class="c1">Error: Bad or Missing Recipient</th>
				      </tr>
				      <tr bgcolor="#CFCFCF">
				        <td>
				          <p>
							  There was no recipient or an invalid recipient specified in the
							  data sent to FormMail. Please make sure you have filled in the
							  <tt>recipient</tt> form field with an e-mail address that has
							  been configured in <tt>vRecipients</tt>. 
						  </p>
						  <hr size="1">
						  <p>
							 The recipient was: [ <%=sRefusedAddress%> ]
  						  </p>
				          <hr size="1">
				          <p class="c3">
				            <a href="http://www.widagroup.net/">FormMail</a>&copy; 2002 Wida Group Limited
				          </p>
				        </td>
				      </tr>
				    </table>
				  </body>
				</html>
					
			<%
		
		End Sub
		
		Sub ReportBadSendCondition
			%>
				<html>
				  <head>
				    <title>Error: Sending Email from Server</title>
				    <style type="text/css">
				    <!--
				       body {
				              background-color: #FFFFFF;
				              color: #000000;
				             }
				       p.c2 {
				              font-size: 80%;
				              text-align: center;
				            }
				       th.c1 {
				               text-align: center;
				               font-size: 143%;
				             }
				       p.c3 {font-size: 80%; text-align: center}
				       div.c2 {margin-left: 2em}
				     -->
				    </style>
				  </head>
				  <body>
				    <table border="0" width="600" bgcolor="#9C9C9C" summary="">
				      <tr bgcolor="#9C9C9C">
				        <th class="c1">Error: Sending Email from Server</th>
				      </tr>
				      <tr bgcolor="#CFCFCF" align="middle">
				        <td>
						  <hr size="1">				        
				          <p>
							  An error was encountered attempting to send email
							  via Formmail from <tt>'<%=sReferer%>'</tt>. 
							  <br>
							  <br>	
							  Please contact the administrator at <tt>'<%=sReferer%>'</tt> and report the error. 
  						  </p>
						  <hr size="1">				        
				          <p class="c3">
				            <a href="http://www.widagroup.net/">FormMail</a>&copy; 2002 Wida Group Limited
				          </p>
				        </td>
				      </tr>
				    </table>
				  </body>
				</html>
					
			<%		
		End Sub
%>
