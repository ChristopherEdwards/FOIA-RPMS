BDGICR1 ; IHS/ANMC/LJF - INCOMPLETE CHART BY PATIENT ;  [ 08/20/2004  11:45 AM ]
 ;;5.3;PIMS;**1001,1005**;MAY 28, 2004
 ;IHS/ITSC/WAR 07/23/2004 PATCH 1001 added printable date range
 ;IHS/ITSC/LJF 08/09/2004 PATCH 1001 combined boservations with day surgery listing
 ;IHS/OIT/LJF  02/16/2006 PATCH 1005 added discharge or visit date sort
 ;             04/05/2006 PATCH 1005 added new subtotals (by deficiency & coded vs. ready to code)
 ;
 NEW BDGTYP,DEFAULT,BDGBD,BDGED,BDGSEL,BDGSRT
 ;
 ;S BDGTYP=$$READ^BDGF("SO^1:Inpatients Only;2:Day Surgeries Only;3:Both","Select Visit Types to Include") Q:BDGTYP<1
 S BDGTYP=$$READ^BDGF("SO^1:Inpatients;2:Observations & Day Surgeries;3:All","Select Visit Types to Include") Q:BDGTYP<1  ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 ;
 ;S DEFAULT=$S(BDGTYP=1:"Discharge",BDGTYP=2:"Surgery",1:"Discharge/Surgery")
 S DEFAULT=$S(BDGTYP=1:"Discharge",1:"Discharge/Surgery")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning "_DEFAULT_" Date")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending "_DEFAULT_" Date")
 Q:BDGED<1
 ;IHS/ITSC/WAR 7/23/04 PATCH #1001 printable date range
 S BDGDTS="from "_$E(BDGBD,4,5)_"/"_$E(BDGBD,6,7)_"/"_($E(BDGBD,1,3)+1700)
 S BDGDTS=BDGDTS_" to "_$E(BDGED,4,5)_"/"_$E(BDGED,6,7)_"/"_($E(BDGED,1,3)+1700)
 ;End of 7/23/04 PATCH #1001
 ;
 S BDGSEL=$$SELECT Q:BDGSEL=U
 ;
 ;IHS/OIT/LJF 02/16/2006 PATCH 1005
 ;S BDGSRT=$$READ^BDGF("SO^1:Sort Alphabetically by Name;2:Sort by Terminal Digit","Select Patient Sort") Q:BDGSRT<1
 S X=$S(BDGTYP=1:"Discharge",1:"Discharge/Surgery")
 S BDGSRT=$$READ^BDGF("SO^1:Sort Alphabetically by Name;2:Sort by Terminal Digit;3:Sort by "_X_" Date","Select Patient Sort") Q:BDGSRT<1
 ;
 ;IHS/OIT/LJF 04/05/2006 PATCH 1005 add 2 more questions
 NEW BDGDEF,BDGRTC
 S BDGDEF=$$READ^BDGF("Y","Include COUNTS by CHART DEFICIENCY","NO") Q:BDGDEF=U
 S BDGRTC=$$READ^BDGF("Y","Subtotal CODED vs. READY TO CODE","NO") Q:BDGRTC=U
 ;
 I $$BROWSE^BDGF="B" D EN Q
 ;IHS/ITSC/WAR 7/23/04 PATCH #1001 printable date range
 ;IHS/OIT/LJF 04/05/2006 PATCH 1005 added BDGDEF & BDGRTC to variable list
 ;D ZIS^BDGF("PQM","EN^BDGICR1","IC LIST BY PATIENT","BDGTYP;BDGBD;BDGED;BDGSEL;BDGSRT")
 ;D ZIS^BDGF("PQM","EN^BDGICR1","IC LIST BY PATIENT","BDGTYP;BDGBD;BDGED;BDGSEL;BDGSRT;BDGDTS")
 D ZIS^BDGF("PQM","EN^BDGICR1","IC LIST BY PATIENT","BDGTYP;BDGBD;BDGED;BDGSEL;BDGSRT;BDGDTS;BDGDEF;BDGRTC")
 Q
 ;
 ;
