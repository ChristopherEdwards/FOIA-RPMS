 ;csp.beddlckrel.1
 ;(C)InterSystems, generated for class csp.beddlckrel.  Do NOT edit. 04/14/2017 08:47:51AM
 ;;726B6274;csp.beddlckrel
 ;
zOnPage()
	Do ..OnPageCSPROOT()
	Quit 1
zOnPageBODY()
	Write "<body>"
	Write !,!,"<h4><font color=""RED""> RECORD LOCKS &nbsp; &nbsp; </font>",!
	Write "<b>"
	Write "<div align=""center"">"
	Write "<a href="""_($zconvert(..Link("BEDDAPPL.EDManager.cls"),"O","HTML"))_""">"
	Write "Manager Home Page"
	Write "</a>"
	Write "</div>"
	Write "</b> </h4>",!
	Write !,"<table border=1 >",!
	Write "	<tr>",!
	Write "		"
	Write "<th>Check-In</th><th>Patient (gender)</th><th>DOB (age) </th>",! 
	Write "<th>Chart</th><th>Locked by User </th><th>Locked Date/Time</th>",! 
	Write "		",!
	Write "	</tr>",!
	Write !
	Kill beddlst,trrow
	Do LKLST^BEDDUTW(.beddlst,$G(site),$G(duz))
	Set bgc="white"
	Set trrow=0
	Set beddlst=$O(beddlst(""))
	While (beddlst]"") { 
	Set edid=##class(BEDD.EDVISIT).%OpenId(beddlst)
	Set trrow=trrow+1 s bgc="#FFFFFF" I trrow#2=0 s bgc="#C0C0C0"
	Write "<tr bgcolor="_(bgc)_">",! 
	Write "<td> "_(edid.PtCIDT)_" </td>",! 
	Write "<td> <a href=""BEDDUNLOCK.csp?OBJID="_(beddlst)_"&DFN="_(edid.PtDFN)_"""> "_(edid.PtName)_" ("_(edid.Sex)_") </a> </td>",! 
	Write "<td> "_(edid.DOB)_" ("_(edid.Age)_") </td>",! 
	Write "<td> "_(edid.Chart)_" </td>",! 
	Write "<td> "_($$GETF^BEDDUTIL(200,edid.RecLockUser,.01,"E"))_" </td>",! 	
	Write "<td> "_($TR($$HTE^XLFDT(edid.RecLockDT,"2ZM"),"@"," "))_" </td>",! 
	Set beddlst=$O(beddlst(beddlst))
	}
	Write !,"	</tr>",!
	Write "</table>",!
	Write !,"</body>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDDLCKREL.csp - BEDD Locked Records Listing -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014 -->"
	Write !
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<head>"
	Write !,!,"</head>"
	Quit
zOnPageHTML()
	Write "<HTML>"
	Write !,!
	Set U="^",site=%session.Data("SITE")
	Do LOADSYS^BEDDUTW(.beddsys,site)
	Set timeout=$G(beddsys("TimeOut"))
	Set duz=%session.Data("DUZ")
	Write !,!,"<META HTTP-EQUIV=""Refresh"" CONTENT="""_( timeout )_"; URL=BEDD.csp"">"
	Write !,!
	Do ..OnPageHEAD()
	Write !,!
	Do ..OnPageBODY()
	Write !,"</HTML>"
	Quit
