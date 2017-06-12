 ;csp.beddlogin1.1
 ;(C)InterSystems, generated for class csp.beddlogin1.  Do NOT edit. 04/14/2017 08:47:51AM
 ;;382B6146;csp.beddlogin1
 ;
zOnPage()
	Do ..OnPageCSPROOT()
	Quit 1
zOnPageBODY()
	Write "<BODY bgcolor=#DCDCDC OnLoad=""document.BEDDLogin.Acode.focus();"">"
	Write !,"<script language='javascript'>"
	Write !,!,"function verify_user(Acode,Vcode){",!
	Write "	",!
	Write "	"_("cspHttpServerMethod")_"('"_(..Encrypt($listbuild($classname()_".getUser"))_$select(%session.UseSessionCookie'=2:"&CSPCHD="_%session.CSPSessionCookie,1:""))_"',Acode,Vcode);",!
	Write "	          ",!
	Write "	if( duz>1 ){",!
	Write "		alert(""Login successfull"");",!
	Write "		return true;",!
	Write "	}",!
	Write "	",!
	Write "	if( duz<1 ){",!
	Write "		alert(""Login Failed"");",!
	Write "		return false;",!
	Write "	}",!
	Write "}",!
	Write "</script>"
	Write !,!,"	"
	Write "<form action="""" method=""post"" name=""BEDDLogin"">"
	Write !,..InsertHiddenFields(""),!
	Write !,"	",!
	Write "	<table cellspacing=""3"" align=""center"" vspacing=""center"">",!
	Write "    <tr></tr><tr></tr><tr></tr><tr>",!
	Write "    	<td>"
	Write "<div align=""right"">"
	Write "<font face=""Times New Roman"" size=""+2"">Access Code:</font>"
	Write "</div>"
	Write "	</td>",!
	Write "    	<td>"
	Write "<input name=""Acode"" type=""password"">"
	Write "</td>",!
	Write "    	<tr></tr>",!
	Write "    	<td>"
	Write "<div align=""right"">"
	Write "<font face=""Times New Roman"" size=""+2"">Verify Code:</font>"
	Write "</div>"
	Write "</td>",!
	Write "		<td>"
	Write "<input type=""password"" name=""Vcode"">"
	Write "</td>",!
	Write "	</tr>",!
	Write "	<tr></tr>",!
	Write "		<td>"
	Write "<div align=""right"">"
	Write "<font face=""Times New Roman"" size=""+2"">Select the Site </font>"
	Write "</div>"
	Write "</td>",!
	Write "		<td>",!
	Write "		"
	Write "<select name=""BEDDSITE"">"
	Write !,"        	"
	Write "<option value="""">"
	Write "</option>",!
	Write "        	"
	Kill beddst
	Do SINIT^BEDDUTW()
	Do SITE^BEDDUTIL(.beddst)
	Set beddst=$O(beddst(""))
	While (beddst]"") {
	Write "<option value="_($P(beddst(beddst),"^",2))_"> "_($P(beddst(beddst),"^"))_" </option>",! 
	Set beddst=$O(beddst(beddst))
	}
	Write !,"			"
	Write "</select>"
	Write !,"		</td>",!
	Write "	<tr>",!
	Write "	",!
	Write "	</tr>",!
	Write "	<tr>",!
	Write "	<td>&nbsp;</td>",!
	Write "	<td>",!
	Write "	"
	Write "<input name=""Submit"" type=""submit"" value=""Login"">"
	Write !,"	"
	Write "<input name=""Whiteboard"" type=""submit"" value=""Whiteboard Login"">"
	Write !,"	</td>",!
	Write "   </tr>",!
	Write " </table>",!
	Write "</form>"
	Write !,!,!,!,!,"</BODY>"
	Quit
zOnPageCSPROOT()
	Write "<!-- BEDDLogin1.csp - Main BEDD ACCESS/VERIFY Entry Page -->"
	Write !,"<!-- ;;2.0;IHS EMERGENCY DEPT DASHBOARD;;Apr 02, 2014 -->"
	Write !
	Do ..OnPageHTML()
	Quit
zOnPageHEAD()
	Write "<HEAD>"
	Write !,"	<TITLE>	BEDD Emergency Room Dashboard Login </TITLE>",!
	Write !,(..HyperEventHead(0,0))
	Write "</HEAD>"
	Quit
zOnPageHTML()
	Write "<HTML>"
	Write !
	Do ..OnPageHEAD()
	Write !,"<h1><b>"
	Write "<div align=""center"">"
	Write "Welcome to the BEDD Emergency Room Dashboard Login"
	Write "</div>"
	Write "</b></h1>",!
	Write !
	Do ..OnPageBODY()
	Write !,"</HTML>"
	Quit
zOnPreHTTP(Acode,Vcode)
 	If $$VERSION^XPDUTL("BEDD")="" {
 		Set %response.Redirect=..Link("BEDDIL.csp?BEDD=No")
 		Quit 1
 	}
     If ($Data(%request.Data("Whiteboard",1))) {
 	   	Set beddac=$Get(%request.Data("Acode",1))
 		Set beddvc=$Get(%request.Data("Vcode",1))
 		Set Success=$$CHECKWB^BEDDPREF(beddac_";"_beddvc)
 		If Success=0 {
 			Set duz=$$CHECKAV^BEDDUTIL(beddac_";"_beddvc)
 			If duz>0 {
 				If $$AUTH^BEDDUTIL(duz)'=0 {
 					Set Success=1
 					D LOG^BEDDUTIU(duz,"S","","BEDDLogin1.csp","User logged into the ED Dashboard","")
 				}
 			}
 		}
 		If Success=1 {
 			Set %session.Data("SITE")="Whiteboard"
 			Set %session.Data("LOC")="SA"
 			Set %session.Data("DUZ")="99999"
 			Set %session.Data("Y")="0"
 			Set %response.Redirect=..Link("BEDD.csp?DUZ="_%session.Data("DUZ")_"&SITE="_%session.Data("SITE")_"&LOC=SA")
 			Quit 1
 		}
 		Else {
 			Set %response.Redirect=..Link("BEDDUA.csp?SITE="_%request.Get("BEDDSITE"))
 		}
     }
 	Kill beddac,beddvc,beddsite
 	Set beddac=$Get(%request.Data("Acode",1))
 	Set beddvc=$Get(%request.Data("Vcode",1))
 	If ((beddac="")&&(beddvc="")) Quit 1
 	Set %session.Data("DUZ")=$$CHECKAV^BEDDUTIL(beddac_";"_beddvc)
 	Set duz=%session.Data("DUZ")
 	If %session.Data("DUZ")<1 {
 		Set %response.Redirect=..Link("BEDDIL.csp")
 	} 
 	Elseif ($$AUTH^BEDDUTIL(%session.Data("DUZ"))=0) {
 		Set %response.Redirect=..Link("BEDDUA.csp?SITE="_%request.Get("BEDDSITE"))
 	}
 	Else {
 		Set beddsite=%request.Get("BEDDSITE")
 		Set %session.Data("SITE")=beddsite
 		Set %session.Data("LOC")="SA"
 		D LOG^BEDDUTIU(duz,"S","","BEDDLogin1.csp","User logged into the ED Dashboard","")
 		Set %response.Redirect=..Link("BEDD.csp?DUZ="_%session.Data("DUZ")_"&SITE="_beddsite_"&LOC=SA")
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
