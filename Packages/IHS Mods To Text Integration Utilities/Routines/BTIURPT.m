BTIURPT ; IHS/ITSC/LJF - DRIVER TO VIEW PT'S DOCS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
MAIN ;PEP -- main driver
 ;can be called by other packages
 ; if other package already has patient selected, set TIUZIHS=pat ien
 ;
 NEW TIUZVIEW,TIUZSORT,TIUZLT
 ; -- ask user to pick browse mode
 S TIUZVIEW=+$$READ^TIUU("NO^1:2","List (1) TEXT or (2) TITLES",2,"^D HELPVIEW^BTIURPT") Q:TIUZVIEW<1
 ;
 ; -- ask user to pick date sort
 D MSG^BTIUU("",1,0,0)
 S TIUZSORT=+$$READ^TIUU("NO^1:2","Sort by (1) VISIT DATE OR (2) REFERENCE DATE",1,"^D HELPSORT^BTIURPT") Q:TIUZSORT<1
 ;
 ; -- based on sort, call list template
 S TIUZLT="BTIU "_$S(TIUZVIEW=1:"BROWSE BY ",1:"REVIEW BY ")_$S(TIUZSORT=1:"VISIT DATE",1:"REF DATE")
 D EN^VALM(TIUZLT)
 K TIULDT,TIUEDT,TIUZLN,TIUZCNT,TIUZIHS
 Q
 ;
 ;
HELPVIEW ;EP; -- help text for view by title or by text
 D MSG^BTIUU(" 1 List by TEXT displays the actual document text for a series of documents.",2,0,0)
 D MSG^BTIUU("    This assists in searching a series of notes for a specific word or phrase",1,0,0)
 D MSG^BTIUU("    or to quickly browse all notes on a patient.",1,0,0)
 D MSG^BTIUU(" 2 List by TITLE displays a patient's documents by title with author and",2,0,0)
 D MSG^BTIUU("    diagnosis.  This assists in finding a particular document to read.",1,0,0)
 Q
 ;
HELPSORT ;EP; -- help text for ref date vs. visit date question
 D MSG^BTIUU(" 1 Visit Date is the visit or admission date to which a document",2,0,0)
 D MSG^BTIUU("    linked.  This choice sorts by visit date then displays all documents",1,0,0)
 D MSG^BTIUU("    for the visit, no matter when those documents were entered.",1,0,0)
 D MSG^BTIUU(" 2 Reference Date is the date a document was either dictated or entered",2,0,0)
 D MSG^BTIUU("    into the system.",1,0,0)
 Q
 ;
 ;
HDR ;EP; -- set up header for IHS browse by patient templates
 NEW RANGE,NAME,DOCS K VALMHDR
 S RANGE=" from "_$$FMTE^XLFDT(TIUEDT,2)_" to "_$$FMTE^XLFDT($P(TIULDT,"."),2)
 S NAME=$$GET1^DIQ(2,$S($G(TIUZIHS):TIUZIHS,1:+$G(AUPNPAT)),.01)
 S VALMHDR(1)=$$CENTER^TIULS("For "_NAME_RANGE)
 S DOCS=$J(+$G(^TMP("TIUR",$J,0)),4)_" documents"
 S VALMHDR(1)=$$SETSTR^VALM1(DOCS,VALMHDR(1),(IOM-$L(DOCS)),$L(DOCS))
 Q
 ;
 ;
EDIT ;EP; edit action from browse all menu
 NEW BTIURPT S BTIURPT=1 D EDIT^TIURA,RESET Q
 ;
ADD ;EP; add action from browse all menu
 I '$G(TIUZIHS) S TIUZIHS=$G(DFN) I '$G(TIUZIHS) D RESET Q
 NEW BTIURPT S BTIURPT=1
 ;D CLEAR^VALM1 D MAIN^BTIUEDIT(38,"",TIUZIHS),RESET Q
 D CLEAR^VALM1 D ADD^TIURC,RESET Q
 ;
ADDEND ;EP; add addendum action from browse all menu
 NEW BTIURPT S BTIURPT=1 D ADDEND^TIURA1,RESET Q
 ;