EN ; -- main entry point for BDG IC CHARTS BY PATIENT
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC CHARTS BY PATIENT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 ;
 ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 ;S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Day Surgeries Only",1:"Inpatients & Day Surgeries")
 S X=$S(BDGTYP=1:"Inpatients",BDGTYP=2:"Observations & Day Surgeries",1:"Inpatients, Observations & Day Surgeries")
 ;
 S X=X_" ("_$P($T(CHOICE+BDGSEL),";;",2)_")"      ;chart selection
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 ;IHS/ITSC/WAR 7/23/04 PATCH #1001 NextLine Center printable date range
 S VALMHDR(3)=$$SP(75-$L(BDGDTS)\2)_BDGDTS
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 K ^TMP("BDGICR1",$J),^TMP("BDGICR1A",$J)
 S VALMCNT=0
 ;
 ; first find incomplete entries by date range & sort by patient
 NEW DATE,END,BDGCNT
 S DATE=BDGBD-.0001,END=BDGED+.24
 ;I BDGTYP'=1 D FIND("AS"  ;gather day surgeries
 I BDGTYP'=1 D FIND("AS"),FIND("AD",1)    ;gather day surgeries & observations;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 I BDGTYP'=2 D FIND("AD")                 ;gather inpatients
 ;
 ; now take sorted list and put into display array
 ;NEW SORT,IEN,LINE,PRV,NAME
 NEW SORT,IEN,LINE,PRV,NAME,IEN2   ;IHS/ITSC/LJF 5/29/2004; PATCH #1001
 S SORT=0
 F   S SORT=$O(^TMP("BDGICR1A",$J,SORT)) Q:SORT=""  D
 . S IEN=0 F  S IEN=$O(^TMP("BDGICR1A",$J,SORT,IEN)) Q:'IEN  D
 .. ;
 .. ; build display line
 .. S LINE=$$PAD($$GET1^DIQ(9009016.1,IEN,.01),20)    ;patient
 .. S LINE=LINE_$J($$GET1^DIQ(9009016.1,IEN,.011),8)  ;chart #
 .. S LINE=$$PAD(LINE,30)_$$DATES(IEN,1)              ;admit/surg date
 .. S LINE=$$PAD(LINE,48)_$$WRD(IEN)                  ;type or ward
 .. S LINE=$$PAD(LINE,61)_$$CODE(IEN,1)               ;ready to code
 .. S LINE=$$PAD(LINE,81)_$$GET1^DIQ(9009016.1,IEN,.0391)   ;insurance
 .. D SET(LINE,.VALMCNT)
 .. ;
 .. ; build 2nd line
 .. S LINE=$$SP(30)_$$DATES(IEN,2)              ;discharge date
 .. S LINE=$$PAD(LINE,48)_$$SRV(IEN)            ;srv
 .. S LINE=$$PAD(LINE,61)_$$CODE(IEN,2)         ;date coded
 .. S LINE=$$PAD(LINE,81)_$$GET1^DIQ(9009016.1,IEN,.18)     ;comments
 .. D SET(LINE,.VALMCNT)
 .. ;
 .. ; now list unresolved deficiencies
 .. S PRV=0 F  S PRV=$O(^BDGIC(IEN,1,"B",PRV)) Q:'PRV  D
 ... S IEN2=0 F  S IEN2=$O(^BDGIC(IEN,1,"B",PRV,IEN2)) Q:'IEN2  D
 .... Q:$$GET1^DIQ(9009016.11,IEN2_","_IEN,.03)]""   ;resolved
 .... Q:$$GET1^DIQ(9009016.11,IEN2_","_IEN,.04)]""   ;deleted
 .... S LINE=$$SP(81)_$E($$GET1^DIQ(200,PRV,.01),1,18)
 .... S LINE=$$PAD(LINE,101)_$$GET1^DIQ(9009016.11,IEN2_","_IEN,.02)
 .... D SET($$PAD(LINE,132),.VALMCNT)
 .... ;
 .... ;IHS/OIT/LJF 04/05/2006 PATCH 1005 count by deficiency
 .... I BDGDEF S X=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.02) S BDGDEF(X)=$G(BDGDEF(X))+1
 .. ;
 .. ;IHS/OIT/LJF 04/05/2006 PATCH 1005 count by coding status
 .. I BDGRTC D
 ... I $$GET1^DIQ(9009016.1,IEN,.13)]"" S BDGRTC("CODED")=$G(BDGRTC("CODED"))+1
 ... E  I $$GET1^DIQ(9009016.1,IEN,.12)]"" S BDGRTC("READY TO CODE")=$G(BDGRTC("READY TO CODE"))+1
 ... E  S BDGRTC("NOT READY")=$G(BDGRTC("NOT READY"))+1
 .. ;
 .. ;
 .. D SET("",.VALMCNT)   ;blank line between patient entries
 ;
 ;IHS/OIT/LJF 04/05/2006 PATCH 1005 display subtotals
 ;I $G(BDGCNT)>0 D SET("TOTAL INCOMPLETE CHARTS: "_BDGCNT,.VALMCNT)
 I $G(BDGCNT)>0 D
 . D SET("TOTAL INCOMPLETE CHARTS: "_BDGCNT,.VALMCNT)
 . I BDGDEF D  D SET("",.VALMCNT)
 .. D SET("  SUBCOUNTS BY DEFICIENCY:",.VALMCNT)
 .. I $O(BDGDEF(0))="" D SET($$SP(5)_"NO DEFICIENCIES FOUND",.VALMCNT)
 .. S X=0 F  S X=$O(BDGDEF(X)) Q:X=""  D SET($$SP(5)_$$PAD(X,32)_BDGDEF(X),.VALMCNT)
 . I BDGRTC D
 .. D SET("  SUBCOUNTS BY CODING STATUS",.VALMCNT)
 .. F I="CODED","READY TO CODE","NOT READY" D SET($$SP(5)_$$PAD(I,20)_(+$G(BDGRTC(I))),.VALMCNT)
 ;IHS/OIT/LJF 04/05/2006 end of PATCH 1005 changes
 ;
 I '$D(^TMP("BDGICR1",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICR1A",$J)
 Q
 ;
