 ;csp.beddedit1.1
 ;(C)InterSystems, generated for class csp.beddedit1.  Do NOT edit. 04/14/2017 08:47:50AM
 ;;75516C75;csp.beddedit1
 ;
zMyXdate(rawDtTm)
 	Set val=$$XDATE^BEDDUTID(rawDtTm)
 	QUIT val
zOnPage()
	Do ..OnPagePREHTML()
	Do ..OnPageCSPROOT()
	Do ..OnPagePOSTHTML()
	Quit 1
zOnPageBODY()
	Write "<BODY bgcolor=""#CCCCFF"" onload=""setFocus()"">"
	Write !,"<!-- use CSP:OBJECT tag to create a reference to an instance of the class -->"
	Write !,!
	If ((%request.Get("OBJID"))'="") {
	Set objForm = ##class(BEDD.EDVISIT).%OpenId((%request.Get("OBJID")))
	} Else {
	Set objForm = ##class(BEDD.EDVISIT).%New()
	}
	Write !,"<form name=""form"" action=""BEDDEDIT1.csp"" method=""POST"" onsubmit=""return CheckForm();"">"
	Write !,..InsertHiddenFields("BEDDEDIT1.csp?OBJID="_(%request.Get("OBJID"))),!
	Write !,!
	Set loc=%session.Data("LOC")
	Set objid=%request.Get("OBJID")
	Set (dfn,ptdfn)=objForm.PtDFN
	Do LOGSEC^BEDDUTIL(duz,dfn)
	//Audit the activity
	Do LOG^BEDDUTIU(duz,"P","Q","BEDDEDIT1.csp","BEDD: User opened patient display for editing",dfn)
	Set %session.Data("DFN")=dfn
	Set vien=objForm.VIEN
	//
	//Change EHR patient and visit
	If ((loc="EHR")&$D(beddsys("SwitchEHRPat"))) Set xx=$$CHGPAT^BEDDEHR(dfn,duz)
	If ((loc="EHR")&$D(beddsys("SwitchEHRPat"))) Set xx=$$CHGENC^BEDDEHR(vien,duz)
	//
	//Allergies and PCP
	Set ptalg=$$PTALG^BEDDUTIL(dfn)
	Set ptpcp=$$PPR^BEDDUTIL(vien,objid,dfn)
	//
	//Name and Gender
	Set ptname=objForm.PtName
	Set ptsex=objForm.Sex
	//
	//DOB, Age and Chart
	Set ptdob=objForm.DOB
	Set ptage=objForm.Age
	Set ptchart=objForm.Chart
	//
	//Admission Information
	Set ptcidt=objForm.PtCIDT
	//
	//Presenting Complaint
	Set ptcc=$$GETCC^BEDDUTIL(objForm.VIEN,objForm.Complaint,"P")
	//
	//Triage/Visit Information
	Set trgact=objForm.TrgA
	Set trgdttm=$$FMTE^BEDDUTIL(objForm.TrgDtTm)
	Set trgnrs=objForm.TrgNrs
	Set adpvdtm=$$FMTE^BEDDUTIL(objForm.AdPvDtm)
	Set admprv=objForm.AdmPrv
	Set prmnrs=objForm.PrmNurse
	Set dcadmdt=objForm.NewDecAdmit
	Set clinic=$$CCLN^BEDDUTID(objForm.TrgCln)
	//
	//
	//Chief Complaint
	Kill ChiefComplaint,ccList
	Set ChiefComplaint=$$GETCHIEF^BEDDGET(objForm.VIEN,"","",.ccList)
	If (ChiefComplaint]"") {
	Set ChiefComplaint=1
	}
	Else {
	Set ChiefComplaint=0
	}
	//
	//Injury Information
	Set vdate=$$GETF^BEDDUTIL(9000010,objForm.VIEN,".01","I")
	Set injury=objForm.Injury
	Set injwhr=objForm.PtInjury.InjLocat
	Set injcas=$$DX^AMERPOV(objForm.PtInjury.InjCauseIEN,"",1,vdate)
	Set injset=$$GETF^BEDDUTIL(9009083,objForm.PtInjury.InjSet,".01","I")
	Set injtim=$$FMTE^BEDDUTIL(objForm.PtInjury.InjDtTm)
	Set injsaf=$$GETF^BEDDUTIL(9009083,objForm.PtInjury.SafetyEquip,".01","I")
	Set injwrk=objForm.PtInjury.WrkRel
	//
	//Old Notes
	Set onotesize=objForm.Info.SizeGet()
	Set oldnotes=objForm.Info.Read(onotesize)
	//
	//Room Information
	Set (oldroom,erroom)=objForm.Room
	Set rmdttm=objForm.RoomDtTm
	Set rmclr=objForm.RoomClear
	Write !,!,"	"
	Set %value = $zconvert($get(%request.Data("ID",1),$ZSTRIP($select(objForm="":"",1:(objForm.%Id())),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""ID"" name=""ID"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("dfn",1),$ZSTRIP($select(objForm="":"",1:(objForm.PtDFNLogicalToDisplay(objForm.PtDFN))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""dfn"" name=""dfn"" readonly/>"
	Write !,"	"
	Write "<input type=""hidden"" id=""vien"" name=""vien"" readonly value="""_(vien)_"""/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("ptstat",1),$ZSTRIP($select(objForm="":"",1:(objForm.PtStatILogicalToDisplay(objForm.PtStatI))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""ptstat"" name=""ptstat"" readonly size=""1""/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("reclock",1),$ZSTRIP($select(objForm="":"",1:(objForm.RecLockLogicalToDisplay(objForm.RecLock))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""reclock"" name=""reclock"" size=""1""/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("reclockuser",1),$ZSTRIP($select(objForm="":"",1:(objForm.RecLockUserLogicalToDisplay(objForm.RecLockUser))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""reclockuser"" name=""reclockuser"" size=""1""/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("reclockdt",1),$ZSTRIP($select(objForm="":"",1:(objForm.RecLockDTLogicalToDisplay(objForm.RecLockDT))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" id=""reclockdt"" name=""reclockdt"" size=""1""/>"
	Write !,"	"
	Write "<input type=""hidden"" id=""SaveCheck"" name=""SaveCheck"" value=""""/>"
	Write !,"	"
	Write "<input type=""hidden"" id=""FormIsOkay"" name=""FormIsOkay"" value=""""/>"
	Write !,"	"
	Write "<input type=""hidden"" id=""ORoom"" name=""ORoom"" value="""_(oldroom)_"""/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("RoomDt",1),$ZSTRIP($select(objForm="":"",1:(objForm.RoomDtLogicalToDisplay(objForm.RoomDt))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""RoomDt"" id=""RoomDt"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("RoomTime",1),$ZSTRIP($select(objForm="":"",1:(objForm.RoomTimeLogicalToDisplay(objForm.RoomTime))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""RoomTime"" id=""RoomTime"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("ORmDt",1),$ZSTRIP($select(objForm="":"",1:(objForm.ORmDtLogicalToDisplay(objForm.ORmDt))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""ORmDt"" id=""ORmDt"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("ORmTm",1),$ZSTRIP($select(objForm="":"",1:(objForm.ORmTmLogicalToDisplay(objForm.ORmTm))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""ORmTm"" id=""ORmTm"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("RClDt",1),$ZSTRIP($select(objForm="":"",1:(objForm.RClDtLogicalToDisplay(objForm.RClDt))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""RClDt"" id=""RClDt"" readonly/>"
	Write !,"	"
	Set %value = $zconvert($get(%request.Data("RClTm",1),$ZSTRIP($select(objForm="":"",1:(objForm.RClTmLogicalToDisplay(objForm.RClTm))),">W")),"O","HTML")
	Write "<input value="""_(%value)_""" type=""hidden"" name=""RClTm"" id=""RClTm"" readonly/>"
	Write !,"	"
	Write "<input type=""hidden"" name=""RmClr"" id=""RmClr"" readonly value="""_(rmclr)_"""/>"
	Write !,"	"
	Write "<input type=""hidden"" name=""ONotes"" id=""ONotes"" readonly value="""_(oldnotes)_"""/>"
	Write !,!,"<center><b><font size=6>Patient Edit</font></b></center>",!
	Write "<br>",!
	Write !,"<td> "
	Write "<input type=""Submit"" name=""btnDisch"" style=""width:120px;height:25px"" value=""Discharge"" onclick=""chkdisch()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnSave"" style=""width:120px;height:25px"" value=""Save/Close"" onclick=""chkedt()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnCancel"" style=""width:120px;height:25px"" value=""Cancel"" onclick=""setFormOK()"">"
	Write " </td>   	",!
	Write "<hr>",!
	Write !,"<br><b><font size=4>Patient Information</font></b><br><br>",!
	Write "<label for=""PtName"">Patient (Gender)</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtName"" value='"_(ptname)_" ("_(ptsex)_")' size=""40"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""PtDOB"">DOB (Age)</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtDOB"" value='"_(ptdob)_" ("_(ptage)_")' size=""25"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""PtChart"">Chart</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtChart"" value='"_(ptchart)_"' size=""8"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"<br><br>",!
	Write "<label for=""PtAlg"">Allergies</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtAlg"" value='"_(ptalg)_"' size=""80"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""PtPCP"">PCP</label> "
	Write "<input name=""%noname"" type=""text"" id=""PtPCP"" value='"_(ptpcp)_"' size=""25"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"<br><br>",!
	Write "<hr>",!
	Write " ",!
	Write "<b><font size=4>Admission Information</font></b><br><br>",!
	Write !,"<table>",!
	Write "	<tr>",!
	Write "		<td>		",!
	Write "			"
	Write "<span style=""display:inline-block"">"
	Write !,!,"				<label for=""AStmp"" style=""display:block"">Check-In</label> "
	Write "<input name=""%noname"" type=""text"" id=""AStmp"" value='"_(ptcidt)_"' size=""16"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"				<br>					",!
	Write "					",!
	Write "				<label for=""Clinic"" style=""display:block"">*Clinic Type</label>",!
	Write "				"
	Write "<input name=""%noname"" type=""hidden"" id=""clin"" value='"_(clinic)_"' style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"					"
	Write "<select id=""Clinic"" name=""Clinic"">"
	Write !,"						"
	Do CLIN^BEDDUTID(.clin)
	Write "<option> </option>",! 
	Set clin=$O(clin(""))
	While (+clin'=0) {
	Write "<option value="""_($P(clin(clin),"^"))_"""> "_($P(clin(clin),"^",2))_"  </option>",! 
	Set clin=$O(clin(clin))
	}
	Write !,"					"
	Write "</select>"
	Write !,!,"			"
	Write "</span>"
	Write !,"			&nbsp;&nbsp;&nbsp;",!
	Write "		</td>",!
	Write "		<td>",!
	Write "			"
	Write "<span style=""display:inline-block"">"
	Write !,"				<label for=""ptcc"" style=""display:block"">Presenting Complaint</label>",!
	Write "					"
	Write "<textarea id=""ptcc"" name=""ptcc"" maxlength=""240"" cols=""80"" rows=""3"" style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #FFFFFF;"">"
	Write (ptcc)
	Write "</textarea>"
	Write !,"			"
	Write "</span>"
	Write !,"		</td>",!
	Write "	</tr>",!
	Write "	",!
	Write "	<tr>",!
	Write !,"		<td>",!
	Write "			"
	Write "<span style=""display:inline-block"">"
	Write !,"				<label for=""pttrg"" style=""display:block"">*Initial Acuity</label>",!
	Write "				"
	Write "<input name=""%noname"" type=""hidden"" id=""itrga"" value='"_(trgact)_"' style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"					"
	Write "<select id=""pttrg"" name=""pttrg"">"
	Write !,"						"
	Do BLDTRG^BEDDUTIL(.acty)
	Write "<option> </option>",! 
	Set acty=$O(acty(""))
	While(+acty'=0) {
	Write "<option value="""_(acty)_"""> "_(acty)_" - "_($P(acty(acty),"^",4))_"  </option>",! 
	Set acty=$O(acty(acty))
	}
	Write !,"					"
	Write "</select>"
	Write !,"			"
	Write "</span>"
	Write !,"						",!
	Write "		</td>",!
	Write "		<td>",!
	Write "			"
	Write "<span style=""display:inline-block"">"
	Write !,"				<label for=""trgdtm"" style=""display:block"">*Triaged</label>",!
	Write "				"
	Write "<input type=""text"" id=""trgdtm"" name=""trgdtm"" size=""18"" value='"_(trgdttm)_"' onchange=""doDateCheck()"" style=""color: #000000; font-family: Tahoma; font-weight: normal; font-size: 14px; background-color: #FFFFFF;""/>"
	Write !,"			"
	Write "</span>"
	Write !,"			&nbsp;",!
	Write "			&nbsp;",!
	Write "			"
	Write "<span style=""display:inline-block"">"
	Write !,"				<label for=""trgNrs"" style=""display:block"">*Triage Nurse</label>",!
	Write "				"
	Write "<input name=""%noname"" type=""hidden"" id=""trgnr"" size=""5"" value="""_(trgnrs)_""">"
	Write !,"					"
	Write "<select id=""trgNrs"" name=""trgNrs"">"
	Write !,"						"
	Do PROV^BEDDUTID(.prov)
	Write "<option> </option>",! 
	Set prov=$O(prov(""))
	While (+prov'=0) {
	Write "<option value="""_($P(prov(prov),"^"))_"""> "_($P(prov(prov),"^",2))_"  </option>",! 
	Set prov=$O(prov(prov))
	}
	Write !,"					"
	Write "</select>"
	Write !,"			"
	Write "</span>"
	Write !,"		</td>	",!
	Write "	</tr>",!
	Write "</table>",!
	Write "<br>",!
	Write "<hr>",!
	Write !,"<b><font size=4>Injury Information</font></b><br><br>",!
	Write !,"<Table>",!
	Write "<tr>",!
	Write "<td>",!
	Write "Was this visit caused by an injury?",!
	Write "</td>",!
	Write "<td>",!
	Write "<input "_($select(($get(%request.Data("Injury",1))="NO")||(($get(%request.Data("Injury",1))="")&&(($select(objForm="":"",1:(objForm.InjuryLogicalToDisplay(objForm.Injury))))="NO")):" checked",1:""))," type=""radio"" id=""Injury"" name=""Injury"" value=""NO""/>"
	Write "No",!
	Write "<input "_($select(($get(%request.Data("Injury",1))="YES")||(($get(%request.Data("Injury",1))="")&&(($select(objForm="":"",1:(objForm.InjuryLogicalToDisplay(objForm.Injury))))="YES")):" checked",1:""))," type=""radio"" id=""Injury"" name=""Injury"" value=""YES""/>"
	Write "Yes",!
	Write "</td>",!
	Write "<td>",!
	Write "<input type=""Submit"" name=""btnInjury"" value=""Add Injury Information"" onclick=""getAnswer()"">"
	Write !,"</td>",!
	Write "</tr>	",!
	Write "</Table>	",!
	If '(objForm.Injury="YES") Goto %csp00001 ;{
	Write !,"	&nbsp;&nbsp;",!
	Write "	<br>",!
	Write "	<label for=""InjTim"">Injury Occurred</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjTim"" value='"_(injtim)_"' size=""18"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"	&nbsp;&nbsp;",!
	Write "	<label for=""InjWhr"">Where Injury Occurred</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjWhr"" value='"_(injwhr)_"' size=""25"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"	<br><br>",!
	Write !,"	<label for=""InjCau"">Injury Cause</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjCau"" value='"_(injcas)_"' size=""100"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"	<br><br>	",!
	Write !,"	<label for=""InjSet"">Location</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjSet"" value='"_(injset)_"' size=""50"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"	&nbsp;&nbsp;",!
	Write "	<label for=""InjSaf"">Safety Equipment Used</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjSaf"" value='"_(injsaf)_"' size=""35"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"	<br><br>",!
	Write "	",!
	Write "	<label for=""InjWrk"">Work Related</label> "
	Write "<input name=""%noname"" type=""text"" id=""InjWrk"" value='"_(injwrk)_"' size=""4"" readonly style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !
%csp00001	;}
	Write !,"<br><br>",!
	Write !,"<td> "
	Write "<input type=""Submit"" name=""btnDisch"" style=""width:120px;height:25px"" value=""Discharge"" onclick=""chkdisch()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnSave"" style=""width:120px;height:25px"" value=""Save/Close"" onclick=""chkedt()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnCancel"" style=""width:120px;height:25px"" value=""Cancel"" onclick=""setFormOK()"">"
	Write " </td>   	",!
	Write "<br>",!
	Write "<hr>",!
	Write !,"<b><font size=4>Room Information</font></b><br><br>",!
	Write !,"<label for=""PrmNurse"">Primary Nurse</label>",!
	Write "<input name=""%noname"" type=""hidden"" id=""prmnrs"" size=""5"" value="""_(prmnrs)_""">"
	Write !,"	"
	Write "<select id=""PrmNurse"" name=""PrmNurse"">"
	Write !,"	"
	Do PROV^BEDDUTID(.prov)
	Write "<option> </option>",! 
	Set prov=$O(prov(""))
	While (+prov'=0) {
	Write "<option value="""_($P(prov(prov),"^"))_"""> "_($P(prov(prov),"^",2))_"  </option>",! 
	Set prov=$O(prov(prov))
	}
	Write !,"	"
	Write "</select>"
	Write !,!,"<br><br>",!
	Write !,"<label for=""Room"">Room Assignment</label> ",!
	Write "	"
	Write "<input type=""text"" name=""Room"" id=""Room"" readonly value="""_(erroom)_""" size=""10"" style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #C0C0C0;""/>"
	Write !,"&nbsp;",!
	Write "<label for=""RoomDtTm"">Date/Time Assigned</label>",!
	Write "<input type=""text"" id=""RoomDtTm"" name=""RoomDtTm"" size=""18"" value='"_(rmdttm)_"' onchange=""doRmDateCheck()"" style=""color: #000000; font-family: Tahoma; font-weight: normal; font-size: 14px; background-color: #FFFFFF;""/>"
	Write !,"&nbsp;&nbsp;",!
	Write !,"<input type=""radio"" name=""RRoom"" id=""RRoom"" value=""RR"" onclick='roomUnAssg();'/>"
	Write "Remove from Room",!
	Write "<br>",!
	Write "<fieldset><legend> <b>Available Rooms </b></legend>",!
	Write "<table>",!
	Write "	"
	Set rpfcnt=0
	Write !,"	"
	// Open instance of ResultSet for runtime mode of DISPLAY.
	Set ActRoom = ##class(%Library.ResultSet).%New()
	Set ActRoom.RuntimeMode=2
	Set sqlStatement=$zstrip($tr($c(13,10,9,9)_"SELECT %ID,RoomNo,Occupied,Status "_$c(13,10,9,9)_"FROM BEDD.EDRooms"_$c(13,10,9,9)_"WHERE (((Occupied IS NULL) OR Occupied = 'No') AND (Status = 'Active'))"_$c(13,10,9,9)_"ORDER BY RoomNo*1000"_$c(13,10,9),$C(9,13,10),"   "),"<>W")
	If $zcvt($extract(sqlStatement,1,6),"U")'="SELECT" {
	Do ..ShowError($$Error^%apiOBJ(5982,"898"))
	Quit
	}
	// translate tab/cr/nl to spaces
	Set %sc = ActRoom.Prepare(sqlStatement,0,"RUNTIME")
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Set %sc = ActRoom.Execute()
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Write !,!
%csp00003	If '(ActRoom.Next()) Goto %csp00002 ;{
	Write !,"	"
	i rpfcnt=0 If 1 { Write "<tr>",! }  
	i rpfcnt=8 If 1 { Write "</tr>",! }  s rpfcnt=0
	i (rpfcnt>0&(rpfcnt<9))!(rpfcnt=0) D
	. If 1 { Write "<td>&nbsp;&nbsp;",! }  
	. If 1 { Write "<input type=""radio"" name=""RoomNo"" id=""RoomNo"" onclick='asgroom();' value='"_(ActRoom.Get("RoomNo"))_"' > "_(ActRoom.Get("RoomNo"))_" ",! } 
	. If 1 { Write "&nbsp;&nbsp;</td>",! } 
	s rpfcnt=rpfcnt+1
	Write !,"	",!
	Goto %csp00003
%csp00002	;}
	Write !,"</table>",!
	Write "</fieldset>",!
	Write "<br>",!
	Write !,"<fieldset><legend> <b>Occupied Rooms </b></legend>",!
	Write "<table>",!
	Write "	"
	s rpfcnt=0
	Write !,"	"
	// Open instance of ResultSet for runtime mode of DISPLAY.
	Set ActRoom = ##class(%Library.ResultSet).%New()
	Set ActRoom.RuntimeMode=2
	Set sqlStatement=$zstrip($tr($c(13,10,9,9)_"SELECT %ID,RoomNo,Occupied,Status "_$c(13,10,9,9)_"FROM BEDD.EDRooms"_$c(13,10,9,9)_"WHERE (Occupied = 'Yes') "_$c(13,10,9,9)_"ORDER BY RoomNo*1000"_$c(13,10,9),$C(9,13,10),"   "),"<>W")
	If $zcvt($extract(sqlStatement,1,6),"U")'="SELECT" {
	Do ..ShowError($$Error^%apiOBJ(5982,"926"))
	Quit
	}
	// translate tab/cr/nl to spaces
	Set %sc = ActRoom.Prepare(sqlStatement,0,"RUNTIME")
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Set %sc = ActRoom.Execute()
	If (+%sc=0) {
	Do ..ShowError(%sc)
	Quit
	}
	Write !,!
%csp00005	If '(ActRoom.Next()) Goto %csp00004 ;{
	Write !,"	<bold>",!
	Write "	"
	i rpfcnt=0 If 1 { Write "<tr>",! }  
	i rpfcnt=8 If 1 { Write "</tr>",! }  s rpfcnt=0
	i (rpfcnt>0&(rpfcnt<9))!(rpfcnt=0) D
	. If 1 { Write "<td>&nbsp;&nbsp;",! }  
	. If 1 { Write "<input type=""radio"" name=""RoomNo"" id=""RoomNo"" value="""_(ActRoom.Get("RoomNo"))_""" disabled onclick='asgroom();' /> "_(ActRoom.Get("RoomNo"))_" ",! } 
	. If 1 { Write "&nbsp;&nbsp;</td>",! } 
	s rpfcnt=rpfcnt+1
	Write !,"	</bold>",!
	Goto %csp00005
%csp00004	;}
	Write !,"</table>",!
	Write "</fieldset>",!
	Write "<br>",!
	Write !,"<td> "
	Write "<input type=""Submit"" name=""btnDisch"" style=""width:120px;height:25px"" value=""Discharge"" onclick=""chkdisch()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnSave"" style=""width:120px;height:25px"" value=""Save/Close"" onclick=""chkedt()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnCancel"" style=""width:120px;height:25px"" value=""Cancel"" onclick=""setFormOK()"">"
	Write " </td>   	",!
	Write !,"<hr>",!
	Write !,"<b><font size=4>Visit Information</font></b><br>",!
	Write !
	If '(ChiefComplaint="1") Goto %csp00006 ;{
	Write !,"<br>",!
	Write "	<table border=1 bgcolor="""" width=""80%"">",!
	Write "	<tr><td><b>Chief Complaint</b></td>",!
	Write "	</tr>",!
	Write !,"	"
	For cclst=1:1:(ccList) {
	Write !,"		<tr>",!
	Write "        <td>"_(ccList(cclst))_" </td>",!
	Write "        </tr>",!
	Write "	"
	}
	Write !,!,"	</table>	",!
%csp00006	;}
	Write !,"<br>",!
	Write "<label for=""AdPvTm"">Medical Screening Exam Time</label> "
	Write "<input type=""AdPvTm"" id=""AdPvTm"" name=""AdPvTm"" size=""18"" value='"_(adpvdtm)_"' onchange=""doAPVDateCheck()"" style=""color: #000000; font-family: Tahoma; font-weight: normal; font-size: 14px; background-color: #FFFFFF;""/>"
	Write !,"&nbsp;",!
	Write !,"<label for=""AdmPrv"">ED Provider</label>",!
	Write "<input name=""%noname"" type=""hidden"" id=""admpr"" size=""5"" value="""_(admprv)_""">"
	Write !,"	"
	Write "<select id=""AdmPrv"" name=""AdmPrv"">"
	Write !,"	"
	Do PROV^BEDDUTID(.prov)
	Write "<option> </option>",! 
	Set prov=$O(prov(""))
	While (+prov'=0) {
	Write "<option value="""_($P(prov(prov),"^"))_"""> "_($P(prov(prov),"^",2))_"  </option>",! 
	Set prov=$O(prov(prov))
	}
	Write !,"	"
	Write "</select>"
	Write !,"<br><br>",!
	Write !,"<label for=""DecAdmDt"">Decision to Admit Time</label> "
	Write "<input type=""DecAdmDt"" id=""DecAdmDt"" name=""DecAdmDt"" size=""18"" value='"_(dcadmdt)_"' onchange=""doDAdDateCheck()"" style=""color: #000000; font-family: Tahoma; font-weight: normal; font-size: 14px; background-color: #FFFFFF;""/>"
	Write !,"&nbsp;",!
	Write "<br><br>",!
	Write !,"<table>",!
	Write "<tr>",!
	Write "	<td><b>ED Consults</b></td>",!
	Write "	<td><b>"
	Write "<input type=""radio"" id=""EDC"" name=""EDC"" disabled value=""No""/>"
	Write "No</b>",!
	Write "		<b>"
	Write "<input type=""radio"" id=""EDC"" name=""EDC"" disabled value=""Yes""/>"
	Write "Yes</b>",!
	Write "	</td>",!
	Write "	<td>",!
	Write "	"
	Write "<input type=""Submit"" name=""btnEDCons"" style=""width:200px;height:25px"" value=""ED Consult Information"" onclick=""getAnswer()"">"
	Write !,"	</td>",!
	Write "</tr>",!
	Write "<tr>",!
	Write "	<td><b>Procedures</b></td>",!
	Write "	<td><b>"
	Write "<input type=""radio"" id=""EProc"" name=""EProc"" disabled value=""No""/>"
	Write "No</b>",!
	Write "		<b>"
	Write "<input type=""radio"" id=""EProc"" name=""EProc"" disabled value=""Yes""/>"
	Write "Yes</b>",!
	Write "	</td>",!
	Write "	<td>",!
	Write "	"
	Write "<input type=""Submit"" name=""btnPROC"" style=""width:200px;height:25px"" value=""Procedure Information"" onclick=""getAnswer()"">"
	Write !,!,"	</td>",!
	Write "</tr>",!
	Write "<tr>",!
	Write "	<td><b>*Diagnosis</b></td>",!
	Write "	<td><b>"
	Write "<input type=""radio"" name=""Diag"" disabled value=""No""/>"
	Write "No</b>",!
	Write "		<b>"
	Write "<input type=""radio"" name=""Diag"" disabled value=""Yes""/>"
	Write "Yes</b>",!
	Write "	</td>",!
	Write "	<td>",!
	Write "	"
	Write "<input type=""Submit"" name=""btnDIAG"" style=""width:200px;height:25px"" value=""Diagnosis Information"" onclick=""getAnswer()"">"
	Write !,!,"	</td>",!
	Write "</tr>",!
	Write !,"<tr>		",!
	Write "	<td><b>Code Blue</b></td>",!
	Write "	<td>",!
	Write "		"
	Write "<input type=""radio"" name=""cb"" value=""No""/>"
	Write "No",!
	Write "		"
	Write "<input type=""radio"" name=""cb"" value=""Yes""/>"
	Write "Yes",!
	Write "	</td>",!
	Write "	<td></td>",!
	Write "</tr>",!
	Write "</table>",!
	Write !,"<br>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnDisch"" style=""width:120px;height:25px"" value=""Discharge"" onclick=""chkdisch()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnSave"" style=""width:120px;height:25px"" value=""Save/Close"" onclick=""chkedt()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnCancel"" style=""width:120px;height:25px"" value=""Cancel"" onclick=""setFormOK()"">"
	Write " </td>   	",!
	Write "<br>",!
	Write !,"<hr />",!
	Write "<br><b>General Information/Notes:</b><br> ",!
	Write "	"
	Write "<textarea id=""oldNotes"" name=""oldNotes"" cols=""85"" rows=""6"" style=""color: #000000; font-family: Tahoma; font-weight: bold; font-size: 14px; background-color: #FFFFFF;"">"
	Write (oldnotes)
	Write "</textarea>"
	Write !,"	",!
	Write "<hr>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnDisch"" style=""width:120px;height:25px"" value=""Discharge"" onclick=""chkdisch()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnSave"" style=""width:120px;height:25px"" value=""Save/Close"" onclick=""chkedt()"">"
	Write " </td>",!
	Write "<td> "
	Write "<input type=""Submit"" name=""btnCancel"" style=""width:120px;height:25px"" value=""Cancel"" onclick=""setFormOK()"">"
	Write " </td>   	",!
	Write !,"<input id=""OBJID"" name=""OBJID"" type=""hidden"" value="""_($select(objForm="":"",1:objForm.%Id()))_""">"
	Write "</form>"
	Write !,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,"</BODY>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDDEDIT1.csp - BEDD ED Edit Page -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;;Apr 02, 2014 -->"
	Write !
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<head>"
	Write !,!,!
	Set U="^",duz=%session.Data("DUZ"),site=%session.Data("SITE")
	Set objid=%request.Get("OBJID")
	Set %session.Data("OBJECTID")=objid
	Set dfn=%request.Get("DFN")
	Do CHKDATA^BEDDUTW(objid)
	Do LOADSYS^BEDDUTW(.beddsys,site)
	Set timeout=$G(beddsys("TimeOut"))
	Write !,!,"<META HTTP-EQUIV=""Refresh"" CONTENT="""_( timeout )_"; URL=BEDD.csp"">"
	Write !,!,"<TITLE>	BEDD Edit </TITLE>",!
	Write !,"<script language=""javascript"" type=""text/javascript"">"
	Write !,"function doDateCheck()	{",!
	Write "	var my_info = document.getElementById(""trgdtm"");",!
	Write "	var my_datetm = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',my_info.value) ;",!
	Write "	my_info.value=my_datetm;",!
	Write "		}",!
	Write !,"function doRmDateCheck()	{",!
	Write "	var my_info = document.getElementById(""RoomDtTm"");",!
	Write "	var my_datetm = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',my_info.value) ;",!
	Write "	my_info.value=my_datetm;",!
	Write "		}",!
	Write !,"function doAPVDateCheck()  {",!
	Write "	var my_info = document.getElementById(""AdPvTm"");",!
	Write "	var my_datetm = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',my_info.value) ;",!
	Write "	my_info.value=my_datetm;",!
	Write "		}",!
	Write !,"function doDAdDateCheck()  {",!
	Write "	var my_info = document.getElementById(""DecAdmDt"");",!
	Write "	var my_datetm = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',my_info.value) ;",!
	Write "	my_info.value=my_datetm;",!
	Write "		}",!
	Write !,"function setInjury() {",!
	Write "		var x1 = document.getElementById(""Injury"");",!
	Write "		var myVal = document.form.Injury.value ;",!
	Write "		set_radio(x1, myVal);",!
	Write " 	}",!
	Write !,"function set_Inj() {",!
	Write "	if (document.form.Injury) {",!
	Write "		self.document.location = ""BEDDINJ.csp?OBJID="_(objid)_""";",!
	Write "	}",!
	Write "}		",!
	Write !,"function set_radio(rObj,myValue) {",!
	Write "		if (myValue > 0) {",!
	Write "			for(i=0; i<rObj.length; i++){",!
	Write "				if (rObj[i].value == ""Yes"") {",!
	Write "					rObj[i].checked = true;",!
	Write "				}",!
	Write "			}",!
	Write "		} else {",!
	Write "			for(i=0; i<rObj.length; i++){",!
	Write "				if (rObj[i].value == ""No"") {",!
	Write "					rObj[i].checked = true;",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write " 	}",!
	Write !,"function chkdisch() {",!
	Write "	submitOK=""true"";",!
	Write "	",!
	Write "	<!--Initial Acuity-->",!
	Write "	var iact = document.getElementById('pttrg');",!
	Write "	if (iact.value=="""") {",!
	Write "		alert(""Initial Acuity is Required"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Triaged Check-->",!
	Write "	var trdt = document.getElementById('trgdtm');",!
	Write "	var tlen = trdt.value.length;",!
	Write "	if (trdt.value=="""") {",!
	Write "		alert(""Triage Date/Time is Required"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	if (trdt.value.length>0) {",!
	Write "		if (trdt.value.length<11) {",!
	Write "			alert(""Both Triage Date and Time are Required"");",!
	Write "			submitOK=""false"";",!
	Write "		}",!
	Write "		if (trdt.value.length>10) {",!
	Write "			var admdt = document.getElementById('AStmp');",!
	Write "			var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',trdt.value,admdt.value,""AF"") ;",!
	Write "			if (mess==""F"") {",!
	Write "				alert(""Future Triage Date/Time is not allowed"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (mess==""A"") {",!
	Write "				alert(""Triage Date/Time must be after Admit Date/Time"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write !,"		}",!
	Write "	}",!
	Write "	",!
	Write "	<!--Triage Nurse Check-->",!
	Write "	var trnr = document.getElementById('trgNrs');",!
	Write "	if (trnr.value=="""") {",!
	Write "		alert(""Triage Nurse is Required"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	 ",!
	Write "	<!--Medical Screening Exam Time Check-->",!
	Write "	<!--Required only if ED Provider Entered-->",!
	Write "	var apdt = document.getElementById('AdPvTm');",!
	Write "	var aprv = document.getElementById('AdmPrv');",!
	Write "	var tlen = apdt.value.length;",!
	Write !,"	if (aprv.value=="""") {",!
	Write "		}",!
	Write "	else {	",!
	Write "		if (apdt.value=="""") {",!
	Write "		alert(""Medical Screening Exam Time Required When ED Provider Populated"");",!
	Write "		submitOK=""false"";",!
	Write "		}",!
	Write "		if (apdt.value.length>0) {",!
	Write "			if (apdt.value.length<11) {",!
	Write "				alert(""Both Medical Screening Exam Time Date and Time are Required"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (apdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',apdt.value,admdt.value,""AF"") ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future Medical Screening Exam Time Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""Medical Screening Exam Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "	}",!
	Write "	",!
	Write "	<!--Clinic Type Check-->",!
	Write "	var clin = document.getElementById('Clinic');",!
	Write "	if (clin.value=="""") {",!
	Write "		alert(""Clinic Type is Required"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Diagnosis Check-->",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var vien = document.getElementById('vien');",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getEDDiagPrm"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',vien.value) ;",!
	Write "	if (cnt<1) {",!
	Write "		alert(""Primary Diagnosis Code is Required"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	if (cnt>1) {",!
	Write "		alert(""More than one Primary Dx on file. Please fix."");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Room Check-->",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var room = document.getElementById('Room');",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getRmChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid,room.value) ;",!
	Write "	if (cnt==1) {",!
	Write "		alert(""Room was just assigned to someone else. Please choose another room"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Room Date/TimeTriaged Check-->",!
	Write "	var room = document.getElementById('Room');",!
	Write "	if (room.value.length>0) {",!
	Write "		var rrdt = document.getElementById('RoomDtTm');",!
	Write "		if (rrdt.value=="""") {",!
	Write "			alert(""Room Date/Time is Required"");",!
	Write "			submitOK=""false"";",!
	Write "		}",!
	Write "		if (rrdt.value.length>0) {",!
	Write "			if (rrdt.value.length<11) {",!
	Write "				alert(""Both Room Date and Time are Required"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (rrdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',rrdt.value,admdt.value,""AF"") ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future Room Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""Room Date/Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "	}	",!
	Write "	",!
	Write "	if (submitOK==""true"") {",!
	Write "		var answer = confirm (""Continue to Discharge (Any changes will be saved)?"");",!
	Write "		if (answer) {",!
	Write "			var x=document.getElementById(""SaveCheck"");",!
	Write "			x.value = ""YES"";",!
	Write "		}",!
	Write "	} ",!
	Write "	",!
	Write "	else {",!
	Write "		var x=document.getElementById(""SaveCheck"");",!
	Write "		x.value = ""NO"";",!
	Write "	}",!
	Write "}",!
	Write !,"function chkedt() {",!
	Write "	submitOK=""true"";",!
	Write "	",!
	Write "	<!--Room Check-->",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var room = document.getElementById('Room');",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getRmChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid,room.value) ;",!
	Write "	if (cnt==1) {",!
	Write "		alert(""Room was just assigned to someone else. Please choose another room"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Room Date/TimeTriaged Check-->",!
	Write "	var room = document.getElementById('Room');",!
	Write "	if (room.value.length>0) {",!
	Write "		var rrdt = document.getElementById('RoomDtTm');",!
	Write "		if (rrdt.value=="""") {",!
	Write "			alert(""Room Date/Time is Required"");",!
	Write "			submitOK=""false"";",!
	Write "		}",!
	Write "		if (rrdt.value.length>0) {",!
	Write "			if (rrdt.value.length<11) {",!
	Write "				alert(""Both Room Date and Time are Required"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (rrdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',rrdt.value,admdt.value,""AF"") ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future Room Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""Room Date/Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "	}	",!
	Write "	if (submitOK==""true"") {",!
	Write "		var x=document.getElementById(""SaveCheck"");",!
	Write "		x.value = ""YES"";",!
	Write "	} ",!
	Write "	",!
	Write "	else {",!
	Write "		var x=document.getElementById(""SaveCheck"");",!
	Write "		x.value = ""NO"";",!
	Write "	}",!
	Write "}",!
	Write !,"function getAnswer() {",!
	Write !,"	submitOK=""true"";",!
	Write "	",!
	Write "	<!--Room Check-->",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var room = document.getElementById('Room');",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getRmChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid,room.value) ;",!
	Write "	if (cnt==1) {",!
	Write "		alert(""Room was just assigned to someone else. Please choose another room"");",!
	Write "		submitOK=""false"";",!
	Write "	}",!
	Write "	",!
	Write "	<!--Room Date/TimeTriaged Check-->",!
	Write "	var room = document.getElementById('Room');",!
	Write "	if (room.value.length>0) {",!
	Write "		var rrdt = document.getElementById('RoomDtTm');",!
	Write "		if (rrdt.value=="""") {",!
	Write "			alert(""Room Date/Time is Required"");",!
	Write "			submitOK=""false"";",!
	Write "		}",!
	Write "		if (rrdt.value.length>0) {",!
	Write "			if (rrdt.value.length<11) {",!
	Write "				alert(""Both Room Date and Time are Required"");",!
	Write "				submitOK=""false"";",!
	Write "			}",!
	Write "			if (rrdt.value.length>10) {",!
	Write "				var admdt = document.getElementById('AStmp');",!
	Write "				var mess = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getDtChk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',rrdt.value,admdt.value,""AF"") ;",!
	Write "				if (mess==""F"") {",!
	Write "					alert(""Future Room Date/Time is not allowed"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "				if (mess==""A"") {",!
	Write "					alert(""Room Date/Time must be after Admit Date/Time"");",!
	Write "					submitOK=""false"";",!
	Write "				}",!
	Write "			}",!
	Write "		}",!
	Write "	}	",!
	Write "	",!
	Write "	if (submitOK==""true"") {",!
	Write !,"		var answer = confirm (""Any changes will be automatically saved when transferring to a new page"")",!
	Write "		if (answer) {",!
	Write "			var x=document.getElementById(""SaveCheck"");",!
	Write "			x.value = ""YES"";",!
	Write "		}",!
	Write "	}",!
	Write "	else {",!
	Write "		var x=document.getElementById(""SaveCheck"");",!
	Write "		x.value = ""NO"";",!
	Write "	}",!
	Write "}",!
	Write !,"function setFocus(){",!
	Write "	setITrgA();",!
	Write "	setTrgNrs();",!
	Write "	setAdmPrv();",!
	Write "	setPrmNrs();",!
	Write "	setCln();",!
	Write "	//setNewNote();  <-- BEDD*1.0*1 - Commented out - NewNote isn't used-->",!
	Write "	setInjury();",!
	Write "	set_EDCons();",!
	Write "	set_EDProc();",!
	Write "	set_EDDiag()",!
	Write "	set_CodeBlue();",!
	Write "}",!
	Write !,"function setITrgA() {",!
	Write "	var x11 = document.getElementById(""pttrg"") ;",!
	Write "	var itrga = document.form.itrga.value ;",!
	Write "	for (i=0; i<x11.options.length; i++){",!
	Write "		if (x11.options[i].value == itrga) {",!
	Write "			x11.selectedIndex = i ;",!
	Write "			}",!
	Write "		}",!
	Write "}",!
	Write !,"function setTrgNrs() {",!
	Write "	var x12 = document.getElementById(""trgNrs"") ;",!
	Write "	var trgnr = document.form.trgnr.value;",!
	Write "	for (i=0; i<x12.options.length; i++){",!
	Write "		if (x12.options[i].value == trgnr) {",!
	Write "			x12.selectedIndex = i ;",!
	Write "			}",!
	Write "		}",!
	Write "}	",!
	Write !,"function setAdmPrv() {",!
	Write "	var x13 = document.getElementById(""AdmPrv"") ;",!
	Write "	var admpr = document.form.admpr.value;",!
	Write "	for (i=0; i<x13.options.length; i++){",!
	Write "		if (x13.options[i].value == admpr) {",!
	Write "			x13.selectedIndex = i ;",!
	Write "			}",!
	Write "		}",!
	Write "}",!
	Write !,"function setPrmNrs() {",!
	Write "	var x15 = document.getElementById(""PrmNurse"") ;",!
	Write "	var prmnrs = document.form.prmnrs.value;",!
	Write "	for (i=0; i<x15.options.length; i++){",!
	Write "		if (x15.options[i].value == prmnrs) {",!
	Write "			x15.selectedIndex = i ;",!
	Write "			}",!
	Write "		}",!
	Write "}",!
	Write !,"function setCln() {",!
	Write "	var x14 = document.getElementById(""Clinic"") ;",!
	Write "	var clin = document.getElementById(""clin"").value ;",!
	Write "	for (i=0; i<x14.options.length; i++){",!
	Write "		if (x14.options[i].value == clin) {",!
	Write "			x14.selectedIndex = i ;",!
	Write "			}",!
	Write "		}",!
	Write "}	",!
	Write !,"//function setNewNote() {",!
	Write "//	var x = document.getElementById(""Info"") ;",!
	Write "//	document.form.Info.value ="""";",!
	Write "//}",!
	Write !,"//",!
	Write "// Set the radio button groups in the form the default is No	",!
	Write "function set_EDCons() {",!
	Write "	var myRadioObj = document.form.EDC ;",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getEDConCount"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid) ;",!
	Write "	set_radio(myRadioObj,cnt);",!
	Write "}",!
	Write !,"function set_EDProc() {",!
	Write "	var myRadioObj = document.form.EProc ;",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getEDProcCount"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid) ;",!
	Write "	set_radio(myRadioObj,cnt);",!
	Write "}",!
	Write !,"function set_EDDiag() {",!
	Write "	var myRadioObj = document.form.Diag ;",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getEDDiagCount"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid) ;",!
	Write "	set_radio(myRadioObj,cnt);",!
	Write "}",!
	Write !,"function set_CodeBlue() {",!
	Write "	var myRadioObj = document.form.cb ;",!
	Write "	var myobjid="_(objid)_" ;",!
	Write "	var cnt = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getCodeBlue"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',myobjid) ;",!
	Write "	set_radio(myRadioObj,cnt);",!
	Write "}",!
	Write !,"// Assign user to a room",!
	Write "function asgroom()	{",!
	Write "	var objid = document.form.ID.value ;",!
	Write "	//var selroom = """"",!
	Write "	findroom = ""false"";",!
	Write "	for (var i=0; i<document.form.RoomNo.length; i++)  { ",!
	Write "		if (document.form.RoomNo[i].checked)  {",!
	Write "			var selroom = document.form.RoomNo[i].value",!
	Write "			findroom = ""true"";",!
	Write "			} ",!
	Write "	} ",!
	Write "	",!
	Write "	//Handle case where there is only one room",!
	Write "	if (findroom==""false"") {",!
	Write "		var selroom = document.form.RoomNo.value",!
	Write "	}",!
	Write !,"	var today = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getTheDate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "	var cvtoday = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',today) ;",!
	Write "	var myDateTime = today.split(""@"");",!
	Write "			",!
	Write "	var currentTime = myDateTime[1];",!
	Write "	var myCurrTime = currentTime.split("":"")",!
	Write "			",!
	Write "	var mytime = myCurrTime[0] + "":"" + myCurrTime[1] ; ",!
	Write "		 ",!
	Write "	document.form.Room.value = selroom ;",!
	Write "	document.form.RoomDt.value = myDateTime[0];",!
	Write "	document.form.RoomTime.value = mytime;",!
	Write "	document.form.RoomDtTm.value = cvtoday;",!
	Write "			",!
	Write "	"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".setRoom"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',selroom,objid,myDateTime[0],mytime) ;",!
	Write "}",!
	Write "		",!
	Write "// Unassign this room for the patient",!
	Write "function roomUnAssg() {",!
	Write "	var objid = document.form.ID.value ;",!
	Write "	var room = document.form.Room.value ;",!
	Write "	document.form.Room.value = """" ;",!
	Write "	document.form.RoomDt.value = """" ;",!
	Write "	document.form.RoomTime.value = """";",!
	Write "	document.form.RoomDtTm.value = """";",!
	Write "	",!
	Write "	var today = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getTheDate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "	var cvtoday = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".MyXdate"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',today) ;",!
	Write "	document.form.RmClr.value = cvtoday;",!
	Write "			",!
	Write "	"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".clrRoom"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',room,objid)	",!
	Write "			",!
	Write "	//javascript:location.reload(true)",!
	Write "}",!
	Write !,"function CheckForm() {",!
	Write "	var x1= document.getElementById(""SaveCheck"") ;",!
	Write "	var x2=document.getElementById(""FormIsOkay"");",!
	Write "	if ( x2.value == ""YES"" ) {",!
	Write "		return true;",!
	Write "	}",!
	Write "	if ( x1.value == ""YES"" ) {",!
	Write "		return true;",!
	Write "	} else {",!
	Write "		return false;",!
	Write "	}",!
	Write "	",!
	Write "	// Default answer is we save the page",!
	Write "	return true;",!
	Write "}",!
	Write !,"function setFormOK() {",!
	Write "	var x=document.getElementById(""FormIsOkay"");",!
	Write "	x.value = ""YES"";",!
	Write "} ",!
	Write !," function ChangePage(my_page, my_oid, my_dfn) {",!
	Write " 	self.document.location = my_page + ""?Page=BEDDEDIT1.csp&EDVISITID=""+ my_oid + ""&DFN="" + my_dfn ;",!
	Write " } ",!
	Write " ",!
	Write "</script>"
	Write "	",!
	Do ..formGenJS()
	Write !,(..HyperEventHead(0,0))
	Write "</head>"
	Quit
zOnPageHTML()
	Write "<html>"
	Write !
	Do ..OnPageHEAD()
	Write !,!
	Do ..OnPageBODY()
	Write !,"</html>"
	Quit
zOnPagePOSTHTML()
	Set objForm=""
	Set ActRoom=""
	Set ActRoom=""
	Quit
zOnPagePREHTML()
	Set objForm=""
	Set ActRoom=""
	Set ActRoom=""
	Quit
zOnPreHTTP()
 	Set U="^"
 	//
 	//Check for access information
 	If ('$D(%session.Data("DUZ"))) {
 		Set %response.Redirect="BEDDLogin.csp"
 	}
 	//
 	//Process Save/Close (Button)
 	If ($Data(%request.Data("btnSave",1))) {
   		// Determine if the user want to save the page before going to discharge
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 		Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
       	Set %response.Redirect="BEDD.csp"
 		}
     }
     //
     //Process Discharge (Button)
     Elseif ($Data(%request.Data("btnDisch",1))) {
 	    // Determine if the user want to save the page before going to discharge
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 			Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
 	   		// Redirect to the discharge page
 	   		Set %response.Redirect="BEDDDC.csp?Page=BEDDEDIT1.csp&OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
 		Else {
 			Set %response.Redirect="BEDDEDIT1.csp?OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
     }
     //Process Injury (Button)
     Elseif ($Data(%request.Data("btnInjury",1))) {
 	    // Determine if the user want to save the page before going to injuries
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 			Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
 	   		// Redirect to the injury page
 	   		Set %response.Redirect="BEDDINJ.csp?OBJID="_%request.Get("OBJID")
 		}
 		Else {
 			Set %response.Redirect="BEDDEDIT1.csp?OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
     }
     //
     //Process ED Consult (Button)
     Elseif ($Data(%request.Data("btnEDCons",1))) {
 	    // Determine if the user want to save the page before going to ED Consults
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 			Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
 	   		// Redirect to the ED Consult page
 			Set %response.Redirect="BEDDCONS.csp?EDVISITID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
 		Else {
 			Set %response.Redirect="BEDDEDIT1.csp?OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
     }
     //
     //Process Procedures (Button)
     Elseif ($Data(%request.Data("btnPROC",1))) {
 	    // Determine if the user want to save the page before going to Procedures
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 			Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
 	   		// Redirect to the ED Consult page
 			Set %response.Redirect="BEDDPROC.csp?EDVISITID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
 		Else {
 			Set %response.Redirect="BEDDEDIT1.csp?OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
     }
     //
     //Process Diagnosis (Button)
     Elseif ($Data(%request.Data("btnDIAG",1))) {
 	    // Determine if the user want to save the page before going to Diagnosis
 		Set MyAns=$G(%request.Data("SaveCheck",1))
 		If MyAns="YES" {
 			Do ..ProcessSave($Get(%request.Data("USERNAME",1)))
 	   		// Redirect to the ED Consult page
 			Set %response.Redirect="BEDDDIAG.csp?EDVISITID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
 		Else {
 			Set %response.Redirect="BEDDEDIT1.csp?OBJID="_%request.Get("OBJID")_"&DFN="_%session.Get("DFN")
 		}
     }
     //
     //Process Cancel (Button)
     Elseif ($Data(%request.Data("btnCancel",1))) {
 	    //Cancel any saves and go back to the dashboard
 	    Set %response.Redirect="BEDD.csp"
     }
  	Quit 1
zPage(skipheader=1) public {
	New %CSPsc Set %CSPsc=1
	Set dopage=(%request.Method'="HEAD")
	If %response.Language="" Do %response.MatchLanguage()
	If 'skipheader Do $zutil(96,18,2,"UTF8")
	Try {
		If ..OnPreHTTP()=0 Set dopage=0
		If 'skipheader Set %CSPsc=%response.WriteHTTPHeader(.dopage) Set:('%CSPsc) dopage=0
		If $get(dopage) Set %CSPsc=..OnPage()
	} Catch exception {
		If $ZError'["<ZTHRO"||($get(%CSPsc)="")||(+%CSPsc) Set %CSPsc=exception.AsStatus()
	}
	Quit %CSPsc }
zProcessSave(myUser)
 	Set duz=%session.Data("DUZ")
 	Set site=%session.Data("SITE")
 	Set objid=$G(%request.Data("OBJID",1))
 	Set (vien,dfn,amvisit)=""
 	Lock +^BEDD.EDVISIT(objid):30
 	If ($T) {
 		Set entry=##class(BEDD.EDVISIT).%OpenId(objid)
 		Set vien=entry.VIEN
 		Set dfn=entry.PtDFN
 		Set amvisit=entry.AMERVSIT
 		//Audit the activity
 		Do LOG^BEDDUTIU(duz,"P","E","BEDDEDIT1.csp","BEDD: User edited ER information",dfn)
 		//
 		// Build array to pass to BEDDUTIL for processing
 		//
 		//Presenting Complaint
 		Set beddfld("COMP")=$Get(%request.Data("ptcc",1))
 		//
 		//Initial Acuity
 		Set beddfld("Trg")=$Get(%request.Data("pttrg",1))
 		//
 		//Triage Date/Time
 		Set beddfld("TrgNow")=$$DATE^BEDDUTIU($Get(%request.Data("trgdtm",1)))
 		//
 		//Triage Nurse
 		Set beddfld("TrgN")=$Get(%request.Data("trgNrs",1))
 		//
 		//Admitting Provider
 		Set beddfld("AdmPrv")=$Get(%request.Data("AdmPrv",1))
 		//
 		//Time Seen By Admitting Provider
 		Set beddfld("AdPvTm")=$$DATE^BEDDUTIU($Get(%request.Data("AdPvTm",1)))
 		//
 		//Clinic
 		Set beddfld("txcln")=$Get(%request.Data("Clinic",1))
 		//
 		//Primary Nurse
 		Set entry.PrmNurse=$Get(%request.Data("PrmNurse",1))
 		//
 		//Decision to Admit Time
 		Set entry.DecAdmDt=$$DATE^BEDDUTIU($Get(%request.Data("DecAdmDt",1)))
 		Set beddfld("DecAdmit")=entry.DecAdmDt
 		//
 		//Save Information
 		Set save=$$ESAVE^BEDDUTID(dfn,amvisit,vien,.beddfld,duz)
 		//
 		// Room Assignment, Date and Time
 		//
 		Set upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 		Set lower = "abcdefghijklmnopqrstuvwxyz"
 		Set rmdttm=$Get(%request.Data("RoomDtTm",1))
 		Set fmdtm=$$TODLH^BEDDUTIL(rmdttm)
 		Set rmdt=$P(fmdtm,",")
 		Set rmtm=$P(fmdtm,",",2)
 		Set rmclr=$Get(%request.Data("RmClr",1))
 		Set fcldtm=$$TODLH^BEDDUTIL(rmclr)
 		Set rcldt=$P(fcldtm,",")
 		Set rcltm=$P(fcldtm,",",2)
 		//
 		//Pull Original Room Dt/Tm
 		Set ORmDt=$Get(%request.Data("ORmDt",1))
 		Set ORmTm=$Get(%request.Data("ORmTm",1))
 		//
 		Set oroom=$Get(%request.Data("ORoom",1))
 		Set nroom=$Get(%request.Data("Room",1))
 		//		
 		//Original room is populated
 		If (oroom'="") {
 			//
 			//If the same, update time
 			If (oroom=nroom) {
 				Set entry.RoomDt=rmdt
 				Set entry.RoomTime=rmtm
 				Set entry.RoomDtTm=rmdttm
 				//
 				//Remove existing cleared dttm
 				Set entry.RoomClear=""
 				Set entry.RClDt=""
 				Set entry.RClTm=""
 				//
 				//Fill In Original Room Dt/Tm
 				If (ORmDt="") {
 					Set entry.ORmDt=rmdt
 					Set entry.ORmTm=rmtm
 				}
 			}
 			//
 			//If new is blank, clear out existing
 			ElseIf (nroom="") {
 				Set entry.Room=""
 				Set entry.RoomDt=""
 				Set entry.RoomTime=""
 				Set entry.RoomDtTm=""
 				//
 				//Log cleared dttm
 				Set entry.RoomClear=rmclr
 				Set entry.RClDt=rcldt
 				Set entry.RClTm=rcltm
 				//
 				//Make old room unoccupied
 				Set selroom=$TR(oroom,lower,upper)
 				Set ri=""
 				Set ri=$O(^BEDD.EDRoomsI("Room"," "_selroom,ri)) 
 				If ri'="" {
 					Set rentry=""
 					Set rentry=##class(BEDD.EDRooms).%OpenId(ri)
 					Set orm=""
 					Set orm=##class(BEDD.EDVISIT).%OpenId(objid)
 					Set rentry.Occupied="No"
 					Set savstat = rentry.%Save()
 				}		
 			}
 			//
 			//If different, change rooms
 			Else {
 				Set entry.Room=nroom
 				Set entry.RoomDt=rmdt
 				Set entry.RoomTime=rmtm
 				Set entry.RoomDtTm=rmdttm
 				//
 				//Remove existing cleared dttm
 				Set entry.RoomClear=""
 				Set entry.RClDt=""
 				Set entry.RClTm=""
 				//
 				//Fill In Original Room Dt/Tm
 				If (ORmDt="") {
 					Set entry.ORmDt=rmdt
 					Set entry.ORmTm=rmtm
 				}
 				//
 				//Make new room occupied
 				Set selroom=$TR(nroom,lower,upper)
 				Set ri=""
 				Set ri=$O(^BEDD.EDRoomsI("Room"," "_selroom,ri)) 
 				If ri'="" {
 					Set rentry=""
 					Set rentry=##class(BEDD.EDRooms).%OpenId(ri)
 					Set orm=""
 					Set orm=##class(BEDD.EDVISIT).%OpenId(objid)
 					Set rentry.Occupied="Yes"
 					Set savstat = rentry.%Save()
 				}
 				//
 				//Make old room unoccupied
 				Set selroom=$TR(oroom,lower,upper)
 				Set ri=""
 				Set ri=$O(^BEDD.EDRoomsI("Room"," "_selroom,ri)) 
 				If ri'="" {
 					Set rentry=""
 					Set rentry=##class(BEDD.EDRooms).%OpenId(ri)
 					Set orm=""
 					Set orm=##class(BEDD.EDVISIT).%OpenId(objid)
 					Set rentry.Occupied="No"
 					Set savstat = rentry.%Save()
 				}
 				//
 				//Update Room Use Class
 				Set selroom=$TR(nroom,lower,upper)
 				Set uentry=##class(BEDD.EDRoomUse).%New()
 				Set uentry.EDID=objid
 				Set uentry.PtDFN=dfn
 				Set uentry.RoomID=selroom
 				Set uentry.RoomDt=rmdt
 				Set uentry.RoomTime=rmtm
 				Set savstat = uentry.%Save()
 				Set uentry=""
 			}
 		}
 		//
 		//Original room was blank
 		If $Get(%request.Data("ORoom",1))="" {
 			//
 			//If new is blank, do nothing
 			If ($Get(%request.Data("Room",1))="") {
 			}
 			//
 			//Assign to a new room
 			Else {
 				Set entry.Room=$Get(%request.Data("Room",1))
 				//Set rmdtm=$G(%request.Data("RoomDt",1))_"@"_$G(%request.Data("RoomTime",1))
 				//If rmdtm="@" {
 				//	Set rmdtm=""
 				//}
 				Set:rmdt]"" entry.RoomDt=rmdt
 				Set:rmtm]"" entry.RoomTime=rmtm
 				Set:rmdttm]"" entry.RoomDtTm=rmdttm
 				//
 				//Remove existing cleared dttm
 				Set entry.RoomClear=""
 				Set entry.RClDt=""
 				Set entry.RClTm=""
 				//
 				//Fill In Original Room Dt/Tm
 				If (ORmDt="") {
 					Set entry.ORmDt=rmdt
 					Set entry.ORmTm=rmtm
 				}
 				//
 				//Make new room occupied
 				Set selroom=$TR(nroom,lower,upper)
 				Set ri=""
 				Set ri=$O(^BEDD.EDRoomsI("Room"," "_selroom,ri)) 
 				If ri'="" {
 					Set rentry=""
 					Set rentry=##class(BEDD.EDRooms).%OpenId(ri)
 					Set orm=""
 					Set orm=##class(BEDD.EDVISIT).%OpenId(objid)
 					Set rentry.Occupied="Yes"
 					Set savstat = rentry.%Save()
 				}
 				//
 				//Update Room Use Class
 				Set uentry=##class(BEDD.EDRoomUse).%New()
 				Set uentry.EDID=objid
 				Set uentry.PtDFN=dfn
 				Set uentry.RoomID=selroom
 				Set uentry.RoomDt=rmdt
 				Set uentry.RoomTime=rmtm
 				Set savstat = uentry.%Save()
 				Set uentry=""
 			}
 		}
 		//
 		//Injury YES/NO
 		Set injury=$G(%request.Data("Injury",1))
 		If (injury = "YES")||(injury = "NO") {
 			Set entry.Injury=injury
 		}
 		//
 		// EDConsult, EDProcedure and CodeBlue
 		Set:$Get(%request.Data("EDC",1))]"" entry.EDConsult=$G(%request.Data("EDC",1))
 		Set:$Get(%request.Data("EProc",1))]"" entry.EDProcedure=$G(%request.Data("EProc",1))
 		Set:$Get(%request.Data("cb",1))]"" entry.CodeBlue=$G(%request.Data("cb",1))
 		//
 		//Note
 		Set notes=""
 		Set onotes=""
 		Set:$Get(%request.Data("oldNotes",1))]"" notes=%request.Data("oldNotes",1)
 		Set:$Get(%request.Data("ONotes",1))]"" onotes=%request.Data("ONotes",1)
 		If (notes'=onotes) {
 			If (notes]"") {
 				Set myToday=$$XNOW^BEDDUTIL()
 				Set myToday=$P(myToday,"@",1)_" "_$P(myToday,"@",2)
 				Set notes=notes_" "_myToday_" by "_$$GETF^BEDDUTIL(200,duz,".01","E")_"; "
 			}
 			Do entry.Info.Write(notes)
 			Set statchk=entry.%Save()
 			If (statchk'=1) {
 				Write " alert('not saved' );",! 
 			}
 			Kill statchk
 		}
 		Kill onotes,notes
 		//
 		// Save the updates to the BEDD.EDVISIT object
 		Set rc=entry.%Save()
 		//
 		LOCK -^BEDD.EDVISIT(objid)
 		//
 	}
 	Quit