RESET ;EP; -- called to rebuild ^tmp and return to list template
 I '$G(DFN) S DFN=$G(TIUZIHS) I 'DFN S VALMBCK="Q" Q
 S TIUCLASS=38 K VALMY
 D MSG^BTIUU("Updating Document List...Please Wait",1,0,0)
 I TIUZLT="BTIU REVIEW BY REF DATE" D REBUILD("APT^"_DFN,1)
 I TIUZLT="BTIU REVIEW BY VISIT DATE" D REBUILD("AIHS1^"_DFN,2)
 I TIUZLT="BTIU BROWSE BY REF DATE" D REBUILD("APT^"_DFN,3)
 I TIUZLT="BTIU BROWSE BY VISIT DATE" D REBUILD("AIHS1^"_DFN,4)
 I TIUZLT="BTIU BROWSE H&P" S TIUCLASS=22 D REBUILD("AIHS1^"_DFN,4)
 D HDR S VALMBCK="R",VALMSG=$$VALMSG^BTIUU
 Q
REBUILD(SORT,RTN) ;EP -- sets variables for rebuild after action performed
 NEW STATUS,SCREEN,X
 S STATUS=$$SELSTAT^TIULA(.TIUSTAT,"F","ALL")
 I +STATUS<0 S VALMQUIT=1 Q
 S SCREEN=1,SCREEN(1)=SORT
 ;S TIUCLASS=3
 S X="BUILD^BTIURPT"_RTN_"(.TIUSTAT,.TIUTYP,.SCREEN,TIUEDT,TIULDT)"
 D @X
 Q
 ;
VISIT(NOTE) ;EP; -- creates line of visit info
 ; NOTE=ien of document
 NEW VST,TIUZZ
 S VST=$$GET1^DIQ(8925,NOTE,.03,"I") Q:VST=""
 D ENP^XBDIQ1(9000010,VST,".01:.15","TIUZZ(","I")
 Q
 ;
NOTES(NOTE,DTORDER) ;EP -- creates ^tmp("tiur" to display text of notes
 ; -- TIUN=doc ien; DTORDER=type of date to print 1st (ref or visit)
 NEW TYP,TIUZZ,LINE
 D ENP^XBDIQ1(8925,NOTE,".01;.05;.06;1202;1208;1301","TIUZZ(","I")
 S LINE=$$PAD($$DATE(1,DTORDER,NOTE),7)
 S LINE=LINE_$$PAD($$DATE(2,DTORDER,NOTE),7) ;dates
 S LINE=LINE_$$PAD($E($$DOCNM,1,24),26)   ;doc name
 S LINE=LINE_$$PAD($$NAME^TIULS(TIUZZ(1202),"LAST, FI"),12) ;author
 S:TIUZZ(1208)]"" LINE=LINE_"/"
 S LINE=LINE_$$PAD($$NAME^TIULS(TIUZZ(1208),"LAST, FI"),12) ;cosigner
 S LINE=LINE_$E(TIUZZ(.05),1,11)                  ;status
 D TEXT(NOTE,LINE)
 Q
 ;
TEXT(NOTE,LINE) ; -- sets array of note texts so user can display comments
 NEW X
 D SET2(LINE,NOTE,1)
 ;D SET2(" "_$$REPEAT^XLFSTR("-",78),NOTE,0)
 ;
 S X=$$GET1^DIQ(8925,NOTE,.05)
 I (X="UNSIGNED")!(X="UNCOSIGNED") D SET2($$UNSIG(NOTE,X),NOTE,0)
 ;
 I '$$CANDO^TIULP(NOTE,"VIEW") D  Q
 . S X=$$SP(10)_"*** YOU MAY NOT VIEW THIS DOCUMENT ***"
 . D SET2(X,NOTE,0),SET2(" ",NOTE,0)
 ;
 S X=0 F  S X=$O(^TIU(8925,NOTE,"TEXT",X)) Q:'X  D
 . D SET2(^TIU(8925,NOTE,"TEXT",X,0),NOTE,0)
 D SET2(" "_$$REPEAT^XLFSTR("=",78),NOTE,0)
 D SET2(" ",NOTE,0)
 Q
SET2(LINE,IEN,NEW) ; -- SUBRTN to set data line into ^tmp for text
 S TIUZLN=TIUZLN+1
 S NUM=$S(NEW:$J(TIUCNT,2)_". ",1:$$SP(4))
 S ^TMP("TIUR",$J,TIUZLN,0)=NUM_LINE
 S ^TMP("TIUR",$J,"IDX",TIUZLN,TIUCNT)=IEN
 I NEW D FLDCTRL^VALM10(TIUZLN,"NUMBER",IOINHI,IOINORM)
 I NEW D FLDCTRL^VALM10(TIUZLN,"DOCUMENT",IOINHI,IOINORM)
 Q
 ;