FIND(SUB,OBS) ; find all inpatient entries for date range
 ; SUB=subscript depending on visit type
 ; OBS=1 if looking for observation patients; optional  ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 NEW DATE,END,IEN,SORT
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^BDGIC(SUB,DATE)) Q:'DATE  Q:(DATE>END)  D
 . S IEN=0 F  S IEN=$O(^BDGIC(SUB,DATE,IEN)) Q:'IEN  D
 .. ;
 .. I $G(OBS),$$GET1^DIQ(9009016.1,IEN,.0392)'="OBSERVATION" Q   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 .. ;
 .. ; check entry against user selection
 .. K DATA D ENP^XBDIQ1(9009016.1,IEN,".11:.21","DATA(")
 .. Q:DATA(.17)]""                                  ;quit if deleted
 .. I BDGSEL'=7 Q:DATA(.14)]""                      ;quit if completed
 .. I BDGSEL=2 Q:DATA(.11)]""                       ;quit if received
 .. I BDGSEL=3 Q:DATA(.19)]""                       ;quit if tagged
 .. I BDGSEL=4 Q:DATA(.21)]""                       ;quit if insur iden
 .. I BDGSEL=5 Q:DATA(.13)]""                       ;quit if coded
 .. I BDGSEL=6 Q:DATA(.13)=""                       ;quit if not coded
 .. I BDGSEL=7 Q:DATA(.14)=""  Q:DATA(.15)]""       ;quit not in bill p
 .. ;
 .. ;IHS/OIT/LJF 02/16/2006 PATCH 1005 add date as sort choice
 .. ; set sort value to patient name or chart #
 .. ;S SORT=$$GET1^DIQ(9009016.1,IEN,$S(BDGSRT=1:.01,1:.011))
 .. S SORT=$$GET1^DIQ(9009016.1,IEN,$S(BDGSRT=1:.01,BDGSRT=2:.011,BDGTYP=1:.02,1:.03),$S(BDGSRT=3:"I",1:""))
 .. I BDGSRT=3,BDGTYP=2 S SORT=$$GET1^DIQ(9000010,SORT,.01,"I")   ;convert visit pointer to date
 .. ;
 .. I BDGSRT=2 S SORT=$$HRCNT^BDGF2(SORT)                         ;convert to terminal digit
 .. ;
 .. S ^TMP("BDGICR1A",$J,SORT,IEN)=""
 .. S BDGCNT=$G(BDGCNT)+1
 Q
 ;
