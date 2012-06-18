BDGPI ; IHS/ANMC/LJF,WAR - PATIENT INQUIRY ;  [ 01/05/2005  10:24 AM ]
 ;;5.3;PIMS;**1001,1003**;MAY 28, 2004
 ;IHS/ITSC/LJF 5/27/2004 PATCH 1001 added Admission LOS to display
 ;             5/13/2005 PATCH 1003 added parameter to day surgery expanded view
 ;
 NEW DFN
 F  S DFN=+$$READ^BDGF("PO^2:EMQZ","Select PATIENT") Q:DFN<1  D EN
 D EXIT
 Q
 ;
EN ; -- main entry point for BDG PATIENT INQUIRY
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG PATIENT INQUIRY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"*** "_$$CONF^BDGF_" ***"
 Q
 ;
INIT ; -- init variables and list array
 D MSG^BDGF("Compiling patient's data...",1,0)
 NEW X,BDGI,BDGS
 S VALMCNT=0 K ^TMP("BDGPI",$J)
 S BDGS=0 F BDGI=1:1:6 S X="SECTION"_BDGI,BDGS=BDGS+1 D @X
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGPI",$J) K SCDT2,SCP,DGPMCA,BDGSRN
 D KILL^AUPNPAT,KVA^VADPT
 Q
 ;
EXPND ; -- expand code
 NEW X,Y,Z,BDGN
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGPI",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGPI",$J,"IDX",Y,0))
 .. Q:^TMP("BDGPI",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGPI",$J,"IDX",Y,Z)
 ;
 I '$G(BDGN) Q                           ;no selection
 I BDGN=1 D ^BDGPI1 S VALMBCK="R" Q      ;demographics
 ;
 I (BDGN'=1),(BDGN'=5),$D(^XUSEC("DGZNOCLN",DUZ)) D  Q
 . D MSG^BDGF("Sorry, you do not have access to clinical data.",1,0)
 . D PAUSE^BDGF S VALMBCK="R"
 ;
 I BDGN=2 D ASK^BDGEPI S VALMBCK="R" Q         ;last admission details
 ;
 ;IHS/ITSC/LJF 5/13/2005 PATCH 1003 added DFN to parameter list; BDGPI3 assumes it is set
 ;I BDGN=3 D EN^BDGPI3($G(BDGSRN),$G(BDGDSN)) S VALMBCK="R" Q   ;day surg
 I BDGN=3 D EN^BDGPI3($G(BDGSRN),$G(BDGDSN),$G(DFN)) S VALMBCK="R" Q   ;day surg
 ;end of PATCH 1003 changes
 ;
 I BDGN=4 K BDGSVE D PATSET^BDGSVE S VALMBCK="R" Q    ;sched visits
 I BDGN=5 D  S VALMBCK="R" Q                          ;future appts
 . S BSDBD=DT,BSDED=$$FMADD^XLFDT(DT,365)             ;date range
 . S BSDDFN=DFN D EN^BSDDPA S DFN=BSDDFN K BSDDFN
 I BDGN=6 D PATSET^BDGICF2 S VALMBCK="R"              ;incomplete chart
 Q
 ;
SECTION1 ; -- set up demographic data for display
 NEW LINE,BDGR
 D SET("("_BDGS_") Demographics -",.VALMCNT,BDGS,BDGI)
 ;
 ; sensitive patient warning first
 K BDGR D SENS^DGSEC4(.BDGR,DFN,DUZ) I BDGR(1)>0 D
 . D SET($$SP(15)_$G(IORVON)_"*** WARNING!!!  RESTRICTED PATIENT RECORD ***"_$G(IORVOFF),.VALMCNT,BDGS,BDGI)
 ;
 I $$OPTOUT^BDGF1(DFN) D
 . D SET($$SP(10)_$G(IORVON)_"DO NOT DISCLOSE INFORMATION ABOUT PATIENT"_$G(IORVOFF),.VALMCNT,BDGS,BDGI)
 ;
 ; name, cwad display, chart # and date of birth
 S LINE=$$GET1^DIQ(2,DFN,.01)_" "_$TR($$CWAD^BDGF2(DFN)," ","")
 S LINE=$$PAD(LINE,32)_"HRCN: "_$$HRCN^BDGF2(DFN,DUZ(2))
 S LINE=$$PAD(LINE,54)_"DOB: "_$$GET1^DIQ(2,DFN,.03)
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 ; street address, home phone and primary care provider
 S LINE=$$PAD($$GET1^DIQ(2,DFN,.111),31)
 S LINE=LINE_"PHONE: "_$$GET1^DIQ(2,DFN,.131)
 S LINE=$$PAD(LINE,54)_"SEX: "_$$GET1^DIQ(2,DFN,.02)
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 ; city, state, eligibility, primary care provider
 S LINE=$$GET1^DIQ(2,DFN,.114)_", "_$$STATE(DFN)_" "_$$GET1^DIQ(2,DFN,.116)
 S LINE=$$PAD(LINE,32)_"ELIG: "_$E($$GET1^DIQ(9000001,DFN,1112),1,15)
 S X=$$GET1^DIQ(2,DFN,.09),X=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9)
 S LINE=$$PAD(LINE,54)_"SSN: "_X
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 ; service unit based on community of residence
 S LINE=$$GET1^DIQ(9999999.05,+$$GET1^DIQ(9000001,DFN,1117,"I"),.05)
 I LINE]"" D SET("("_LINE_" Service Unit)",.VALMCNT,BDGS,BDGI)
 ;
 ; primary care provider and team
 K BDGR S BDGR="BDGR" D PCP^BSDU1(DFN,.BDGR)
 S LINE="PCP/TEAM: "_$P($G(BDGR(1)),"/")_" / "_$P($G(BDGR(1)),"/",2)
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 Q
 ;
