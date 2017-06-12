 ;csp.beddproc.1
 ;(C)InterSystems, generated for class csp.beddproc.  Do NOT edit. 04/14/2017 08:47:51AM
 ;;47694E71;csp.beddproc
 ;
zMyXdate(rawDtTm)
 	Set val=$$XDATE^BEDDUTID(rawDtTm)
 	Quit val
zOnPage()
	Do ..OnPagePREHTML()
	Do ..OnPageCSPROOT()
	Do ..OnPagePOSTHTML()
	Quit 1
zOnPageBODY()
	Write "<BODY bgcolor=""#CCCCFF"" onload=""setFocus()"">"
	Write !,!,"<!-- use CSP:OBJECT tag to create a reference to an instance of the class -->"
	Write !
	If ((%request.Get("OBJID"))'="") {
	Set objForm = ##class(BEDD.EDProc).%OpenId((%request.Get("OBJID")))
	} Else {
	Set objForm = ##class(BEDD.EDProc).%New()
	}
	Write !
	If ((%request.Get("EDVISITID"))'="") {
	Set vstForm = ##class(BEDD.EDVISIT).%OpenId((%request.Get("EDVISITID")))
	} Else {
	Set vstForm = ##class(BEDD.EDVISIT).%New()
	}
	Write !,!,"<form name=""form"" onsubmit='return form_validate();' method=""get"">"
	Write !,..InsertHiddenFields(""),!
	Write !,!
	Set proc=objForm.EDProc
	Set prstf=objForm.ProcStf
	Set U="^"
	Set objid=%request.Get("OBJID")
	Set (dfn,ptdfn)=vstForm.PtDFN
	Set %session.Data("DFN")=dfn
	Set vien=vstForm.VIEN
	//Audit the activity
	Do LOG^BEDDUTIU(%session.Data("DUZ"),"P","Q","BEDDPROC.csp","BEDD: User displayed patient procedure information",dfn)
	//
	//Name and Gender
	Set ptname=vstForm.PtName
	Set ptsex=vstForm.Sex
	//
	//DOB, Age and Chart
	Set ptdob=vstForm.DOB
	Set ptage=vstForm.Age
	Set ptchart=vstForm.Chart
	//
	//Admission Information
	Set ptcidt=vstForm.PtCIDT
	Write !,!,"<center>",!
	Write !,"<center><b><font size=6>ED Procedure Worksheet</font></b></center>",!
	Write "<br>",!
	Write !,"<label for=""PtName"">Patient (Gender)</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtName"" value='"_(ptname)_" ("_(ptsex)_")' size=""40"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""PtDOB"">DOB (Age)</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtDOB"" value='"_(ptdob)_" ("_(ptage)_")' size=""25"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""PtChart"">Chart</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtChart"" value='"_(ptchart)_"' size=""8"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp; &nbsp;",!
	Write "<input type=""button"" name=""btnClose"" style=""width:100px;height:25px"" value=""Close"" onclick='closePage();'>"
	Write !,!,"<hr>",!
	Write "<br>",!
	Write !,"<table border=1 bgcolor="""" width=""80%"">",!
	Write "		<tr>",!
	Write "			<td><b>Procedure</b></td>",!
	Write "			<td><b>Staff</b></td>",!
	Write "			<td><b>Start Date & Time</b></td>",!
	Write "			<td><b>End Date & Time</b></td>",!
	Write "		</tr>",!
	Write "				",!
	// Open instance of ResultSet for runtime mode of DISPLAY.
	Set VuProc = ##class(%Library.ResultSet).%New()
	Set VuProc.RuntimeMode=2
	Set sqlStatement=$zstrip($tr($c(13,10,9)_"SELECT ID,EDProc,EDProcN,ProcStfN,ProcDt,ProcSTm,ProcEDt,ProcETm,ProcTime FROM BEDD.EDProc"_$c(13,10,9)_"Where (EDVISITID = :edvisitid) "_$c(13,10),$C(9,13,10),"   "),"<>W")
	If $zcvt($extract(sqlStatement,1,6),"U")'="SELECT" {
	Do ..ShowError($$Error^%apiOBJ(5982,"247"))
	Quit
	}
	// translate tab/cr/nl to spaces
	Set %sc = VuProc.Prepare(sqlStatement,0,"RUNTIME")
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Set %sc = VuProc.Execute()
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Write !,"	"
%csp00002	If '(VuProc.Next()) Goto %csp00001 ;{
	Write !,"	  <tr>",!
	Write "	  	<td>"
	Write "<a href="""_($zconvert(..Link("javascript:editItem("_(VuProc.Get("ID"))_");"),"O","HTML"))_""">"
	Write (VuProc.Get("EDProcN"))
	Write "</a>"
	Write "</td>",!
	Write "	  	<td>"_(VuProc.Get("ProcStfN"))_"</td>",!
	Write "	  	<td>"_(VuProc.Get("ProcDt"))_" &nbsp; "_(VuProc.Get("ProcSTm"))_"</td>",!
	Write "	  	<td>"_(VuProc.Get("ProcEDt"))_" &nbsp; "_(VuProc.Get("ProcETm"))_"</td>",!
	Write "	  </tr>",!
	Write "	"
	Goto %csp00002
%csp00001	;}
	Write !,"	</table>",!
	Write !
	Set %value = $zconvert($get(%request.Data("text3",1),$ZSTRIP($select(objForm="":"",1:(objForm.%Id())),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""text3"" id=""text3"">"
	Write !,"<input type=""hidden"" name=""PTDFN"" id=""PTDFN"" value="_(dfn),">"
	Write !
	Set %value = $zconvert($get(%request.Data("DFN",1),$ZSTRIP($select(objForm="":"",1:(objForm.DFNLogicalToDisplay(objForm.DFN))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""DFN"" id=""DFN"" size=""10"">"
	Write !
	Set %value = $zconvert($get(%request.Data("EDVISITID",1),$ZSTRIP($select(objForm="":"",1:(objForm.EDVISITIDLogicalToDisplay(objForm.EDVISITID))),">W")),"O","HTML")
	Write "<input type=""hidden"" name=""EDVISITID"" id=""EDVISITID"" size=""10"" value='"_(%value)_"'>"
	Write !,"<input name=""%noname"" type=""hidden"" id=""AStmp"" value='"_(ptcidt)_"' readonly/>"
	Write " ",!
	Write !,"<br><br>",!
	Write "	"
	Write "<input type=""hidden"" name=""proci"" id=""proci"" size=""5"" value="_(proc),">"
	Write !,"	"
	Write "<input type=""hidden"" name=""ProcId"" id=""ProcId"" value="""">"
	Write !,"<table border=""1"" width=""70%"">",!
	Write "	<tr>",!
	Write "	<td><b>*Procedure:</b></td>",!
	Write "	<td> ",!
	Write "		"
	Write "<input name=""%noname"" type=""hidden"" id=""Procedure"" value="""">"
	Write !,"		"
	Write "<select id=""edproc"" name=""edproc"">"
	Write !,"			"
	Do PROC^BEDDUTIU(.proc)
	Write "<option> </option>",! 
	Set proc=$O(proc(""))
	While (+proc'=0) {
	Write "<option value="""_($P(proc(proc),"^"))_"""> "_($P(proc(proc),"^",2))_"  </option>",! 
	Set proc=$O(proc(proc))
	}
	Write !,"		"
	Write "</select>"
	Write !,"	</td>",!
	Write "	</tr>",!
	Write "	<tr>",!
	Write "	<td> "
	Write "<input type=""hidden"" id=""prstfi"" name=""prstfi"" size=""5"" value="_(prstf),">"
	Write !,"		<b>Staff for Procedure:</b>",!
	Write "	</td>",!
	Write "	<td>",!
	Write "		"
	Write "<input name=""%noname"" type=""hidden"" id=""Provider"" value="""">"
	Write !,"		"
	Write "<select id=""procstf"" name=""procstf"">"
	Write !,"			"
	Do PROV^BEDDUTID(.prov)
	Write "<option> </option>",! 
	Set prov=$O(prov(""))
	While (+prov'=0) {
	Write "<option value="""_($P(prov(prov),"^"))_"""> "_($P(prov(prov),"^",2))_"  </option>",! 
	Set prov=$O(prov(prov))
	}
	Write !,"		"
	Write "</select>"
	Write !,"	</td>",!
	Write "	</tr>",!
	Write "	<tr>",!
	Write "	<td><b>Start Date & Time:</b></td>",!
	Write "	<td>"
	Write "<input type=""text"" name=""StartDtTm"" id=""StartDtTm"" size=""20"" onblur='doDateCheck(""StartDtTm"");'>"
	Write !,"	</td>",!
	Write "	</tr>",!
	Write "	<tr>",!
	Write "	<td><b>End Date & Time:</b></td>",!
	Write "	<td>"
	Write "<input type=""text"" name=""EndDtTm"" id=""EndDtTm"" size=""20"" onblur='doDateCheck(""EndDtTm"");'>"
	Write !,"	</td>",!
	Write "	</tr>",!
	Write "</table>",!
	Write !,"<br><br>",!
	Write "<i>*Enter the letter ""N"" in the date fields to auto-populate the current date and time</i>",!
	Write "<br>",!
	Write !,"<br><br>General Information/Notes: ",!
	Write "	<br>"
	Write "<textarea name=""Info"" id=""Info"" cols=""85"" rows=""3"">"
	Write $select($data(%request.Data("Info",1)):$zconvert(%request.Data("Info",1),"O","HTML"),1:$zconvert($select(objForm="":"",1:(##class(%CSP.DwxUtils).EscapeStream(objForm.ProcNotes,"HTML"))),"O","HTML"))
	Write "</textarea>"
	Write !,!,"<br><br>"
	Write "<input type=""button"" name=""btnSave"" style=""width:100px;height:25px"" value=""Save"" onclick='saveItem();'>"
	Write !,"&nbsp; "
	Write "<input type=""button"" name=""btnDel"" style=""width:100px;height:25px"" value=""Delete"" onclick='deleteItem();'>"
	Write !,"&nbsp; "
	Write "<input type=""button"" name=""btnClose"" style=""width:100px;height:25px"" value=""Close"" onclick='closePage();'>"
	Write !,!,"</center>",!
	Write !,"<input id=""OBJID"" name=""OBJID"" type=""hidden"" value="""_($select(objForm="":"",1:objForm.%Id()))_""">"
	Write "</form>"
	Write !,!,!,!,!,!,!,!,!,!,!,!,!,!,"</BODY>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDDPROC.csp - BEDD ED Procedure Page -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;;Apr 02, 2014 -->"
	Write !
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<HEAD>"
	Write !,!
	Set U="^",site=%session.Data("SITE")
	Do LOADSYS^BEDDUTW(.beddsys,site)
	Set timeout=$G(beddsys("TimeOut"))
	Write !,!,"<META HTTP-EQUIV=""Refresh"" CONTENT="""_( timeout )_"; URL=BEDD.csp"">"
	Write !,!,"<TITLE>	ED Procedures </TITLE>",!
	Write "	"
	S edvisitid=%request.Get("EDVISITID") S %session.Data("EDVISITID")=edvisitid
	S dfn=%request.Get("DFN") S %session.Data("DFN")=dfn
	Write !,"<SCRIPT language=""JavaScript"">"
	Write !,"function saveItem() {",!
	Write "	submitOK=""true"";",!
	Write "		",!
	Write "	<!--Procedure-->",!
	Write "	var iact = document.getElementById('edproc');",!
	Write "	if (iact.value=="""") {",!
	Write "	alert(""Procedure is Required"");",!
	Write "	submitOK=""false"";",!
	Write "	}",!
	Write !," 	<!--Check for Procedure NONE-->",!
	Write " 	var none = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getPrNONE"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',iact.value) ;",!
	Write !,"	<!--Perform other checks if not NONE-->",!
	Write "	if (none==0) {",!
	Write "		<!--Staff for Procedure-->",!
	Write "		var iact = document.getElementById('procstf');",!
	Write "		if (iact.value=="""") {",!
	Write "			<!--alert(""Staff for Procedure Required"");-->",!
	Write "			<!--submitOK=""false"";-->",!
	Write "		}",!
	Write "	",!
	Write "		<!--Start Date and Time Check-->",!
	Write "		var csdt = document.getElementById('StartDtTm');",!
	Write "		if (csdt.value=="""") {",!
	Write "			<!--alert(""Start Date/Time is Required"");-->",!
	Write "			<!--submitOK=""false"";-->",!
	Write "		}",!
	Write "		if (csdt.value.length>0) {",!
	Write "			if (csdt.value.length<11) {",!
	Write "				alert(""If entering Start Date and Time - Both Date and Time Must Be Entered"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (csdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',csdt.value,admdt.value,""AF"") ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future Start Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""Start Date/Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "		",!
	Write "		<!--End Date and Time Check-->",!
	Write "		<!--Make time required if date entered-->",!
	Write "		var csdt = document.getElementById('EndDtTm');",!
	Write "		var bgdt = document.getElementById('StartDtTm');",!
	Write "		if (csdt.value.length>0) {",!
	Write "			if (csdt.value.length<11) {",!
	Write "				alert(""If entering End Date and Time - Both Date and Time Must Be Entered"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (csdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',csdt.value,admdt.value,""AFB"",bgdt.value) ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future End Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""End Date/Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""B"") {",!
	Write "					alert(""End Date/Time must be after Beginning Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "	}",!
	Write !,"	if (submitOK==""true"") {",!
	Write "		",!
	Write "		var x0 = document.getElementById(""PTDFN"");",!
	Write "		var x1 = document.getElementById(""edproc"");",!
	Write "		var x2 = document.getElementById(""procstf"");",!
	Write "		var x3 = document.getElementById(""StartDtTm"");",!
	Write "		var x4 = document.getElementById(""EndDtTm"");",!
	Write "		var x5 = document.getElementById(""Info"");",!
	Write "		var myProcID=document.form.ProcId.value;",!
	Write "		var myVisId=document.form.EDVISITID.value;",!
	Write "		",!
	Write "		// Need to get the Procedure and the provider from the select lists",!
	Write "		var ProcIdx = x1.selectedIndex;",!
	Write "    	var Procedure = x1.options[ProcIdx].value;",!
	Write "    	var ProvIdx = x2.selectedIndex;",!
	Write "    	var Provider = x2.options[ProvIdx].value;",!
	Write "    	",!
	Write "    	if (Procedure != """") {",!
	Write "			"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".updateProc"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myProcID,Procedure,Provider,x3.value,x4.value,myVisId,x0.value,x5.value) ;",!
	Write "    	} else {",!
	Write "	    	alert(""Save not performed because Procedure is missing"");",!
	Write "    	}",!
	Write "    	",!
	Write "		location.reload(true);",!
	Write "	}",!
	Write "}",!
	Write "	",!
	Write "	function editItem(mydata1) {",!
	Write "		",!
	Write "		// Save this id so we can call the record directly",!
	Write "		document.form.ProcId.value = mydata1;",!
	Write "		",!
	Write "		// Populate the fields so that they can be edited",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".editProc"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',mydata1) ;",!
	Write "	}",!
	Write "	",!
	Write "	function deleteItem() {",!
	Write "		var mydata1 = document.form.ProcId.value ;",!
	Write "		",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".delProc"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',mydata1) ;",!
	Write "		",!
	Write "		location.reload(true);",!
	Write "	}",!
	Write !,"	function closePage(){",!
	Write "		//self.document.location = """_(%request.Get("Page"))_"?OBJID="" + "_(%session.Data("EDVISITID"))_" + ""&DFN="" + "_(%session.Data("DFN"))_" ;",!
	Write "		self.document.location = ""BEDDEDIT1.csp?OBJID="_(edvisitid)_"&DFN="_(%session.Data("DFN"))_""" ;",!
	Write !,"	}",!
	Write "	",!
	Write "	function setProcN() {",!
	Write "		var x0 = document.getElementById(""edproc"");	/// cspbind ",!
	Write "		var x1 = document.form.Procedure.value ;		/// value of cspbind",!
	Write "			for (i=0; i<x0.options.length; i++){",!
	Write "				if (x0.options[i].value == x1) {",!
	Write "					x0.selectedIndex = i ;",!
	Write "					}",!
	Write "				}",!
	Write "		}",!
	Write "	",!
	Write "	function setProcStf() {",!
	Write "		var x0 = document.getElementById(""procstf"");",!
	Write "		var x1 = document.form.Provider.value ;",!
	Write "			for (i=0; i<x0.options.length; i++){",!
	Write "				if (x0.options[i].value == x1) {",!
	Write "					x0.selectedIndex = i ;",!
	Write "					}",!
	Write "				}",!
	Write "		}",!
	Write "	",!
	Write "	function setFocus() {",!
	Write "		setProcN();",!
	Write "		setProcStf();",!
	Write "	}",!
	Write "	",!
	Write "	function doDateCheck(myElement)	{",!
	Write "		var my_info = document.getElementById(myElement);",!
	Write "		var my_datetm = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',my_info.value) ;",!
	Write "		if (my_datetm == -1) {",!
	Write "			//We got an error from the function leave the cursor on this element",!
	Write "			my_info.value="""";",!
	Write "			my_info.focus();",!
	Write "		} else {",!
	Write "			my_info.value=my_datetm;",!
	Write "		}",!
	Write "	}	",!
	Write "</SCRIPT>"
	Do ..formGenJS()
	Write !,(..HyperEventHead(0,0))
	Write !,"</HEAD>"
	Quit
