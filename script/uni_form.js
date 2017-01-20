//
// Universal Form Validation Script V1.9
//
// ©Copyright 2005 WidaGroup Ltd - All Rights Reserved
// www.widagroup.net

var arrFieldName=new Array();
var arrFieldType=new Array();
var arrFieldDescription=new Array();
var blnFormSubmitted=false;
var reCheck=new Object();
var objConfig=new Object();

// assign default validation types
settype('number',/^[\d\s\(\)\-\,\.]*$/);
settype('email',/^[a-zA-Z\d][^\(\)\<\>\@\,\;\:\\\[\]\"]*\@[a-zA-Z\d][a-zA-Z\d\-\.]*\.[a-zA-Z]{2,6}$/); //"
settype('postcode',/^[a-zA-Z]{1,2}\d{1,2}[a-zA-Z]?\s\d[a-zA-Z]{2}$/);
settype('ipaddress',/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/);
settype('date',/^[0123]?\d[\\\/\-\.][01]?\d[\\\/\-\.]\d{2,4}$/);
settype('url',/^(ht|f)tp(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&amp;%\$#_]*)?$/); //'
settype('name',/^[a-zA-Z][a-zA-Z\-\s\']*[a-zA-Z]$/); //'

// assign default config
setconfig('pass colour','');
setconfig('oneofmany colour','#eef5ff');
setconfig('fail colour','#ddeeff');
setconfig('oneofmany message','You need only fill in one of these details.');
setconfig('failed message','Please check the following details:');
setconfig('resubmit message','This form has already been submitted. Please reload the page and try again.');

function setvalidation(fieldnames,checktypes,fielddescription){arrFieldName=fieldnames;arrFieldType=checktypes;arrFieldDescription=fielddescription;}
function setconfig(strConfigName,strNewValue){objConfig[strConfigName.toLowerCase()]=strNewValue;}
function settype(strTypeName,strNewValue){reCheck[strTypeName]=strNewValue;}

function checkform(theForm){
	var arrFieldValues=new Array();
	var arrCheckTypeDatas=new Array();
	
	if(blnFormSubmitted){
		alert(objConfig['resubmit message'])
		return false;
	}else{
		var strMessage='';
		var blnOneOfManyPresent=false;
		
		for(n=0;n<arrFieldName.length;n++){
			if(typeof(theForm[arrFieldName[n]])=='undefined'){
				arrFieldName.splice(n,1);
				arrFieldType.splice(n,1);
				arrFieldDescription.splice(n,1);
				n--;
			}
		}
		
		for(n=0;n<arrFieldName.length;n++){
			var blnFieldCollectionLength=theForm[arrFieldName[n]].length?theForm[arrFieldName[n]].length:0;

			arrFieldValues[n]='';
			arrCheckTypeDatas[n]=arrFieldType[n].split(',')

			if(blnFieldCollectionLength==0){
				arrFieldValues[n]=theForm[arrFieldName[n]].value;
			}else{
				if(theForm[arrFieldName[n]].options){
					arrFieldValues[n]=theForm[arrFieldName[n]].options[theForm[arrFieldName[n]].selectedIndex].value;
				}else{
					for(var i=0;i<blnFieldCollectionLength;i++){
						if(theForm[arrFieldName[n]][i].checked){
							arrFieldValues[n]+=theForm[arrFieldName[n]][i].value+',';
						}
					}
					arrFieldValues[n]=arrFieldValues[n].substr(0,arrFieldValues[n].length-1);
				}
			}
		}
		
		for(n=0;n<arrFieldName.length;n++){
			var intCheckResult=check_all(arrFieldValues,n,arrCheckTypeDatas);
			var blnFieldCollectionLength=theForm[arrFieldName[n]].length?theForm[arrFieldName[n]].length:0;

			switch(intCheckResult){
			case 0: // failed
				if(strMessage==''){theForm[arrFieldName[n]].focus();}

				strMessage+=' - '+arrFieldDescription[n]+'\n';
				
				setfieldcolour(theForm[arrFieldName[n]],blnFieldCollectionLength,objConfig['fail colour']);
			break;
			case 1: // failed and is oneofmany where none passed
				if(strMessage==''){theForm[arrFieldName[n]].focus();}

				strMessage+=' - '+arrFieldDescription[n]+' *\n';
				blnOneOfManyPresent=true;
				
				setfieldcolour(theForm[arrFieldName[n]],blnFieldCollectionLength,objConfig['oneofmany colour']);
			break;
			case 2: // passed or is one of many where one or more passed
				setfieldcolour(theForm[arrFieldName[n]],blnFieldCollectionLength,objConfig['pass colour']);
			break;
			}
		}
		
		blnFormSubmitted=(strMessage=='');
		
		if(blnOneOfManyPresent){strMessage+='\n* '+objConfig['oneofmany message']}
		
		if(!blnFormSubmitted){alert(objConfig['failed message']+'\n\n'+strMessage);}
		
		return blnFormSubmitted;
	}

}

function setfieldcolour(strFieldName,blnFieldCollectionLength,strNewColour){
	if(blnFieldCollectionLength==0){
		strFieldName.style.backgroundColor=strNewColour;
	}else{
		if(strFieldName.options){
			strFieldName.style.backgroundColor=strNewColour;
			for(var i=0;i<blnFieldCollectionLength;i++){
				strFieldName.options[i].style.backgroundColor=strNewColour;
			}
		}else{
			for(var i=0;i<blnFieldCollectionLength;i++){
				strFieldName[i].style.backgroundColor=strNewColour;
			}
		}
	}
}

function check_all(arrFieldValues,n,arrCheckTypeDatas){
	var strTemp='';
	
	if(checkstringtype(arrFieldValues[n],arrCheckTypeDatas[n][0]) && checkstringlength(arrFieldValues[n],arrCheckTypeDatas[n][1],arrCheckTypeDatas[n][2])){
		if(arrCheckTypeDatas[n][3]=='repeat'){
			if (arrFieldValues[n]!=arrFieldValues[n-1]){
				return 0;
			}
		}
		return 2;
	}else{
		if(arrCheckTypeDatas[n][3]=='oneofmany'){
			for(var m=0;m<arrFieldName.length;m++){
				if(arrCheckTypeDatas[m][3]==arrCheckTypeDatas[n][3]){
					if(checkstringtype(arrFieldValues[m],arrCheckTypeDatas[m][0]) && checkstringlength(arrFieldValues[m],arrCheckTypeDatas[m][1],arrCheckTypeDatas[m][2])){
						return 2;
					}
				}
			}
			return 1;
		}
		return 0;
	}
}

function checkstringtype(strString,strCheckType){return (strCheckType=='' || strString=='' || reCheck[strCheckType].test(strString));}
function checkstringlength(strString,intMinimum,intMaximum){return (!intMinimum || strString.length>=intMinimum) && (!intMaximum || strString.length<=intMaximum);}

//End of Universal Form Validation Script