SECTION2 ; -- set up last admission for display
 ; skip if not inpt facility
 I $$OUTPT^BDGPAR(DUZ(2)) S BDGS=BDGS-1 Q
 ;
 ; current patient status
 NEW LINE,VAIP
 S LINE="("_BDGS_") Current Inpatient Status - "_$$STATUS^BDGF2(DFN)
 D SET("",.VALMCNT,BDGS,BDGI),SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 ; last admission display
 S VAIP("D")="L" D INP^DGPMV10
 S DGPMCA=$G(DGPMVI(13))  ;needed by expand entry-killed in EXIT
 ;
 I '$D(^DGPM("C",DFN)) D  Q
 . S LINE="PATIENT HAS NO INPATIENT OR LODGER ACTIVITY IN THE COMPUTER"
 . D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 S LINE=$S("^4^5^"'[(U_+DGPMVI(2)_U):"Admitted",1:"Checked-in")
 S LINE=$$PAD(LINE,12)_": "_$P(DGPMVI(13,1),U,2)
 S LINE=$$PAD(LINE,39)_$S("^4^5^"[(U_+DGPMVI(2)_U):"Checked-out",+DGPMVI(2)=3:"Discharged ",1:"Transferred")
 S LINE=$$PAD(LINE,54)_": "_$S("^1^4^"'[(U_+DGPMVI(2)_U):$P(DGPMVI(3),U,2),$P(DGPMVI(3),U,2)'=$P(DGPMVI(13,1),U,2):$P(DGPMVI(3),U,2),1:"")
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 S LINE=$$PAD("Ward",12)_": "_$E($P(DGPMVI(5),U,2),1,24)
 S LINE=$$PAD(LINE,39)_"Room-Bed/Ext   : "_$E($P(DGPMVI(6),U,2),1,21)
 S LINE=LINE_" / "_$$GET1^DIQ(405.4,+DGPMVI(6),9999999.01)
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 I "^4^5^"'[(U_+DGPMVI(2)_U) D
 . S LINE=$$PAD("Admitted by",12)_": "_$E(DGPMVI(9999999.02),1,21)
 . S LINE=$$PAD(LINE,39)_"Specialty      : "_$E($P(DGPMVI(8),U,2),1,21)
 . D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 S LINE=$$PAD("Attending",12)_": "_$E($P(DGPMVI(18),U,2),1,26)
 NEW DGPMIFN S DGPMIFN=DGPMCA D ^DGPMLOS S LINE=$$PAD(LINE,39)_"Admission LOS  : "_$P(X,U,5)   ;IHS/ITSC/LJF 5/27/2004; PATCH #1001
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 K DGPMT,DGPMIFN,DGPMVI,DGPMDCD
 Q
 ;
SECTION3 ; -- set up last day surgery for display
 ; skip if not running day surgery program
 I ('$O(^SRF(0))),('$O(^ADGDS(0))) S BDGS=BDGS-1 Q
 ;
 K BDGSRN,BDGDSN   ;ien in surgery files-saved for expand entry action
 ;
 ; if VA Surgery is running at site, find last day surgery on file
 NEW X,BDGX,BDGLDS,I
 S X="BSRPEP" X ^%ZOSF("TEST")
 I $T S BDGX="BDGX",BDGLDS=$$LASTDS^BSRPEP(DFN,.BDGX)
 I $G(BDGLDS) D  Q
 . D SET("",.VALMCNT,BDGS,BDGI)
 . D SET("("_BDGS_") "_"Last Day Surgery -",.VALMCNT,BDGS,BDGI)
 . F I=1:1 Q:'$D(BDGX(I))  D SET(BDGX(I),.VALMCNT,BDGS,BDGI)
 . S BDGSRN=BDGX(0)     ;ien in surgery file-used by expand entry
 ;
 ; else find last day surgery in ADT file
 I '$D(^ADGDS(DFN)) D  Q
 . D SET("",.VALMCNT,BDGS,BDGI)
 . D SET("("_BDGS_")  No Day Surgeries on file",.VALMCNT,BDGS,BDGI)
 ;
 NEW X,IEN,IENS,LINE
 S X=$O(^ADGDS("APID",DFN,0)) Q:'X             ;inverse surgery date
 S IEN=$O(^ADGDS("APID",DFN,X,0)) Q:'IEN       ;subfile ien
 Q:'$D(^ADGDS(DFN,"DS",IEN,0))                 ;quit if bad xref
 S BDGDSN=IEN    ;ien in day surgery file-used in expand entry
 D SET("",.VALMCNT,BDGS,BDGI)
 D SET("("_BDGS_") "_"Last Day Surgery -",.VALMCNT,BDGS,BDGI)
 ;
 ; surgery date, time released, length of stay
 S IENS=IEN_","_DFN
 S LINE="Surgery Date/Time: "_$$GET1^DIQ(9009012.01,IENS,.01)
 S X=$$GET1^DIQ(9009012.01,IENS,7)             ;release date/time
 I X]"" D
 . S LINE=$$PAD(LINE,38)_"Released: "_X
 . S LINE=LINE_"  LOS: "_$$GET1^DIQ(9009012.01,IENS,8)_" hrs"
 . D SET(LINE,.VALMCNT,BDGS,BDGI)
 E  D
 . I $$GET1^DIQ(9009012.01,IENS,12)="YES" D  Q
 .. S LINE=$$PAD(LINE,38)_"**CANCELLED**" D SET(LINE,.VALMCNT,BDGS,BDGI)
 . I $$GET1^DIQ(9009012.01,IENS,13)="YES" D  Q
 .. S LINE=$$PAD(LINE,38)_"**NO-SHOW**" D SET(LINE,.VALMCNT,BDGS,BDGI)
 .I $L(LINE)'>38 D
 ..S LINE=$$PAD(LINE,38)_"Released: Not entered yet   LOS: n/a"
 ..D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 S LINE=$$SP(9)_"Service: "_$$GET1^DIQ(9009012.01,IENS,4)
 S LINE=$$PAD(LINE,38)_"Surgeon: "_$$GET1^DIQ(9009012.01,IENS,5)
 D SET(LINE,.VALMCNT,BDGS,BDGI)
 ;
 Q
 ;
SECTION4 ; -- set up scheduled visits for display
 D SECTION4^BDGPI0
 Q
 ;
SECTION5 ; -- set up list of future appts for display
 NEW LINE,X
 K ^TMP("BDGPI1",$J)
 D GUIR^XBLM("FA^DGRPD","^TMP(""BDGPI1"",$J,")
 NEW X S X=0 F  S X=$O(^TMP("BDGPI1",$J,X)) Q:'X  D
 . S LINE=$S(X=3:"("_BDGS_") ",1:$$SP(4))_$G(^TMP("BDGPI1",$J,X))
 . D SET(LINE,.VALMCNT,BDGS,BDGI)
 K ^TMP("BDGPI1",$J)
 Q
 ;
SECTION6 ; -- set up chart's status for display
 D SECTION6^BDGPI0
 Q
 ;
SET(LINE,LNUM,SNUM,SECTION) ; -- set display line into array
 ; LINE= display line
 ; LNUM=line number (VALMCNT)
 ; SNUM=section # (BDGS)
 ; SECTION=actual section (from INIT for loop - BDGI)
 S LNUM=LNUM+1
 S ^TMP("BDGPI",$J,LNUM,0)=LINE
 S ^TMP("BDGPI",$J,"IDX",LNUM,SNUM)=SECTION
 Q
 ;
STATE(P) ; -- returns 2 letter state abbreviation for patient's address
 NEW X
 S X=$$GET1^DIQ(2,P,.115,"I") I 'X Q ""
 Q $$GET1^DIQ(5,X,1)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
