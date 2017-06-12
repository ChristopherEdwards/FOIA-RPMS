 ;csp.beddlckit.1
 ;(C)InterSystems, generated for class csp.beddlckit.  Do NOT edit. 04/14/2017 08:47:51AM
 ;;6B785076;csp.beddlckit
 ;
zOnPage()
	Do ..OnPageCSPROOT()
	Quit 1
zOnPageBODY()
	Write "<body>"
	Write !,"	RECORD IS BEING UPDATED BY <BR> <h2>"_(user)_" &nbsp; "_($$HTE^XLFDT(editdt,"5Z"))_" </h2>",!
	Write "	Current user is: "_($$GET1^DIQ(200,%session.Data("DUZ"),".01","I"))_" <br>",!
	Write "    <br>",!
	Write "	<b>"
	Write "<div align=""center"">"
	Write "<a href="""_($zconvert(..Link("BEDD.csp"),"O","HTML"))_""">"
	Write "Return to ED Dashboard"
	Write "</a>"
	Write "</div>"
	Write "</b> ",!
	Write "</body>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDDLCKIT.csp - BEDD ED Locking Page -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014 -->"
	Write !
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<head>"
	Write !,!
	Set U="^",site=%session.Data("SITE")
	Do LOADSYS^BEDDUTW(.beddsys,site)
	Set timeout=$G(beddsys("TimeOut"))
	Write !,!,"<META HTTP-EQUIV=""Refresh"" CONTENT="""_( timeout )_"; URL=BEDD.csp"">"
	Write !,!,!,"</head>"
	Quit
zOnPageHTML()
	Write "<html>"
	Write !
	Do ..OnPageHEAD()
	Write !
	Do ..OnPageBODY()
	Write !,"</html>"
	Quit
zOnPreHTTP()
 	Set dfn=%request.Get("DFN"),objid=%request.Get("OBJID")
 	Set edvst=##class(BEDD.EDVISIT).%OpenId(objid)
 	// Check to see if record is locked if it is not locked or
 	// if this user has it locked then go to the edit page
 	If (+edvst.RecLock=0)||((+edvst.RecLock=1)&&(edvst.RecLockUser=%session.Data("DUZ"))) {
 		Set edvst.RecLock=1,edvst.RecLockDT=$H,edvst.RecLockUser=%session.Data("DUZ")
 		//BEDD*2.0*1;Added setting of new RecLockSite property
 		Set edvst.RecLockSite=$G(%session.Data("SITE"))
 		Set save=edvst.%Save()
 		Set edvst=""
 		Set %response.Redirect="BEDDEDIT1.csp?OBJID="_objid_"&DFN="_dfn
 		Q 1
 	}
 	// Otherwise tell this user that the record is locked and the user that has it locked
 	Set uien=edvst.RecLockUser,editdt=edvst.RecLockDT,myLock=edvst.RecLock 
 	Set edvst="",user="No Such User"
 	Set:uien]"" user=$$GET1^DIQ(200,uien_",",".01","I")
 	Q 1
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