zclrRoom(room,objid)
 	Quit
 	S RmId="",SQLCODE=0
 	I room'="" {
 		 ;---&sql(SELECT ID INTO :RmId
  		 ;---         FROM BEDD.EDRooms 
  		 ;---         WHERE RoomNo = :room)
  		 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, RmId, SQLCODE, room
 		Do %0Ao
     	If SQLCODE'=0 {
 	    	Write " alert(""Error executing SQL Statement"") ",! 
 	    	Quit
     	}
 	}
 	If RmId]"" {
 		Set rentry="" s rentry=##class(BEDD.EDRooms).%OpenId(RmId)
 		Set rentry.Occupied="No"
 		Set savestat=rentry.%Save() s rentry=""
 		If savestat'=1 {
 			Write " alert('NOT SAVED  "_(selroom)_" '); ",! 
 		}
 	}
 	Else {
 		Write " alert('Could not find an Id for room: "_(room)_" '); ",! 
 	}
 	If objid]"" {
 		Set myvst="" s myvst=##class(BEDD.EDVISIT).%OpenId(objid)
 		// Clear room information
 		Set myvst.Room="",myvst.RoomDt="",myvst.RoomTime=""
 		Set rc=myvst.%Save() Set myvst=""
 		If ('rc) {
 			Write " alert('Clearing room "_(room)_" failed'); ",! 
 		}
 	}
 	Quit 
 q
