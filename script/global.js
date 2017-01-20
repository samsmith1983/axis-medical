function checkqty(theForm,iMin,iMax) {
	var formOK=true;

	if(theForm.pq.value==''){
		alert('Please enter a quantity');
		theForm.pq.focus();
		formOK=false;
	}

	if(isNaN(theForm.pq.value)){
		if(formOK){
			alert('Quantity must be repesented as a number');
			theForm.pq.select();
		}
		formOK=false;
	}

	if(iMax>0&&(iMin!=iMax)){
		if(!(theForm.pq.value>=iMin&&theForm.pq.value<=iMax)){
			if(formOK){
				alert('Quantity must be no less than '+iMin+' and no more than '+iMax);
				theForm.pq.select();
			}
			formOK=false;
		}
	}
	else if(iMin!=iMax){
		if(theForm.pq.value<iMin){
			if(formOK){
				alert('Quantity must be no less than '+iMin);
				theForm.pq.select();
			}
			formOK=false;
		}
	}

	return formOK;
}