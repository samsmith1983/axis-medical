// Fix* for the IE Embedded Flash Issue - V1.1
// Copyright Wida Group Ltd
// by Matthew "Melek" Ellis
//
// Thanks go to Scott for his input re:css compliancy and accessibility
//
// Include me in your document Head (i.e. <script type="text/javascript" src="/scripts/ie_flash_fix.js"></script>) and call the
// function supplying the ID of the DIV that you want to contain the flash object.

function CreateFlashMovie(DivID,FlashID,FlashPath,VariableList){
	var oDiv=document.getElementById(DivID);
	var strHTML='';
	var strFlashID=FlashID;
	if(strFlashID.length>0){
		strFlashID=' id="'+strFlashID+'"';
	}

	strHTML+='<object type="application/x-shockwave-flash" data="'+FlashPath+'?'+VariableList+'"'+strFlashID+'>\n';
	strHTML+='<param name="movie" value="'+FlashPath+'?'+VariableList+'" />\n';
	strHTML+='<param name="allowScriptAccess" value="sameDomain" />\n';
	strHTML+='<param name="quality" value="high" />\n';
	strHTML+='<param name="wmode" value="transparent" />\n';
	strHTML+='</object>\n';

	oDiv.innerHTML=strHTML;
}

// * - not technically a fix but hey... no other browser has the issue