DATE(N,O,NOTE) ; -- returns readable date
 I N=2 S O=$S(O="R":"V",1:"R") ;switch order for 2nd date
 I O="R" Q $P($$FMTE^XLFDT(TIUZZ(1301,"I"),2),"/",1,2)
 I O="V" Q $$VSTDT(NOTE)
 Q ""
 ;
VST(NOT) ; -- returns ien for visit
 Q $$GET1^DIQ(8925,NOT,.03,"I")
 ;
VSTDT(NOT) ;EP -- returns numdate of visit
 Q $P($$FMTE^XLFDT($$GET1^DIQ(9000010,+$$VST(NOT),.01,"I"),2),"/",1,2)
 ;
VSTCAT(NOT) ;EP -- returns service category of visit
 Q " "_$$GET1^DIQ(9000010,+$$VST(NOT),.07,"I")
 ;
VSTDX(NOT) ;EP -- returns prim dx for visit
 NEW TIUX,TIUV,TIUZ
 S TIUV=$$VST(NOT),TIUX=0
 F  S TIUX=$O(^AUPNVPOV("AD",TIUV,TIUX)) Q:'TIUX!$G(TIUZ)  D
 . I $$VSTCAT(NOT)="H" Q:$$GET1^DIQ(9000010.07,TIUX,.12,"I")'="P"
 . S TIUZ=$$GET1^DIQ(9000010.07,TIUX,.04)
 Q $G(TIUZ)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
DOCNM() ; -- returns formatted document name
 NEW DOC
 S DOC=$$PNAME^TIULC1(TIUZZ(.01,"I"))
 I DOC="Addendum" D
 . S DOC=DOC_" to "_$$GET1^DIQ(8925,+TIUZZ(.06,"I"),.01)
 I +$O(^TIU(8925,"DAD",+NOTE,0)),$$HASADDEN^TIULC1(NOTE) S DOC="+ "_DOC
 S TIUP=$$URGENCY^BTIURPT3(+NOTE)
 S:TIUP=1 DOC=$S(DOC["+":"*",1:"* ")_DOC
 Q DOC
 ;
SRV(NOTE) ;EP; -- returns service of note based on visit
 NEW ADDOK,VST,SRV,X
 S ADDOK=$$ADDSRV(NOTE)=0 I ADDOK=0 Q ""
 S VST=$$GET1^DIQ(8925,NOTE,.03,"I") I VST<1 Q ""
 ;
 ; -- clinic abbrev
 S SRV=$$GET1^DIQ(9000010,VST,.08,"I")
 I SRV Q $$GET1^DIQ(40.7,SRV,999999901)
 ;
 ; -- admit or disch serv abbrev
 S X=$O(^AUPNVINP("AD",VST,0)) I 'X Q ""
 S SRV=$$GET1^DIQ(9000010.02,X,$S(ADDOK=1:".06",1:".05"),"I")
 Q $$GET1^DIQ(45.7,+SRV,99)
 ;
ADDSRV(NOTE) ;EP -- returns 1 if okay to add service to doc title
 NEW X
 S X=$$GET1^DIQ(8925,NOTE,.01,"I") I X="" Q 0
 Q $$GET1^DIQ(8925.1,X,9999999.01,"I")
 ;
UNSIG(NOTE,STATUS) ;EP; -- returns unsigned note message
 Q $$SP(5)_IOINHI_STATUS_" Document!"_$$AUTHOR(NOTE)_IOINORM
 ;
AUTHOR(NOTE) ; -- returns author name and class
 Q " Author is "_$$TITLE(+$$GET1^DIQ(8925,NOTE,1202,"I"))
 ;
TITLE(USR) ; -- returns title for user
 NEW IFN,TITLE
 S IFN=0 F  S IFN=$O(^USR(8930.3,"B",USR,IFN)) Q:'IFN!($D(TITLE))  D
 . Q:'$$GET1^DIQ(8930.3,IFN,9999999.01,"I")
 . S TITLE=$$GET1^DIQ(8930.3,IFN,.02)
 Q $G(TITLE)
