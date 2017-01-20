function resizeWindow(){
	if(!document.images.length){document.images[0]=document.layers[0].images[0];}
	var oH=document.images[0].height+40,oW=document.images[0].width+24;
	if(!oH||window.doneAlready){return;} // if images are disabled, end the script
	window.doneAlready=true; //fixes onload issues with Opera and Safari
	if(oH<240){oH=240;} //stops window resizing less than 240px high
	if(oW<240){oW=240;} //I think you can guess...
	var x=window;x.resizeTo(oW+10,oH+10);
	var myW=0,myH=0,d=x.document.documentElement,b=x.document.body;
	if(x.innerWidth) //firefox
		{myW=x.innerWidth;myH=x.innerHeight;} // add negative values to increase size of box (!)
	else if(d&&d.clientWidth) //IE
		{myW=d.clientWidth;myH=d.clientHeight;}
	else if(b&&b.clientWidth) //God knows
		{myW=b.clientWidth;myH=b.clientHeight;}
	if(window.opera&&!document.childNodes){myW+=16;}
	x.resizeTo(oW=oW+((oW+10)-myW),oH=oH+((oH+10)-myH));
	x.focus();
}