zOnPageHTML()
	Write "<HTML>"
	Write !
	Do ..OnPageHEAD()
	Write !,!
	Do ..OnPageBODY()
	Write !,"</HTML>"
	Quit
zOnPagePOSTHTML()
	Set objForm=""
	Set vstForm=""
	Set VuProc=""
	Quit
zOnPagePREHTML()
	Set objForm=""
	Set vstForm=""
	Set VuProc=""
	Quit
zdelProc(objid)
 	Quit:objid=""
 	//Audit the activity
 	Do LOG^BEDDUTIU(%session.Data("DUZ"),"P","D","BEDDPROC.csp","BEDD: User deleted patient procedure information",$G(%session.Data("DFN")))
 	Set dstatus=##class(BEDD.EDProc).%DeleteId(objid)
 	Write "alert('Procedure deleted');",! 
 	Quit
zeditProc(ProcID)
 	Set myobj=##class(BEDD.EDProc).%OpenId(ProcID)
 	Set myStartdt=$TR($$HTE^XLFDT(myobj.ProcDt_","_myobj.ProcSTm,"5T"),"@"," ")
 	If myStartdt="," {
 		Set myStartdt=""
 	}
 	Set myEnddt=$TR($$HTE^XLFDT(myobj.ProcEDt_","_myobj.ProcETm,"5T"),"@"," ")
 	If myEnddt="," {
 		Set myEnddt=""
 	}
 	Set PNsize=myobj.ProcNotes.SizeGet() Set PNinfo=myobj.ProcNotes.Read(PNsize)
 	Write " ",!
	Write " 		CSPPage.document.form.Procedure.value = "_(..QuoteJS(myobj.EDProc))_" ;",!
	Write " 		CSPPage.document.form.Provider.value = "_(..QuoteJS(myobj.ProcStf))_" ;",!
	Write " 		CSPPage.document.form.StartDtTm.value = "_(..QuoteJS(myStartdt))_" ;",!
	Write " 		CSPPage.document.form.EndDtTm.value = "_(..QuoteJS(myEnddt))_" ;",!
	Write " 		CSPPage.document.form.Info.value = "_(..QuoteJS(PNinfo))_" ;",!
	Write " 		setProcN();",!
	Write " 		setProcStf();",!
	Write " 	",! 
 	Set myobj=""
 	Quit