%0Ao 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Aerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(room)
 s SQLCODE=100
 s %mmmsqld(4)=$zu(28,%mmmsqld(3),7)
 ; asl MOD# 2
 s %mmmsqld(5)=%mmmsqld(4) s:%mmmsqld(5)="" %mmmsqld(5)=-1E14
 i '($s(%mmmsqld(5)'=-1E14:%mmmsqld(5),1:"")'=" ") g %0AmBdun
 s RmId=""
%0AmBk1 s:%mmmsqld(5)="" %mmmsqld(5)=-1E14
 s RmId=$o(^BEDD.EDRoomsI("Room",%mmmsqld(5),RmId))
 i RmId="" g %0AmBdun
 s:%mmmsqld(5)=-1E14 %mmmsqld(5)=""
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BEDD.EDRoomsD($p(RmId,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDRoomsD($p(RmId,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDRooms for RowID value: "_RmId ztrap "LOCK"  }
 ; asl MOD# 3
 s %mmmsqld(6)=$lb(""_%mmmsqld(5))
 i RmId'="",$d(^BEDD.EDRoomsD(RmId))
 e  g %0AmCdun
 s %mmmsqld(7)=$g(^BEDD.EDRoomsD(RmId)) s %mmmsqld(8)=$lg(%mmmsqld(7),2) s %mmmsqld(5)=$zu(28,%mmmsqld(8),7)
 s %mmmsqld(9)=$lb(""_%mmmsqld(5))
 g:%mmmsqld(6)'=%mmmsqld(9) %0AmCdun
%0AmBuncommitted ;
 s SQLCODE=0 g %0Ac
%0AmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0AmBk1
%0AmBdun  s:$g(%mmmsqld(5))=-1E14 %mmmsqld(5)=""
%0AmAdun 
%0Ac s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Aerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Ac
zformGenJS()
	Write !,"<script language=""JavaScript"" type=""text/javascript"">",!
	Write "<!--",!
	Write "function form_new()",!
	Write "{",!
	Write "   // invoke #server(csp.beddedit1.formLoad())",!
	Write "   return ("_"cspHttpServerMethod"_"('",..Encrypt($listbuild("csp.beddedit1.formLoad"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""),"','') == 1);",!
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
			Set obj = ##class(BEDD.EDVISIT).%OpenId(objid)
		} Else {
			Set obj = ##class(BEDD.EDVISIT).%New()
		}
		If (obj="") {
			If 'alwaysLoad Quit 0
			Set ok=0
		} Else {
			Set close=1
		}
	}
	Write "var form = CSPPage.document.form;",!
	Write "if (form.ID != null && form.ID != null) { form.ID.value = ",..QuoteJS($select(obj="":"",1:(obj.%Id()))),";}",!
	Write "if (form.dfn != null && form.dfn != null) { form.dfn.value = ",..QuoteJS($select(obj="":"",1:($select(obj.PtDFN=$c(0):"",1:(obj.PtDFNLogicalToDisplay(obj.PtDFN)))))),";}",!
	Write "if (form.ptstat != null && form.ptstat != null) { form.ptstat.value = ",..QuoteJS($select(obj="":"",1:($select(obj.PtStatI=$c(0):"",1:(obj.PtStatILogicalToDisplay(obj.PtStatI)))))),";}",!
	Write "if (form.reclock != null && form.reclock != null) { form.reclock.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RecLock=$c(0):"",1:(obj.RecLockLogicalToDisplay(obj.RecLock)))))),";}",!
	Write "if (form.reclockuser != null && form.reclockuser != null) { form.reclockuser.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RecLockUser=$c(0):"",1:(obj.RecLockUserLogicalToDisplay(obj.RecLockUser)))))),";}",!
	Write "if (form.reclockdt != null && form.reclockdt != null) { form.reclockdt.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RecLockDT=$c(0):"",1:(obj.RecLockDTLogicalToDisplay(obj.RecLockDT)))))),";}",!
	Write "if (form.RoomDt != null && form.RoomDt != null) { form.RoomDt.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RoomDt=$c(0):"",1:(obj.RoomDtLogicalToDisplay(obj.RoomDt)))))),";}",!
	Write "if (form.RoomTime != null && form.RoomTime != null) { form.RoomTime.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RoomTime=$c(0):"",1:(obj.RoomTimeLogicalToDisplay(obj.RoomTime)))))),";}",!
	Write "if (form.ORmDt != null && form.ORmDt != null) { form.ORmDt.value = ",..QuoteJS($select(obj="":"",1:($select(obj.ORmDt=$c(0):"",1:(obj.ORmDtLogicalToDisplay(obj.ORmDt)))))),";}",!
	Write "if (form.ORmTm != null && form.ORmTm != null) { form.ORmTm.value = ",..QuoteJS($select(obj="":"",1:($select(obj.ORmTm=$c(0):"",1:(obj.ORmTmLogicalToDisplay(obj.ORmTm)))))),";}",!
	Write "if (form.RClDt != null && form.RClDt != null) { form.RClDt.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RClDt=$c(0):"",1:(obj.RClDtLogicalToDisplay(obj.RClDt)))))),";}",!
	Write "if (form.RClTm != null && form.RClTm != null) { form.RClTm.value = ",..QuoteJS($select(obj="":"",1:($select(obj.RClTm=$c(0):"",1:(obj.RClTmLogicalToDisplay(obj.RClTm)))))),";}",!
	Write "if (form.Injury != null && form.Injury[0] != null) { form.Injury[0].checked = ",(($select(obj="":"",1:($select(obj.Injury=$c(0):"",1:(obj.InjuryLogicalToDisplay(obj.Injury))))))="NO"),";}",!
	Write "if (form.Injury != null && form.Injury[1] != null) { form.Injury[1].checked = ",(($select(obj="":"",1:($select(obj.Injury=$c(0):"",1:(obj.InjuryLogicalToDisplay(obj.Injury))))))="YES"),";}",!
	Write "if (form.OBJID != null) { form.OBJID.value = ",..QuoteJS(objid),";}",!
	If close=1 Set obj=""
	Quit ok
