BTIUDDL ; IHS/ITSC/LJF - LIST DOC DEFINITIONS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
EN ; -- main entry point for BTIU LIST DOC DEFS
 D EN^VALM("BTIU LIST DOC DEFS")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"CLINICAL DOCUMENTS HIERARCHY AT "_$$SITE
 Q
 ;
INIT ; -- init variables and list array
 D MSG^BTIUU("COMPILING LIST OF DOCUMENTS TITLES...",2,0,0)
 NEW TIUCNT,TIULVL K ^TMP("BTIUDDL",$J)
 S (TIUCNT,TIULVL)=0
 D DOCNM(38),ITEMS(38),OBJECTS
 S VALMCNT=TIUCNT
 S VALMSG=$$VALMSG^BTIUU
 Q
 ;
DOCNM(TIUN) ; -- sets up display line for item
 NEW TIUZ,TIUTM,X
 D ENP^XBDIQ1(8925.1,TIUN,".01:.04;.07","TIUZ(","I")
 I TIUZ(.04,"I")="CO"!(TIUZ(.04,"I")="O") Q  ;components & objects
 I TIUZ(.04,"I")'="DOC",'$O(^TIU(8925.1,TIUN,10,0)) Q  ;not used
 I TIUZ(.07)'="ACTIVE" Q  ;must be active
 S LINE=$$PAD($$SP(TIULVL)_$E($$NAME,1,50),55)_$$SP(5)
 S LINE=LINE_$S($O(^TIU(8925.1,TIUN,"HEAD",0)):"YES",1:" ")  ;okay to dictate
 D:(TIUZ(.04,"I")'="DOC") SET("") D:(TIUZ(.04,"I")="CL") SET("")
 D SET(LINE)
 Q
 ;
ITEMS(TIUN) ; -- finds all items tied to document definition
 NEW TIUTM,TIUX,TIUZZ,Y
 S TIULVL=$G(TIULVL)+1               ;increment level
 S TIUTM=0 F  S TIUTM=$O(^TIU(8925.1,TIUN,10,TIUTM)) Q:'TIUTM  D
 . S TIUX=+^TIU(8925.1,TIUN,10,TIUTM,0) Q:'TIUX
 . S TIUZZ($$GET1^DIQ(8925.1,TIUX,.01))=TIUX ;put in alpha order
 ;
 S TIUX=0 F  S TIUX=$O(TIUZZ(TIUX)) Q:TIUX=""  D
 . S Y=TIUZZ(TIUX) D DOCNM(Y),ITEMS(Y)  ;process this level
 S TIULVL=TIULVL-1                   ;return to previous level
 Q
 ;
OBJECTS ; -- list all available objects
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
SET(LINE) ; -- SUBRTN to set data line into ^tmp
 S TIUCNT=TIUCNT+1
 S ^TMP("BTIUDDL",$J,TIUCNT,0)=LINE
 S ^TMP("BTIUDDL",$J,"IDX",TIUCNT,TIUCNT)=""
 Q
 ;
SITE() ; -- returns site name
 Q $$GET1^DIQ(4,+DUZ(2),.01)
 ;
NAME() ; -- returns name
 Q TIUZ(.01)_$S(TIUZ(.04,"I")="CL":" CLASS",TIUZ(.04,"I")="DC":" DOCUMENT CLASS",1:"")