zformGenJS()
	Write !,"<script language=""JavaScript"" type=""text/javascript"">",!
	Write "<!--",!
	Write "function form_new()",!
	Write "{",!
	Write "   // invoke #server(csp.beddproc.formLoad())",!
	Write "   return ("_"cspHttpServerMethod"_"('",..Encrypt($listbuild("csp.beddproc.formLoad"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""),"','') == 1);",!
	Write "}",!
	Write "function form_save()",!
	Write "{",!
	Write "   var form = self.document.form;",!
	Write "   var objid = form.OBJID.value;",!
	Write "   var result = 0;",!
	Write "   if (form_validate()) {",!
	Do ..formSavJS()
	Write "   }",!
	Write "   return (result == 1);",!
	Write "}",!
	Write "function form_validate()",!
	Write "{",!
	Write "   var errorMsg = '';",!
	Write "   var missingMsg = '';",!
	Write "   var invalidMsg = '';",!
	Write "   var missingArray = new Array();",!
	Write "   var invalidArray = new Array();",!
	Write "   var valid;",!
	Write "   missingMsg = form_testRequired(missingArray);",!
	Write "   invalidMsg = form_testValid(invalidArray);",!
	Write "   if ((missingMsg == '') && (invalidMsg == '')) {",!
	Write "      return true;",!
	Write "   }",!
	Write "   errorMsg   = "_..QuoteJS(%response.GetText("","%CSPBind","SaveErrorLine","_______________________________________________________________"))_"+'\n\n';",!
	Write "   errorMsg  += "_..QuoteJS(%response.GetText("","%CSPBind","SaveError","The form was not saved because of the following error(s)."))_"+'\n';",!
	Write "   errorMsg  += "_..QuoteJS(%response.GetText("","%CSPBind","SaveCorrect","Please correct these error(s) and try again."))_"+'\n';",!
	Write "   errorMsg  += "_..QuoteJS(%response.GetText("","%CSPBind","SaveErrorLine","_______________________________________________________________"))_"+'\n\n';",!
	Write "   if (missingMsg!= '') {",!
	Write "      errorMsg += "_..QuoteJS(%response.GetText("","%CSPBind","SaveRequiredError","The following required field(s) are empty: "))_" + missingMsg + '\n';",!
	Write "   }",!
	Write "   if (invalidMsg != '') {",!
	Write "      errorMsg += "_..QuoteJS(%response.GetText("","%CSPBind","SaveInvalidError","The following field(s) contain invalid values: "))_" + invalidMsg + '\n';",!
	Write "   }",!
	Write "   alert(errorMsg);",!
	Write "   return false;",!
	Write "}",!
	Write "function form_testRequired(missingArray)",!
	Write "{",!
	Write "   var missingMsg = '';",!
	Do ..formReqJS()
	Write "   return missingMsg;",!
	Write "}",!
	Write "function form_testValid(invalidArray)",!
	Write "{",!
	Write "   var valid;",!
	Write "   var invalidMsg = '';",!
	Do ..formValJS()
	Write "   return invalidMsg;",!
	Write "}",!
	Write "// -->",!
	Write "</script>",!
	Quit
zformLoad(objid,obj="")
	If '..formLoadJS(.objid,obj) {
		Write "CSPPage.alert("_..QuoteJS("formLoad: "_%response.GetText("","%CSPBind","OpenObjectError","Unable to open object."))_");",!
		Do ..formLoadJS(objid,obj,1)
	}
	Quit 1