DATES(IEN,NUM) ; return dates for entry
 ; NUM=1 for visit date, =2 for discharge date
 NEW X
 I NUM=2 Q $$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.02,"I")\1,1)
 S X=$$GET1^DIQ(9009016.1,IEN,.03,"I") I 'X Q "??"          ;visit ien
 Q $$NUMDATE^BDGF($$GET1^DIQ(9000010,X,.01,"I")\1,1)      ;visit date
 ;
WRD(IEN) ; returns ds type or ward
 NEW TYPE,X,DATE,CA,PAT
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)            ;visit type
 ;I TYPE'["HOS" Q $S(TYPE["DAY":"DS",TYPE["OBS":"DSO",1:"??")
 I TYPE'["HOS" Q $S(TYPE["DAY":"DS",TYPE["OBS":"OBS",1:"??")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 ;
 ; for inpatients
 S V=$$GET1^DIQ(9009016.1,IEN,.03,"I")               ;visit
 S X=$O(^DGPM("AVISIT",V,0)) I 'X Q "??"             ;link to 405
 Q $$GET1^DIQ(405,+$$GET1^DIQ(405,X,.17,"I"),200)    ;ward at discharge
 ;
SRV(IEN) ; returns service
 Q $$GET1^DIQ(45.7,+$$GET1^DIQ(9009016.1,IEN,.04,"I"),99)
 ;
CODE(IEN,NUM) ; returns ready to code date and date coded
 ; NUM=1 for ready to code; =2 for date coded
 NEW X,Y
 I NUM=1 Q $$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.12,"I"),1)
 Q $$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.13,"I"),1)
 ;
SET(DATA,NUM) ; puts display line into list template array
 S NUM=NUM+1
 S ^TMP("BDGICR1",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICR1",$J) K BDGPRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D INIT^BDGF    ;initialize heading variables
 D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICR1",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGICR1",$J,BDGX,0)
 . W !,BDGLN
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?11,"*****",$$CONF^BDGF,"*****"
 W !,BDGDATE,?25,"Incomplete Charts by Patient",?70,"Page: ",BDGPG
 ;
 ;IHS/ITSC/LJF 8/9/2004 PATCH 1001
 ;NEW X S X=$S(BDGTYP=1:"Inpatient Charts Only",BDGTYP=2:"Day Surgery Charts Only",1:"Inpatient and Day Surgery Charts")
 NEW X S X=$S(BDGTYP=1:"Inpatients",BDGTYP=2:"Observations & Day Surgeries",1:"Inpatients, Observations & Day Surgeries")
 ;
 S X=X_"("_$P($T(CHOICE+BDGSEL),";;",2)_")"
 W !,BDGTIME,?(80-$L(X)\2),X
 ;IHS/ITSC/WAR 7/23/04 PATCH #1001 Next line center printable date range
 W !,?(80-$L(BDGDTS)\2),BDGDTS
 W !,$$REPEAT^XLFSTR("-",80)
 W !?2,"Patient",?23,"HRCN",?30,"Admt/Dsch",?45,"Ward/Srv",?60
 W "Ready/Coded",?81,"Insurance/Unresolved Deficiencies & Comments"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
SELECT() ; ask user to choose selected charts
 NEW Y,ARRAY,I
 W !!
 F I=1:1:7 S ARRAY(I)=" "_I_". "_$P($T(CHOICE+I),";;",2)
 S Y=$$READ^BDGF("NO^1:7","Select Charts to Print",1,"","",.ARRAY)
 Q Y
 ;
CHOICE ;;
 ;;All Incomplete Charts;;
 ;;Charts Not Yet Received;;
 ;;Charts Not Yet Tagged;;
 ;;Insurance Not Identified;;
 ;;Not Coded (Tagged or Not);;
 ;;Coded, Not Completed;;
 ;;Completed, In Bill Prep;;