zformReqJS()
	Quit
zformSavJS()
	Write "      //invoke #server(csp.beddedit1.formSave())"
	Write !,"      result = "_"cspHttpServerMethod"_"('",..Encrypt($listbuild("csp.beddedit1.formSave"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""),"',1,'',objid"
	Write ",",!,"         (form.reclock == null || form.reclock == null) ? null : cspTrim(form.reclock.value)" ;%in1
	Write ",",!,"         (form.reclockuser == null || form.reclockuser == null) ? null : cspTrim(form.reclockuser.value)" ;%in2
	Write ",",!,"         (form.reclockdt == null || form.reclockdt == null) ? null : cspTrim(form.reclockdt.value)" ;%in3
	Write ",",!,"         cspGetRadioValue(form.Injury)" ;%in4
	Write ");",!
	Quit
zformSave(respond=0,errmsg="",objid="",%in1,%in2,%in3,%in4)
	New obj,sc,value,in,error,sverror,err,i,ok
	Set sc=1
	Set ok=1
	Set error=""
	Set sverror=""
	If (objid="") {
		Set obj = ##class(BEDD.EDVISIT).%New()
	} ElseIf '$isobject(objid) {
		Set obj = ##class(BEDD.EDVISIT).%OpenId(objid)
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
 ; RecLock 
 If $data(%in1) {
   Set value=$select(%in1="":"",1:##class(BEDD.EDVISIT).RecLockDisplayToLogical(%in1))
   If (%in1'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","reclock")_"\n"
   } Else {
     Set obj.RecLock=value
   }
 }
 ; RecLockUser 
 If $data(%in2) {
   Set value=$select(%in2="":"",1:##class(BEDD.EDVISIT).RecLockUserDisplayToLogical(%in2))
   If (%in2'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","reclockuser")_"\n"
   } Else {
     Set obj.RecLockUser=value
   }
 }
 ; RecLockDT 
 If $data(%in3) {
   Set value=$select(%in3="":"",1:##class(BEDD.EDVISIT).RecLockDTDisplayToLogical(%in3))
   If (%in3'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","reclockdt")_"\n"
   } Else {
     Set obj.RecLockDT=value
   }
 }
 ; Injury 
 If $data(%in4) {
   Set value=$select(%in4="":"",1:##class(BEDD.EDVISIT).InjuryDisplayToLogical(%in4))
   If (%in4'=""),(value="") {
     Set error=error_%response.GetText("","%CSPBind","InvalidValue","%1 has an invalid value.","Injury")_"\n"
   } Else {
     Set obj.Injury=value
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
 Set v("RecLock")=$ZSTRIP($get(%request.Data("reclock",1)),">W")
 Set v("RecLockUser")=$ZSTRIP($get(%request.Data("reclockuser",1)),">W")
 Set v("RecLockDT")=$ZSTRIP($get(%request.Data("reclockdt",1)),">W")
 Set v("Injury#1")=$get(%request.Data("Injury",1))
	If $get(objid)="" Set objid=$get(%request.Data("OBJID",1))
	Quit ..formSave(0,.errmsg,objid,v("RecLock"),v("RecLockUser"),v("RecLockDT"),v("Injury#1"))
zformValJS()
	Quit
zgetCodeBlue(edid)
 	Set cb=0
 	Set entry=##class(BEDD.EDVISIT).%OpenId(edid)
 	If (entry.CodeBlue = "")||(entry.CodeBlue = "No") {
 		Set cb=0
 	} Else {
 		Set cb=1
 	}
 	Quit cb
zgetDtChk(date,admdt,chk)
 Quit $$DTCHK^BEDDUTIU(date,admdt,chk)
zgetEDConCount(edid)
 	Quit $$EDCNT^BEDDUTIS(edid)
zgetEDDiagCount(edid)
 	Quit $$DXCNT^BEDDUTIS(edid)
zgetEDDiagPrm(vien)
 	//
 	Set POVInfo=$$GETPOV^BEDDPOV(vien)
 	//
 	// Check how many Diagnosises are assigned to this visit if 0 then
 	// no diagnosis is assigned to this visit quit and return 0
 	If $P(POVInfo,"^")=0 { Quit 0 }
 	// We have at least 1 diagnosis, count the number of diagnosises
 	// that have PrimaryDX = 'YES' if more than 1 then report the problem
 	// of too many primary diagnosises
 	If ($P(POVInfo,"^",2)> 1) { Quit 2 }
 	//No Primary on File
 	If ($P(POVInfo,"^",2) = 0) { Quit 0 }
 	//There is at least one Dx and only one is primary
 	Quit 1
zgetEDProcCount(edid)
 	Quit $$PRCNT^BEDDUTIS(edid)
zgetRmChk(objid,room)
 Quit $$RMCHK^BEDDUTW(objid,$G(room))
zgetTheDate()
 	Quit $$HTE^XLFDT($H,"5Z")
zsetRoom(selroom,objid,mydate,mytime)
 	Quit 