zformLoadJS(objid,obj="",alwaysLoad=0)
	New close,ok
	Set close=0,ok=1
	If (obj'="") {
		Set objid = obj.%Id()
	} Else {
		If (objid'="") {
			Set obj = ##class(BEDD.EDProc).%OpenId(objid)
		} Else {
			Set obj = ##class(BEDD.EDProc).%New()
		}
		If (obj="") {
			If 'alwaysLoad Quit 0
			Set ok=0
		} Else {
			Set close=1
		}
	}
	Write "var form = CSPPage.document.form;",!
	Write "if (form.text3 != null && form.text3 != null) { form.text3.value = ",..QuoteJS($select(obj="":"",1:(obj.%Id()))),";}",!
	Write "if (form.DFN != null && form.DFN != null) { form.DFN.value = ",..QuoteJS($select(obj="":"",1:($select(obj.DFN=$c(0):"",1:(obj.DFNLogicalToDisplay(obj.DFN)))))),";}",!
	Write "if (form.EDVISITID != null && form.EDVISITID != null) { form.EDVISITID.value = ",..QuoteJS($select(obj="":"",1:($select(obj.EDVISITID=$c(0):"",1:(obj.EDVISITIDLogicalToDisplay(obj.EDVISITID)))))),";}",!
	Write "if (form.edproc != null && form.edproc != null) { CSPPage.cspSetSelectValue(form.edproc, ",..QuoteJS($select(obj="":"",1:($select(obj.EDProc=$c(0):"",1:(obj.EDProcLogicalToDisplay(obj.EDProc)))))),");}",!
	Write "if (form.procstf != null && form.procstf != null) { CSPPage.cspSetSelectValue(form.procstf, ",..QuoteJS($select(obj="":"",1:($select(obj.ProcStf=$c(0):"",1:(obj.ProcStfLogicalToDisplay(obj.ProcStf)))))),");}",!
	Write "if (form.Info != null && form.Info != null) { form.Info.value = ",..QuoteJS($select(obj="":"",1:(##class(%CSP.DwxUtils).EscapeStream(obj.ProcNotes,"JS")))),";}",!
	Write "if (form.OBJID != null) { form.OBJID.value = ",..QuoteJS(objid),";}",!
	If close=1 Set obj=""
	Quit ok
zformReqJS()
	Write "   if (cspIsFieldEmpty('form','EDVISITID')) {",!
	Write "      missingMsg = missingMsg + '\n     EDVISITID';",!
	Write "      if (missingArray != null) { missingArray[missingArray.length] = 'EDVISITID'; }",!
	Write "   }",!
	Quit
zformSavJS()
	Write "      //invoke #server(csp.beddproc.formSave())"
	Write !,"      result = "_"cspHttpServerMethod"_"('",..Encrypt($listbuild("csp.beddproc.formSave"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""),"',1,'',objid"
	Write ",",!,"         (form.DFN == null || form.DFN == null) ? null : cspTrim(form.DFN.value)" ;%in1
	Write ",",!,"         (form.EDVISITID == null || form.EDVISITID == null) ? null : cspTrim(form.EDVISITID.value)" ;%in2
	Write ",",!,"         cspGetSelectValue(form.edproc)" ;%in3
	Write ",",!,"         cspGetSelectValue(form.procstf)" ;%in4
	Write ",",!,"         (form.Info == null || form.Info == null) ? null : cspNormalizeString(form.Info.value)" ;%in5
	Write ");",!
	Quit
zformSave(respond=0,errmsg="",objid="",%in1,%in2,%in3,%in4,%in5)
	New obj,sc,value,in,error,sverror,err,i,ok
	Set sc=1
	Set ok=1
	Set error=""
	Set sverror=""
	If (objid="") {
		Set obj = ##class(BEDD.EDProc).%New()
	} ElseIf '$isobject(objid) {
		Set obj = ##class(BEDD.EDProc).%OpenId(objid)
	} Else {
		Set obj = objid
	}
	If (obj="") {
		If (respond) {
			Write "CSPPage.alert("_..QuoteJS(%response.GetText("","%CSPBind","SaveObjectError","Unable to open object for saving"))_");",!
		} Else {
			Set errmsg = %response.GetText("","%CSPBind","SaveObjectError","Unable to open object for saving")
		}
		Quit 0
	}
	Try {
 ; DFN 
 If $data(%in1) {
   Set value=$select(%in1="":"",1:##class(BEDD.EDProc).DFNDisplayToLogical(%in1))
   If (%in1'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","DFN")_"\n"
   } Else {
     Set obj.DFN=value
   }
 }
 ; EDVISITID 
 If $data(%in2) {
   Set value=$select(%in2="":"",1:##class(BEDD.EDProc).EDVISITIDDisplayToLogical(%in2))
   If (%in2'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","EDVISITID")_"\n"
   } Else {
     Set obj.EDVISITID=value
   }
 }
 ; EDProc 
 If $data(%in3) {
   Set value=$select(%in3="":"",1:##class(BEDD.EDProc).EDProcDisplayToLogical(%in3))
   If (%in3'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","edproc")_"\n"
   } Else {
     Set obj.EDProc=value
   }
 }
 ; ProcStf 
 If $data(%in4) {
   Set value=$select(%in4="":"",1:##class(BEDD.EDProc).ProcStfDisplayToLogical(%in4))
   If (%in4'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","procstf")_"\n"
   } Else {
     Set obj.ProcStf=value
   }
 }
 ; ProcNotes 
 If $data(%in5) {
   Do obj.ProcNotes.Rewind()
   If $isobject(%in5) {
     Do %in5.Rewind()
     While '%in5.AtEnd {
       Do obj.ProcNotes.Write(%in5.Read(16000))
     }
   } Else {
     Do obj.ProcNotes.Write(%in5)
   }
 }
	Set:error'="" ok=0
	Set:error="" sc=obj.%Save()
	} Catch ex {
		Set ok=0
		If ($classname(ex)'="%Exception.SystemException") || (ex.Name'="<MAXSTRING>") || (error="") {
			Set sc=ex.AsStatus(),error=""
		}
	}
	If ('sc) {
		Set ok=0
		Do DecomposeStatus^%apiOBJ(sc,.err,"",%response.MatchLanguage())
		For i=1:1:err {
			If (respond) {
				Set sverror=sverror_" + "_..QuoteJS(err(i))_" + '\n'"
			} Else {
				Set sverror=sverror_..EscapeHTML(err(i))_"\n"
			}
		}
	}
	If (respond) {
		If (ok) {
			Do ..formLoad("",obj)
		} Else {
			Write "CSPPage.alert(",!
			Write ..QuoteJS(%response.GetText("","%CSPBind","SaveErrorLine","_______________________________________________________________"))_"+'\n\n'+",!
			Write ..QuoteJS(%response.GetText("","%CSPBind","SaveError","The form was not saved because of the following error(s)."))_"+'\n'+",!
			Write ..QuoteJS(%response.GetText("","%CSPBind","SaveCorrect","Please correct these error(s) and try again."))_"+'\n'+",!
			Write ..QuoteJS(%response.GetText("","%CSPBind","SaveErrorLine","_______________________________________________________________"))_"+'\n\n'+",!
			Write "'",error,"'",sverror,");",!
		}
	} Else {
		Set errmsg=..EscapeHTML(error)_sverror
	}
	Quit ok
zformSubmit(errmsg="",objid)
 New v
 Set v("DFN")=$ZSTRIP($get(%request.Data("DFN",1)),">W")
 Set v("EDVISITID")=$ZSTRIP($get(%request.Data("EDVISITID",1)),">W")
 Set v("EDProc")=$get(%request.Data("edproc",1))
 Set v("ProcStf")=$get(%request.Data("procstf",1))
 Set v("ProcNotes")=$get(%request.Data("Info",1))
	If $get(objid)="" Set objid=$get(%request.Data("OBJID",1))
	Quit ..formSave(0,.errmsg,objid,v("DFN"),v("EDVISITID"),v("EDProc"),v("ProcStf"),v("ProcNotes"))
zformValJS()
	Quit
zgetDtChk(date,admdt,chk,bgdt)
 Quit $$DTCHK^BEDDUTIU(date,admdt,chk,$G(bgdt))
zgetPrNONE(proc)
 	Set val=$$GETF^BEDDUTIL(9009083,proc,".01","I")
 	If val="NONE" {
 		Quit 1
 	}
 	Quit 0
zupdateProc(objid,myProcedure,myProvider,myStartDtTm,myEndDtTm,myvisitid,myptdfn,mynote)
 	//Audit the activity
 	Do LOG^BEDDUTIU(%session.Data("DUZ"),"P","E","BEDDPROC.csp","BEDD: User edited patient procedure information",$G(%session.Data("DFN")))
 	Set newobj="",message=""
 	If (objid]"") {
 		//Update this object
 		Set newobj=##class(BEDD.EDProc).%OpenId(objid)
 		Set message="Procedure has been updated"
 	}
 	else { // New object to add to Diagnosis list
 		Set newobj=##class(BEDD.EDProc).%New()
 		Set message="Procedure has been added"
 	} 
 	// Get Date & Time in $H format for saving
 	Set myHstart=$$TODLH^BEDDUTIL($P(myStartDtTm," ",1)_"@"_$P(myStartDtTm," ",2))
 	Set myHend=$$TODLH^BEDDUTIL($P(myEndDtTm," ",1)_"@"_$P(myEndDtTm," ",2))
 	Set newobj.EDVISITID=myvisitid,newobj.DFN=myptdfn,newobj.ProcStf=myProvider
 	Set newobj.EDProc=myProcedure,newobj.EDVISITID=myvisitid
 	If (myHstart'=-1) {
 		Set newobj.ProcDt=$P(myHstart,",",1),newobj.ProcSTm=$P(myHstart,",",2)
 	}
 	If (myHend'=-1) {
 		Set newobj.ProcEDt=$p(myHend,",",1),newobj.ProcETm=$p(myHend,",",2)
 	}
 	//Update Notes if it is not empty
 	if mynote]"" {
 		Set PNsize=newobj.ProcNotes.SizeGet() Set PNinfo=newobj.ProcNotes.Read(PNsize)
 		If mynote'=PNinfo { //Something changed in the notes field
 			Do newobj.ProcNotes.Write(mynote)
 		}
 	}
 	Set MyStatus=newobj.%Save()
 	If ( ('MyStatus) ) {
 		Do $System.Status.DisplayError(MyStatus)
 		Write "alert('Error saving Procedure information: ' + "_(..QuoteJS(message))_" );",! 
 	}
 	else {
 		Write "alert("_(..QuoteJS(message))_");",! 
 	}
 	Quit
