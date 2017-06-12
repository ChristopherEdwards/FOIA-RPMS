 ;csp.bedd.1
 ;(C)InterSystems, generated for class csp.bedd.  Do NOT edit. 04/14/2017 08:47:50AM
 ;;69347935;csp.bedd
 ;
zOnPage()
	Do ..OnPageCSPROOT()
	Quit 1
zOnPageBODY()
	Write "<BODY>"
	Write !,!,"	Last update: &nbsp; <b> "_($$XNOW^BEDDUTIL())_"</b> &nbsp; &nbsp; ",!
	Write "	",!
	Write "	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	///Commenting out links at the top
	///&html<<a href="#Check-In">Check-In</a>&nbsp; &nbsp;
	///<a href="#Triage">Triage</a>&nbsp; &nbsp;
	///<a href="#Room Management">Room Management</a>&nbsp; &nbsp;
	///<a href="#Pending Documentation">Pending Documentation</a>>
	}
	Write "	",!
	Write !,"<table border=1 >",!
	Write !,"	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<tr><td><b>Check-In</b></td><td>Wtg</td><td>Avg Wtg</td><td bgcolor=""#C0C0C0"" rowspan=""2"">&nbsp;&nbsp;</td>",!
	Write "	<td><b>Triaged</b></td><td>Wtg</td><td>Avg Wtg</td><td bgcolor=""#C0C0C0"" rowspan=""2"">&nbsp;&nbsp;</td>",!
	Write "	<td><b>Rooms</b></td><td>Wtg</td><td>Avg Wtg</td><td bgcolor=""#C0C0C0"" rowspan=""2"">&nbsp;&nbsp;</b></td>",!
	Write "	<td><b>Pend</b></td><td>Wtg</td><td>Avg Wtg</td><td bgcolor=""#C0C0C0"" rowspan=""2"">&nbsp;&nbsp;</b></td>",!
	Write "	<td rowspan=""2"">",!
	Write "	&nbsp;&nbsp;",!
	Write "	<input type=""button"" id=""btnDC"" name=""btnDC"" value=""Discharges"" onclick='rpfeddc();'> &nbsp; &nbsp",!
	Write "	<input type=""button"" name=""btnMGR"" value=""Manager"" onclick='rpfedmgr("_(duz)_");'> &nbsp; &nbsp;",!
	Write "	<input type=""button"" id=""btnRefresh"" name=""btnRefresh"" value=""Resume Refresh"" ",!
	Write "	disabled=""true"" onclick='RestartRefresh();'>&nbsp;&nbsp;",!
	Write "	</td>",!
	Write "	</tr>",! 
	}
	Write !,!,"	"
	Write "<input type=""hidden"" id=""Whiteboard"" name=""Whiteboard"" value="""_(Whiteboard)_""" readonly/>"
	Write !,"	"
	Write "<input type=""hidden"" id=""RefreshID"" name=""RefreshID"" readonly/>"
	Write !,"		",!
	Write "	"
	Kill bedd
	Do BEDDLST^BEDDUTIL(.bedd,site)
	Write !,"				",!
	Write "	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_($P($G(bedd("TSUM",1)),"^"))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",1)),"^",2))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",1)),"^",3))_" &nbsp;</td>",! 	
	}
	Write !,!,"	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_($P($G(bedd("TSUM",2)),"^"))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",2)),"^",2))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",2)),"^",3))_" &nbsp;</td>",! 	
	}
	Write !,"  ",!
	Write "	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_($P($G(bedd("TSUM",3)),"^"))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",3)),"^",2))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",3)),"^",3))_" &nbsp;</td>",! 	
	}
	Write !,!,"	"
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_($P($G(bedd("TSUM",4)),"^"))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",4)),"^",2))_" &nbsp;</td>",! 
	Write "<td> "_($P($G(bedd("TSUM",4)),"^",3))_" &nbsp;</td>",! 
	}
	Write !,"</table>",!
	Write !,"<a name=""Check-In"" id=""Check-In"">"
	Write " "
	Write "</a>"
	Write !,!,"	"
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	Write !,!,"<table>",!
	Write "	",!
	Write "	<tr>",!
	Write "		<td width=150>",!
	Write "			<font color=""RED"" size=5> Check-In </font>",!
	Write "			"
	Write "<a name="_(iAnchor)," id="_(iAnchor),">"
	Write " "
	Write "</a>"
	Write !,"		</td>",!
	Write "		"
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Write "<td width=75>",!
	Write "	<a href=""#Triage"">Triage</a>",!
	Write "	</td>",!
	Write "	<td width=180>",!
	Write "	<a href=""#Room Management"">Room Management</a>",!
	Write "	</td>",!
	Write "	<td width=200>",!
	Write "	<a href=""#Pending Documentation"">Pending Documentation</a>",!
	Write "	</td>",! 
	}
	Write !,"	</tr>",!
	Write "</table>",!
	Write !,"<table border=1 >",!
	Write "	<tr>",!
	Write "		"
	Write "<th>Waiting</th>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<th>Check-In</th>",! 
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideSEX")) {
	Write "<th>Patient (gender)</th>",! 
	}
	If $D(beddsys("HideSEX")) {
	Write "<th>Patient </th>",! 
	}
	If '$D(beddsys("HideDOB")) {
	Write "<th>DOB (age) </th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Patient (Age)</th>",! 	
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Write "<th>Patient</th>",! 	
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Age</th>",! 
	}				
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<th>Chart</th>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<th>Chart</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<th>Presenting</th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<th>Presenting</th>",! 
	}
	}
	If ($D(beddsys("CLN"))) {
	Write "<th>Clinic </th>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<th>Info</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write "<th>Actions</th>",! 
	}
	Write "<th>Reg</th>",! 
	}
	Write "		",!
	Write "	</tr>",!
	Write !,"	"
	Set bgc="white" 
	Set beddien=""
	Set beddien=$O(bedd(1,beddien))
	While(beddien]"") {
	Do CHKLK^BEDDUTW(beddien,duz,$G(beddsys("TimeOut"))) ;Check Lock
	Set edid=##class(BEDD.EDVISIT).%OpenId(beddien)
	Set info=""
	Set info=$$DSPINFO^BEDDUTW(beddien)
	If (info="") {
	Set info="."
	}
	Set ptpc=""
	Set ptcc=""
	Set ptpc=$$GETCHIEF^BEDDGET(edid.VIEN,edid.Complaint,"P")
	Set ptcc=$$GETCHIEF^BEDDGET(edid.VIEN,edid.Complaint)
	Set ptactivity=""
	Set ptactivity=$$GETOSTAT^BEDDUTIL(edid.PtDFN)
	If (ptactivity="") {
	Set ptactivity="&nbsp;"
	}
	Set nrs=""
	If (edid.AsgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.AsgNrs,.01)
	}
	ElseIf (edid.TrgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.TrgNrs,.01)
	}
	Set prv=""
	If (edid.AsgPrv'=""&(edid.AsgPrv>0)) {
	Set prv=$$GETF^BEDDUTIL(200,edid.AsgPrv,.01)
	}
	Set trrow=trrow+1
	Set bgc=$Select(trrow#2:"#FFFFFF",1:"#C0C0C0")
	Write "<tr bgcolor="_(bgc)_">",! 
	Write "<td bgcolor="_(bgc)_"> "_(+edid.WtgTime)_"</td>",! 
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<td> "_(edid.PtCIDT)_" </td>",! 
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	///Name and Gender
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,$G(beddsys("NameFRMT")))
	If '$D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" ("_(edid.Sex)_") </a> </td>",! 
	}	
	If $D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" </a> </td>",! 
	}
	///DOB
	If '$D(beddsys("HideDOB")) {
	Write "<td> "_(edid.DOB)_" ("_(edid.Age)_") </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	///Name and Age
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" ("_(edid.Age)_") </a> </td>",! 
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" </a> </td>",! 
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<td> "_(edid.Age)_" </a> </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<td> "_(ptpc)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<td> "_(ptpc)_" </td>",! 
	}
	}
	If ($D(beddsys("CLN"))) {
	Write "<td> "_($$GETF^BEDDUTIL(40.7,edid.TrgCln,.01,"E"))_" &nbsp; </td>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<td> "_(info)_" &nbsp;</td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write " <td>  <input type=""radio"" name=""ptpgt"" onClick=""rpfptpg("_(beddien)_",1);"" />Trg Page",!
	Write "	<input type=""radio"" name=""ptpgr"" onClick=""rpfptpg("_(beddien)_",2);"" />Rm Page",!
	Write "	<input type=""radio"" name=""ptobs"" onClick=""rpfptpg("_(beddien)_",3);"" />Obsv",!
	Write "	<input type=""radio"" name=""pttrg"" onClick=""rpftrg("_(edid.PtDFN)_",4);"" />TrgRpt",!
	Write "	</td> ",! 
	}
	}
	Set dfn=edid.PtDFN
	Set %H=$H
	Do YX^%DTC
	Set bedddt=X
	Set regupd="Yes"
	Set bgc="white"
	If ($$GETF^BEDDUTIL(9000001,dfn_",",.03,"I")'=bedddt) {
	Set regupd="NO",bgc="yellow" 
	}
	If ($$GETF^BEDDUTIL(9000001,dfn_",",1108,"E")="NON-INDIAN BENEFICIARY") {
	Set regupd=regupd_"; NoBens"
	}
	Kill bedddt,X
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write " <td bgcolor="_(bgc)_" > "_(regupd)_" </td> ",! 
	}
	Set beddien=$O(bedd(1,beddien))
	}
	Write !,"	</tr>",!
	Write "</table>",!
	Write !,"<a name=""Triage"" id=""Triage"">"
	Write " "
	Write "</a>"
	Write " ",!
	Write !,"	"
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	Write !,!,"<table>",!
	Write "	<tr>",!
	Write "		<td width=150>",!
	Write "			<font color=""blue"" size=5> Triage </font>",!
	Write "			"
	Write "<a name="_(iAnchor)," id="_(iAnchor),">"
	Write " "
	Write "</a>"
	Write !,"		</td>",!
	Write "		"
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Write "<td width=100>",!
	Write "	<a href=""#Check-In"">Check-In</a>",!
	Write "	</td>",!
	Write "	<td width=180>",!
	Write "	<a href=""#Room Management"">Room Management</a>",!
	Write "	</td>",!
	Write "	<td width=200>",!
	Write "	<a href=""#Pending Documentation"">Pending Documentation</a>",!
	Write "	</td>",! 
	}
	Write !,"		",!
	Write "	</tr>",!
	Write "</table>",!
	Write !,"<table border=1 >",!
	Write "	<tr>",!
	Write "		"
	Write "<th>Waiting</th>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<th>Trg</th> <th>Time</th>",! 
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<th>Trg</th>",! 
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideSEX")) {
	Write "<th>Patient (gender)</th>",! 
	}
	If $D(beddsys("HideSEX")) {
	Write "<th>Patient </th>",! 
	}
	If '$D(beddsys("HideDOB")) {
	Write "<th>DOB (age) </th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Patient (Age)</th>",! 	
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Write "<th>Patient</th>",! 	
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Age</th>",! 
	}				
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<th>Chart</th>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<th>Chart</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<th>Order Activity</th>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<th>Clinic</th>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<th>Nurse</th>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<th>Provider</th>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<th>Consult</th>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<th>Info</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write "<th>Actions</th>",! 
	}
	Write "<th>Reg</th>",! 
	}
	Write "		",!
	Write "		",!
	Write "	</tr>",!
	Write !,"	"
	Set bgc="white" 
	Set beddtie=""
	Set beddtie=$O(bedd(2,beddtie))
	While(beddtie]"") {
	Set beddien=""
	Set beddien=$O(bedd(2,beddtie,beddien))
	While(beddien]"") {
	Do CHKLK^BEDDUTW(beddien,duz,$G(beddsys("TimeOut"))) ;Check Lock
	Set edid=##class(BEDD.EDVISIT).%OpenId(beddien) 
	Set info=""
	Set info=$$DSPINFO^BEDDUTW(beddien)
	If (info="") {
	Set info="."
	}
	Set ptcc=""
	Set ptcc=$$GETCHIEF^BEDDGET(edid.VIEN,edid.Complaint,,,1)
	If (ptcc="") {
	Set ptcc=edid.Complaint
	}
	Set ptactivity=""
	Set ptactivity=$$GETOSTAT^BEDDUTIL(edid.PtDFN)
	If (ptactivity="") {
	Set ptactivity="&nbsp;"
	}
	Set nrs=""			
	If (edid.AsgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.AsgNrs,.01)
	}
	ElseIf (edid.TrgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.TrgNrs,.01,"I")
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"FNLI")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"LN")
	}
	Set prv=""
	If (edid.AdmPrv'="") {
	Set prv=$$GETF^BEDDUTIL(200,edid.AdmPrv,.01,"I")
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"FLIF")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"LN")
	}
	Set econs="No"
	If ($$EDCNT^BEDDUTIS(beddien)>0) {
	Set econs="Yes"
	}
	Set trrow=trrow+1
	Set bgc="#FFFFFF"
	If (trrow#2=0) {
	Set bgc="#C0C0C0"
	}
	Write "<tr bgcolor="_(bgc)_">",! 
	Write "<td bgcolor="_(bgc)_"> "_(edid.WtgTime)_" </td>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<td> "_(edid.TrgA)_" </td>",! 
	Write "<td> "_($$HTIME^BEDDUTID(edid.TrgTm))_" </td>",! 
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<td> "_(edid.TrgA)_" </td>",! 
	}
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	///Name and Gender
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,$G(beddsys("NameFRMT")))
	If '$D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" ("_(edid.Sex)_") </a> </td>",! 
	}	
	If $D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" </a> </td>",! 
	}
	///DOB
	If '$D(beddsys("HideDOB")) {
	Write "<td> "_(edid.DOB)_" ("_(edid.Age)_") </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	///Name and Age
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" ("_(edid.Age)_") </a> </td>",! 
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" </a> </td>",! 
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<td> "_(edid.Age)_" </a> </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	}	
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<td> "_(ptcc)_" &nbsp; </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<td> "_(ptcc)_" &nbsp; </td>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<td> "_(ptactivity)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<td> "_($$GETF^BEDDUTIL(40.7,edid.TrgCln,.01,"E"))_" &nbsp; </td>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<td> "_(nrs)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<td> "_(prv)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<td> "_(econs)_" &nbsp;</td>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<td> "_(info)_" &nbsp;</td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write " <td>	",!
	Write "	<input type=""radio"" name=""ptpgr"" onClick=""rpfptpg("_(beddien)_",2);"" />Rm Page",!
	Write "	<input type=""radio"" name=""ptobs"" onClick=""rpfptpg("_(beddien)_",3);"" />Obsv",!
	Write "	<input type=""radio"" name=""pttrg"" onClick=""rpftrg("_(edid.PtDFN)_",4);"" />TrgRpt",!
	Write "	</td> ",! 
	}
	}
	Set dfn=edid.PtDFN
	Set %H=$H
	Do YX^%DTC
	Set bedddt=X
	Set regupd="Yes"
	Set bgc="white"
	If ($$GETF^BEDDUTIL(9000001,dfn_",",.03,"I")'=bedddt) {
	Set regupd="NO",bgc="yellow"
	}
	If ($$GETF^BEDDUTIL(9000001,dfn_",",1108,"E")="NON-INDIAN BENEFICIARY") {
	Set regupd=regupd_"; NoBens"
	}
	Kill bedddt,X
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write " <td bgcolor="_(bgc)_" > "_(regupd)_" </td> ",! 
	}
	Set edid=""
	Set beddien=$O(bedd(2,beddtie,beddien))
	}
	Set beddtie=$O(bedd(2,beddtie))
	}
	Write !,"</tr>",!
	Write "</table>",!
	Write !,"<a name=""Room Management"" id=""Room Management"">"
	Write "</a>"
	Write " ",!
	Write !,"	"
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	Write !,!,"<table>",!
	Write "	<tr>",!
	Write "		<td width=275>",!
	Write "			<font color=""black"" size=5> Room Management </font>",!
	Write "			"
	Write "<a name="_(iAnchor)," id="_(iAnchor),">"
	Write " "
	Write "</a>"
	Write !,"		</td>",!
	Write "		"
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Write "<td width=100>",!
	Write "	<a href=""#Check-In"">Check-In</a>",!
	Write "	</td>",!
	Write "	<td width=75>",!
	Write "	<a href=""#Triage"">Triage</a>",!
	Write "	</td>",!
	Write "	<td width=200>",!
	Write "	<a href=""#Pending Documentation"">Pending Documentation</a>",!
	Write "	</td>",! 
	}
	Write !,"	</tr>",!
	Write "</table>",!
	Write !,"<table border=1 >",!
	Write "	<tr>",!
	Write "	"
	Write "<th>Waiting</th>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<th>Room</th> <th>Trg</th>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowRoom")) {
	Write "<th>Room</th>",! 
	}
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<th>Trg</th>",! 
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideSEX")) {
	Write "<th>Patient (gender)</th>",! 
	}
	If $D(beddsys("HideSEX")) {
	Write "<th>Patient </th>",! 
	}
	If '$D(beddsys("HideDOB")) {
	Write "<th>DOB (age) </th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Patient (Age)</th>",! 	
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Write "<th>Patient</th>",! 	
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Age</th>",! 
	}				
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "</th> <th>Chart</th>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<th>Chart</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<th>Order Activity</th>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<th>Clinic</th>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<th>Nurse</th>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<th>Provider</th>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<th>Consult</th>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<th>Info</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write "<th>Actions</th>",! 
	}
	Write "<th>Reg</th>",! 
	}
	Write "	",!
	Write "	</tr>",!
	Write "				",!
	Write "	"
	Set bgc="white" 
	Set beddtie=""
	Set beddtie=$O(bedd(3,beddtie))
	While(beddtie]"") {
	Set beddien=""
	Set beddien=$O(bedd(3,beddtie,beddien))
	While(beddien]"") {
	Do CHKLK^BEDDUTW(beddien,duz,$G(beddsys("TimeOut"))) ;Check Lock
	Set edid=##class(BEDD.EDVISIT).%OpenId(beddien)
	Set info=""
	Set info=$$DSPINFO^BEDDUTW(beddien)
	If (info="") {
	Set info="."
	}
	Set ptcc=""
	Set ptcc=$$GETCHIEF^BEDDGET(edid.VIEN,edid.Complaint,,,1)
	If (ptcc="") {
	Set ptcc=edid.Complaint
	}
	Set ptactivity=""
	Set ptactivity=$$GETOSTAT^BEDDUTIL(edid.PtDFN)
	If (ptactivity="") {
	Set ptactivity="&nbsp;"
	}
	Set nrs=""
	If (edid.PrmNurse'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.PrmNurse,.01)
	}
	ElseIf (edid.AsgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.AsgNrs,.01)
	}
	ElseIf (edid.TrgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.TrgNrs,.01)
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"FNLI")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"LN")
	}
	Set prv=""
	If ((edid.AdmPrv'="")&&(edid.AdmPrv>0)) {
	Set prv=$$GETF^BEDDUTIL(200,edid.AdmPrv,.01)
	}		
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"FLIF")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"LN")
	}
	Set econs="No"
	If ($$EDCNT^BEDDUTIS(beddien)>0) {
	Set econs="Yes"
	}
	Set trrow=trrow+1
	Set bgc="#FFFFFF"
	If (trrow#2=0) {
	Set bgc="#C0C0C0"
	}
	Write "<tr bgcolor="_(bgc)_">",! 
	Write "<td bgcolor="_(bgc)_"> "_(+edid.WtgTime)_" </td>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<td> "_(edid.Room)_" </td>",! 
	Write "<td> "_(edid.TrgA)_" &nbsp;</td>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowRoom")) {
	Write "<td> "_(edid.Room)_" </td>",! 
	}
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<td> "_(edid.TrgA)_" &nbsp;</td>",! 	
	}
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	///Name and Gender
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,$G(beddsys("NameFRMT")))
	If '$D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" ("_(edid.Sex)_") </a> </td>",! 
	}	
	If $D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" </a> </td>",! 
	}
	///DOB
	If '$D(beddsys("HideDOB")) {
	Write "<td> "_(edid.DOB)_" ("_(edid.Age)_") </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	///Name and Age
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" ("_(edid.Age)_") </a> </td>",! 
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" </a> </td>",! 
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<td> "_(edid.Age)_" </a> </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<td> "_(ptcc)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<td> "_(ptcc)_" &nbsp; </td>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<td> "_(ptactivity)_" </td>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<td> "_($$GETF^BEDDUTIL(40.7,edid.TrgCln,.01,"E"))_" &nbsp; </td>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<td> "_(nrs)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<td> "_(prv)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<td> "_(econs)_" &nbsp;</td>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<td> "_(info)_" &nbsp;</td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If $D(beddsys("AN")) {
	Write " <td>",!
	Write "	<input type=""radio"" name=""ptpgr"" onClick=""rpfptpg("_(beddien)_",2);"" />Rm Page",!
	Write "	<input type=""radio"" name=""ptobs"" onClick=""rpfptpg("_(beddien)_",3);"" />Obsv",!
	Write "	<input type=""radio"" name=""pttrg"" onClick=""rpftrg("_(edid.PtDFN)_",4);"" />TrgRpt",!
	Write "	</td> ",! 
	}
	}
	Set dfn=edid.PtDFN
	Set %H=$H
	Do YX^%DTC
	Set bedddt=X
	Set regupd="Yes"
	Set bgc="white"
	If ($$GETF^BEDDUTIL(9000001,dfn_",",.03,"I")'=bedddt) {
	Set regupd="NO",bgc="yellow"
	}
	If ($$GETF^BEDDUTIL(9000001,dfn_",",1108,"E")="NON-INDIAN BENEFICIARY") {
	Set regupd=regupd_"; NoBens"
	}
	Kill bedddt,X
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write " <td bgcolor="_(bgc)_" > "_(regupd)_" </td> ",! 
	}
	Set edid=""
	Set beddien=$O(bedd(3,beddtie,beddien))
	}
	Set beddtie=$O(bedd(3,beddtie))
	}
	Write !,"	",!
	Write "	</tr>",!
	Write "</table>",!
	Write !,"<a name=""Pending Documentation"" id=""Pending Documentation"">"
	Write "</a>"
	Write " ",!
	Write !,!,"	"
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	Write !,!,"<table>",!
	Write "	<tr>",!
	Write "		<td width=325>",!
	Write "			<font color=""Green"" size=5> Pending Documentation </font>",!
	Write "			"
	Write "<a name="_(iAnchor)," id="_(iAnchor),">"
	Write " "
	Write "</a>"
	Write !,"		</td>",!
	Write "		"
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Write "<td width=100>",!
	Write "	<a href=""#Check-In"">Check-In</a>",!
	Write "	</td>",!
	Write "	<td width=75>",!
	Write "	<a href=""#Triage"">Triage</a>",!
	Write "	</td>",!
	Write "	<td width=200>",!
	Write "	<a href=""#Room Management"">Room Management</a>",!
	Write "	</td>",! 
	}
	Write !,"	</tr>",!
	Write "</table>",!
	Write !,"<table border=1 >",!
	Write "	<tr>",!
	Write "	"
	Write "<th>Waiting</th>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<th>Trg</th> <th>Time</th>",! 
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<th>Trg</th>",! 
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideSEX")) {
	Write "<th>Patient (gender)</th>",! 
	}
	If $D(beddsys("HideSEX")) {
	Write "<th>Patient </th>",! 
	}
	If '$D(beddsys("HideDOB")) {
	Write "<th>DOB (age) </th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Patient (Age)</th>",! 	
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Write "<th>Patient</th>",! 	
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<th>Age</th>",! 
	}				
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "</th> <th>Chart</th>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<th>Chart</th>",! 
	}
	}	
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<th>Chief Complaint</th>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<th>Order Activity</th>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<th>Clinic</th>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<th>Nurse</th>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<th>Provider</th>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<th>Consult</th>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<th>Info</th>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write "<th>Actions</th>",! 
	}
	Write "<th>Reg</th>",! 
	}
	Write "		",!
	Write "		",!
	Write "	</tr>",!
	Write !
	Set bgc="white" 
	Set beddtie=""
	Set beddtie=$O(bedd(4,beddtie))
	While(beddtie]"") {
	Set beddien=""
	Set beddien=$O(bedd(4,beddtie,beddien))
	While(beddien]"") {
	Do CHKLK^BEDDUTW(beddien,duz,$G(beddsys("TimeOut"))) ;Check Lock
	Set edid=##class(BEDD.EDVISIT).%OpenId(beddien) 
	Set info=""
	Set info=$$DSPINFO^BEDDUTW(beddien)
	If (info="") {
	Set info="."
	}
	Set ptcc=""
	Set ptcc=$$GETCHIEF^BEDDGET(edid.VIEN,edid.Complaint,,,1)
	If (ptcc="") {
	Set ptcc=edid.Complaint
	}
	Set ptactivity=""
	Set ptactivity=$$GETOSTAT^BEDDUTIL(edid.PtDFN)
	If (ptactivity="") {
	Set ptactivity="&nbsp;"
	}
	Set nrs=""			
	If (edid.PrmNurse'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.PrmNurse,.01)
	}
	ElseIf (edid.AsgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.AsgNrs,.01)
	}
	ElseIf (edid.TrgNrs'="") {
	Set nrs=$$GETF^BEDDUTIL(200,edid.TrgNrs,.01,"I")
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"FNLI")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set nrs=$$NMFRMT^BEDDPREF(nrs,"LN")
	}
	Set prv=""
	If (edid.AdmPrv'="") {
	Set prv=$$GETF^BEDDUTIL(200,edid.AdmPrv,.01,"I")
	}
	If $G(%session.Data("SITE"))="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"FLIF")
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {
	Set prv=$$NMFRMT^BEDDPREF(prv,"LN")
	}
	Set econs="No"
	If ($$EDCNT^BEDDUTIS(beddien)>0) {
	Set econs="Yes"
	}
	Set trrow=trrow+1
	Set bgc="#FFFFFF"
	If (trrow#2=0) {
	Set bgc="#C0C0C0"
	}
	Write "<tr bgcolor="_(bgc)_">",! 
	Write "<td bgcolor="_(bgc)_"> "_(+edid.WtgTime)_" </td>",! 
	If $G(%session.Data("SITE"))'="Whiteboard" {			
	Write "<td> "_(edid.TrgA)_" </td>",! 
	Write "<td> "_($$HTIME^BEDDUTID(edid.RClTm))_" </td>",! 
	}
	If ($G(%session.Data("SITE"))="Whiteboard")&($D(beddsys("PShowAcuity"))) {
	Write "<td> "_(edid.TrgA)_" </td>",! 
	}
	///Create dynamic anchor
	Set %session.Data("AnchorCount")=$G(%session.Data("AnchorCount"))+1
	Set iAnchor="Anchor"_%session.Data("AnchorCount")
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	///Name and Gender
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,$G(beddsys("NameFRMT")))
	If '$D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" ("_(edid.Sex)_") </a> </td>",! 
	}	
	If $D(beddsys("HideSEX")) {
	Write "<td> <a name="_(iAnchor)_" id="_(iAnchor)_" href=""BEDDLCKIT.csp?OBJID="_(beddien)_"&DFN="_(edid.PtDFN)_"""> "_(pName)_" </a> </td>",! 
	}
	///DOB
	If '$D(beddsys("HideDOB")) {
	Write "<td> "_(edid.DOB)_" ("_(edid.Age)_") </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	///Name and Age
	If $D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" ("_(edid.Age)_") </a> </td>",! 
	}
	If $D(beddsys("PShowName"))&'$D(beddsys("PShowAge")) {
	Set pName=$$NMFRMT^BEDDPREF(edid.PtName,"ILIF")
	Write "<td> "_(pName)_" </a> </td>",! 
	}
	If '$D(beddsys("PShowName"))&$D(beddsys("PShowAge")) {
	Write "<td> "_(edid.Age)_" </a> </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowChartNumber")) {
	Write "<td> "_(edid.Chart)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If '$D(beddsys("HideCOMP")) {
	Write "<td> "_(ptcc)_" </td>",! 
	}
	}
	If $G(%session.Data("SITE"))="Whiteboard" {	
	If $D(beddsys("PShowComplaint")) {
	Write "<td> "_(ptcc)_" &nbsp; </td>",! 
	}
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowOrders")) {	
	Write "<td> "_(ptactivity)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("CLN"))) {
	Write "<td> "_($$GETF^BEDDUTIL(40.7,edid.TrgCln,.01,"E"))_" &nbsp; </td>",! 
	}
	If ($D(beddsys("SN")))!($D(beddsys("PShowNurse"))) {
	Write "<td> "_(nrs)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("PRV")))!($D(beddsys("PShowProv"))) {
	Write "<td> "_(prv)_" &nbsp;</td>",! 
	}
	If ($D(beddsys("CONS"))) {
	Write "<td> "_(econs)_" &nbsp;</td>",! 
	}
	If ($G(%session.Data("SITE"))'="Whiteboard")!$D(beddsys("PShowNotes")) {	
	If ($D(beddsys("COMBRD")))!$D(beddsys("PShowNotes")) {
	Write "<td> "_(info)_" &nbsp;</td>",! 
	}
	}
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	If ($D(beddsys("AN"))) {
	Write " <td>	",!
	Write "	<input type=""radio"" name=""ptpgr"" onClick=""rpfptpg("_(beddien)_",2);"" />Rm Page",!
	Write "	<input type=""radio"" name=""ptobs"" onClick=""rpfptpg("_(beddien)_",3);"" />Obsv",!
	Write "	<input type=""radio"" name=""pttrg"" onClick=""rpftrg("_(edid.PtDFN)_",4);"" />TrgRpt",!
	Write "	</td> ",! 
	}
	}
	Set dfn=edid.PtDFN
	Set %H=$H
	Do YX^%DTC
	Set bedddt=X
	Set regupd="Yes"
	Set bgc="white"
	If ($$GETF^BEDDUTIL(9000001,dfn_",",.03,"I")'=bedddt) {
	Set regupd="NO",bgc="yellow"
	}
	If ($$GETF^BEDDUTIL(9000001,dfn_",",1108,"E")="NON-INDIAN BENEFICIARY") {
	Set regupd=regupd_"; NoBens"
	}
	Kill bedddt,X
	If $G(%session.Data("SITE"))'="Whiteboard" {	
	Write " <td bgcolor="_(bgc)_" > "_(regupd)_" </td> ",! 
	}
	Set edid=""
	Set beddien=$O(bedd(4,beddtie,beddien))
	}
	Set beddtie=$O(bedd(4,beddtie))
	}
	Write !,"</tr>",!
	Write "</table>",!
	Write !,!,!,"<hr>",!
	Write !,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,!,"</BODY>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDD.csp - Main BEDD ED Dashboard -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014 -->"
	Write !,"<!-- BEDD*2.0*1;Modified page to hide DOB, Sex, Complaint, and format patient name -->"
	Write !,"<!-- Added Whiteboard view -->"
	Write !,"<!-- Added Screen Pause and Scroll to Previous Position -->"
	Write !,!
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<HEAD>"
	Write !,!,!,"<!-- BEDD*2.0*1;Switching Refresh to Javascript -->"
	Write !,"<!--<META HTTP-EQUIV=REFRESH CONTENT=60> -->"
	Write !,"<TITLE>	Emergency Department Tracking Board </TITLE>",!
	Write !
	Set duz=%session.Data("DUZ")
	Set site=%session.Data("SITE")
	Set loc=%session.Data("LOC")
	///Save Current Anchor Count and Reset
	Set %session.Data("AnchorCountPrev")=$G(%session.Data("AnchorCount"))
	Set %session.Data("AnchorCount")=0
	Kill beddsys
	Do LOADSYS^BEDDUTW(.beddsys,site,duz)
	Set %session.AppTimeout=172800  //Change Session Timeout
	Set (cirow,trrow,rmrow)=0
	Set Begdt=$P($H,",",1)
	Set Whiteboard=0
	If $G(%session.Data("SITE"))="Whiteboard" {	
	Set Whiteboard=1
	}
	Write !,!,"<!-- Refresh Handling -->"
	Write !,"<script language=""JavaScript"" type=""text/javascript"">"
	Write !,!,"	window.onload = function() {",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getWhiteboard"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "		//There is no button for Whiteboard",!
	Write "		var tWhiteboard = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getWhiteboard"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write !,"   		if (tWhiteboard==0) {",!
	Write "	   		document.getElementById('btnRefresh').style.visibility = 'hidden';",!
	Write "   		}",!
	Write "		document.body.style.background = ""#FFFFFF"";",!
	Write "   		setInterval (""saveScroll()"",3000);",!
	Write !,"    	if ((document.hasFocus)||(tWhiteboard==1)) {",!
	Write "   			setInterval (""CheckFocus ()"", 2000);",!
	Write "   		}",!
	Write "   		setScroll();",!
	Write "	}",!
	Write !,"	function CheckFocus () {",!
	Write !,"		var tWhiteboard = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getWhiteboard"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "	    if ((document.hasFocus ())||(tWhiteboard==1)) {",!
	Write !,"   			if (tWhiteboard==0) {",!
	Write "		    	document.getElementById('btnRefresh').style.visibility = 'hidden';",!
	Write "   			}",!
	Write "			var RefreshIDfocusIn = setInterval(""window.location.reload()"",45000);",!
	Write "			var RefreshID = document.getElementById('RefreshID');",!
	Write "			document.body.style.background = ""#FFFFFF"";",!
	Write "			RefreshID.value = RefreshIDfocusIn;",!
	Write "    	}",!
	Write "    	else {",!
	Write "   			if (tWhiteboard==0) {",!
	Write "				var ClearID = document.getElementById(""RefreshID"");",!
	Write "				clearInterval(ClearID.value);",!
	Write "		   		document.getElementById('btnRefresh').style.visibility = 'visible';",!
	Write "  				document.getElementById('btnRefresh').disabled = false;",!
	Write "  				document.body.style.background = ""#D3D3D3"";",!
	Write "    		}",!
	Write "    	}",!
	Write "	}",!
	Write "    	",!
	Write "	function RestartRefresh () {",!
	Write "   ",!
	Write "    	if (document.hasFocus ()) {",!
	Write "    		document.getElementById('btnDC').focus();",!
	Write "			var tWhiteboard = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getWhiteboard"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "   			if (tWhiteboard==0) {",!
	Write "    			document.getElementById('btnRefresh').style.visibility = 'hidden';",!
	Write "				var RefreshIDfocusIn = setInterval(""window.location.reload()"",200);",!
	Write "				var RefreshID = document.getElementById('RefreshID');",!
	Write "				RefreshID.value = RefreshIDfocusIn;",!
	Write "				document.body.style.background = ""#FFFFFF"";",!
	Write "				window.location.reload(true);",!
	Write "   			}",!
	Write "    	}",!
	Write "	}",!
	Write !,"</script>"
	Write !,!,"<!-- BEDD*2.0*1 - New code handle refresh scrolling position -->"
	Write !,"<!-- Code found from web search - returns x position as well but we only use y -->"
	Write !,"<script language=""JavaScript"" type=""text/javascript"">"
	Write !,!,"	//get scroll position",!
	Write "	var get_scroll = function(){",!
	Write "		var x = 0, y = 0;",!
	Write "	",!
	Write "		if( typeof( window.pageYOffset ) == 'number' ) {",!
	Write "   			//Netscape compliant",!
	Write "   			y = window.pageYOffset;",!
	Write "   			x = window.pageXOffset;",!
	Write "		}",!
	Write "		else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {",!
	Write "   			//DOM compliant",!
	Write "   			y = document.body.scrollTop;",!
	Write "   			x = document.body.scrollLeft;",!
	Write "		}",!
	Write "		else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {",!
	Write "   			//IE6 standards compliant mode",!
	Write "   			y = document.documentElement.scrollTop;",!
	Write "   			x = document.documentElement.scrollLeft; ",!
	Write "		}",!
	Write "		var obj = new Object();",!
	Write "		obj.x = x;",!
	Write "		obj.y = y;",!
	Write "		return obj;",!
	Write "	}",!
	Write "		",!
	Write "	function saveScroll(){",!
	Write !,"		var scroll = get_scroll(); ",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".setScrollY"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',scroll.y);",!
	Write "				",!
	Write "	}",!
	Write !,"	function setScroll(){",!
	Write "	",!
	Write "		var ScrollY = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getScrollY"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write !,"		//Get the display mode",!
	Write "		var SAmode = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getSAmode"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write !,"		//Standalone mode",!
	Write "		if (SAmode == ""SA"") {",!
	Write "			window.scrollTo(0,ScrollY);",!
	Write "		}",!
	Write !,"		//EHR mode",!
	Write "		if (SAmode == ""EHR"") {",!
	Write "			var astop = f_scrollTop();",!
	Write !,"			//Loop through anchors",!
	Write "			var AnchorMax = "_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getAnchorMax"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"');",!
	Write "			var AnchorPos=0;",!
	Write "			AnchorPos = getAnchorPosition('Anchor3');",!
	Write "			var AnchorName=""Anchor"";",!
	Write "			for(i=AnchorMax; i>0; i--) {",!
	Write "				AnchorName = ""Anchor"".concat(i);",!
	Write "				AnchorPos = getAnchorPosition(AnchorName);",!
	Write "				if ((ScrollY)>=AnchorPos.y) {",!
	Write "					window.location.hash = AnchorName;",!
	Write "					return;",!
	Write "				}",!
	Write "			}		",!
	Write "		}",!
	Write "	}",!
	Write "	",!
	Write "	function f_scrollTop() {",!
	Write "    	",!
	Write "    	var scrollTop;",!
	Write "    	if(typeof(window.pageYOffset) == 'number' ){",!
	Write "	        // DOM compliant, IE9+",!
	Write "	        scrollTop = window.pageYOffset;",!
	Write "	    }",!
	Write "    	else {",!
	Write "	        // IE6-8 workaround",!
	Write "	        if(document.body && document.body.scrollTop) {",!
	Write "            	// IE quirks mode",!
	Write "            	scrollTop = document.body.scrollTop;",!
	Write "        	}",!
	Write "        	else if(document.documentElement && document.documentElement.scrollTop) {",!
	Write "	            // IE6+ standards compliant mode",!
	Write "    	        scrollTop = document.documentElement.scrollTop;",!
	Write "    	    }",!
	Write "    	}",!
	Write "    	return scrollTop;",!
	Write "	}",!
	Write !,"</script>"
	Write !,!,"<script language=""JavaScript"" type=""text/javascript"">"
	Write !,!,"	function getAnchorPosition(anchorname) {",!
	Write "	",!
	Write "		// This function will return an Object with x and y properties",!
	Write "		var useWindow=false;",!
	Write "		var coordinates=new Object();",!
	Write "		var x=0,y=0;",!
	Write "		// Browser capability sniffing",!
	Write "		var use_gebi=false, use_css=false, use_layers=false;",!
	Write "		",!
	Write "		if (document.getElementById) { use_gebi=true; }",!
	Write "		",!
	Write "		else if (document.all) { use_css=true; }",!
	Write "		",!
	Write "		else if (document.layers) { use_layers=true; }",!
	Write "		",!
	Write "		// Logic to find position",!
	Write " 		if (use_gebi && document.all) {",!
	Write "			x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);",!
	Write "			y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);",!
	Write "		}",!
	Write "		else if (use_gebi) {",!
	Write "			var o=document.getElementById(anchorname);",!
	Write "			x=AnchorPosition_getPageOffsetLeft(o);",!
	Write "			y=AnchorPosition_getPageOffsetTop(o);",!
	Write "		}",!
	Write " 		else if (use_css) {",!
	Write "			x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);",!
	Write "			y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);",!
	Write "		}",!
	Write "		else if (use_layers) {",!
	Write "			var found=0;",!
	Write "			for (var i=0; i<document.anchors.length; i++) {",!
	Write "				if (document.anchors[i].name==anchorname) { found=1; break; }",!
	Write "			}",!
	Write "			if (found==0) {",!
	Write "				coordinates.x=0; coordinates.y=0; return coordinates;",!
	Write "			}",!
	Write "			x=document.anchors[i].x;",!
	Write "			y=document.anchors[i].y;",!
	Write "		}",!
	Write "		else {",!
	Write "			coordinates.x=0; coordinates.y=0; return coordinates;",!
	Write "		}",!
	Write "		coordinates.x=x;",!
	Write "		coordinates.y=y;",!
	Write "		return coordinates;",!
	Write "	}",!
	Write !,"	//getAnchorWindowPosition(anchorname)",!
	Write "	//   This function returns an object having .x and .y properties which are the coordinates",!
	Write "	//   of the named anchor, relative to the window",!
	Write "	function getAnchorWindowPosition(anchorname) {",!
	Write "		",!
	Write "		var coordinates=getAnchorPosition(anchorname);",!
	Write "		var x=0;",!
	Write "		var y=0;",!
	Write "	",!
	Write "		if (document.getElementById) {",!
	Write "			if (isNaN(window.screenX)) {",!
	Write "				x=coordinates.x-document.body.scrollLeft+window.screenLeft;",!
	Write "				y=coordinates.y-document.body.scrollTop+window.screenTop;",!
	Write "			}",!
	Write "			else {",!
	Write "				x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;",!
	Write "				y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;",!
	Write "			}",!
	Write "		}",!
	Write "		else if (document.all) {",!
	Write "			x=coordinates.x-document.body.scrollLeft+window.screenLeft;",!
	Write "			y=coordinates.y-document.body.scrollTop+window.screenTop;",!
	Write "		}",!
	Write "		else if (document.layers) {",!
	Write "			x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;",!
	Write "			y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;",!
	Write "		}",!
	Write "		coordinates.x=x;",!
	Write "		coordinates.y=y;",!
	Write "		return coordinates;",!
	Write "	}",!
	Write !,"	// Functions for IE to get position of an object",!
	Write "	function AnchorPosition_getPageOffsetLeft (el) {",!
	Write "		",!
	Write "		var ol=el.offsetLeft;",!
	Write "		while ((el=el.offsetParent) != null) { ol += el.offsetLeft; }",!
	Write "		return ol;",!
	Write "	}",!
	Write "	",!
	Write "	function AnchorPosition_getWindowOffsetLeft (el) {",!
	Write "		",!
	Write "		return AnchorPosition_getPageOffsetLeft(el)-document.body.scrollLeft;",!
	Write "	}	",!
	Write "	",!
	Write "	function AnchorPosition_getPageOffsetTop (el) {",!
	Write "		",!
	Write "		var ot=el.offsetTop;",!
	Write "		while((el=el.offsetParent) != null) { ot += el.offsetTop; }",!
	Write "		return ot;",!
	Write "	}",!
	Write "	",!
	Write "	function AnchorPosition_getWindowOffsetTop (el) {",!
	Write "		",!
	Write "		return AnchorPosition_getPageOffsetTop(el)-document.body.scrollTop;",!
	Write "	}",!
	Write !,"</script>"
	Write !,!,"<script language=""JavaScript"" type=""text/javascript"">"
	Write !,!,"	function popup(mylink, windowname) {",!
	Write "		",!
	Write "		if (! window.focus) { ",!
	Write "			return true; ",!
	Write "		}	",!
	Write "		var href;",!
	Write "		if (typeof(mylink) == 'string') {",!
	Write "   			href=mylink;",!
	Write "		}",!
	Write "		else {",!
	Write "   			href=mylink.href;",!
	Write "			window.open(href, windowname, 'width=600,height=400,scrollbars=yes');",!
	Write "			return false;",!
	Write "		}",!
	Write "	}",!
	Write !,"	function rpfset(vutable,rpfchk) {",!
	Write "		alert( 'tbl= ' + vutable + 'chk= ' + rpfchk  ); ",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".setMyED"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',vutable,rpfchk) ",!
	Write "  	}",!
	Write !,"</script>"
	Write !,!,"<script type=""text/javascript"">"
	Write !,"	",!
	Write "	function rpfeddc() {",!
	Write "		",!
	Write "		self.document.location = ""BEDDEDC.csp"";",!
	Write "	",!
	Write "	}",!
	Write "	",!
	Write "	function rpfedmgr(duz) {",!
	Write "		",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".keychk"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',duz);",!
	Write "	",!
	Write "	}",!
	Write "	",!
	Write "	function rpfptpg(objid,msg) {",!
	Write "		",!
	Write "		var duz = "_(%session.Data("DUZ"))_";",!
	Write "		"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".ptpg"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',objid,msg,duz);",!
	Write "		",!
	Write "	}",!
	Write "	",!
	Write "	function rpftrg(dfn) {",!
	Write "		",!
	Write "		var duz = "_(%session.Data("DUZ"))_";",!
	Write "		self.document.location = ""BEDDTRG.csp?DFN="" + dfn + ""&DUZ="" + duz;",!
	Write "		",!
	Write "	}",!
	Write "	",!
	Write "</script>"
	Write " ",!
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
zOnPreHTTP()
 If ('$D(^BEDD.EDSYSTEMD)) {
 	Set %response.Redirect="BEDDAPPL.EDSYSTEM.cls"
 	Quit 1
 }
 If ('$D(%session.Data("DUZ"))) {
 	Set %response.Redirect="BEDDLogin.csp"
 	Quit 1
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
zgetAnchorMax()
 	Set Anchor=$G(%session.Data("AnchorCount"))	
 	Quit Anchor
zgetSAmode()
 	Set SA=$G(%session.Data("LOC"))	
 	Quit SA
zgetScrollY()
 	Set ScrollY=+$G(%session.Data("Y"))	
 	Quit ScrollY
zgetWhiteboard()
 	Set tWhiteboard=$G(%session.Data("SITE"))
 	Set Return=0
 		If tWhiteboard="Whiteboard" {
 		Set Return=1
 	}
 	Quit Return
zkeychk(duz)
     If (duz="") {
 	    Quit 1
     }
     Set XUF=0
     Set U="^"
     If ($$KEYCK^BEDDUTID(duz)) {
 	    Write "self.document.location = ""BEDDAPPL.EDManager.cls""",! 
     }
     ElseIf ('$$KEYCK^BEDDUTID(duz)) {
 		Write "alert('RESTRICTED ACCESS');",! 
     }
     Quit 1
zlogEvent(Event)
 //Temporary call - used to debug issues
 Do NOW^%DTC
 Quit
zptpg(id,msg,duz)
 	Set msgnt=""
 	If (msg=1) {
 		Set msgnt="Paged for Triage"
 	}
 	If (msg=2) {
 		Set msgnt="Paged for Room"
 	}
 	If (msg=3) {
 		Set msgnt="Pt Observed"
 	}
 	L +^BEDD.EDVISIT(id):15 If ($T) {
 		Set entry=##class(BEDD.EDVISIT).%OpenId(id)
 		Set rpfsize=entry.Info.SizeGet()
 		Set rpfinfo=entry.Info.Read(rpfsize)
 		Set myToday=$$XNOW^BEDDUTIL()
 		Set myToday=$P(myToday,"@",1)_" "_$P(myToday,"@",2)
 		Set rpfinfo=rpfinfo_msgnt_" on "_myToday_" by "_$$GETF^BEDDUTIL(200,duz,.01,"E")_"; "
 		Set message=msgnt_" on "_myToday_" by "_$$GETF^BEDDUTIL(200,duz,.01,"E")
 		Do entry.Info.Write(rpfinfo)
 		Set statchk=entry.%Save()
 		If (statchk'=1) {
 			Write "alert('not saved' );",! 
 		}
 		If (statchk=1) {
 			Write "alert('Message Added: "_(message)_"' );",! 
 		}
 		Set entry=""
 		Kill statchk,entry
 		Lock -^BEDD.EDVISIT(id)
 	}
 	Kill msgnt,msg
 	Write "javascript:location.reload(true)",! 
 	Quit
zsetMyED(vutable,rpfchk)
 	Write "alert('checkin ' + "_(vutable)_" + "_(rpfchk)_");",! 
 	If (rpfchk="0") {
 		Set MYEDVU(vutable)=""
 	}
 	If (rpfchk="1") {
 		Kill MYEDVU(vutable)
 	}
 	Quit
zsetScrollY(ScrollY)
 	Set cvtScroll=ScrollY
 	Set %session.Data("Y")=+$G(cvtScroll)
 	Quit
