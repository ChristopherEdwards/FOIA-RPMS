BDGICS4 ; IHS/ANMC/LJF - WORKLOAD-COMPLETION TIMES ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added observations to display
 ;
 NEW BDGTYP,BDGBD,BDGED,TYPE,BDGSRT
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added observations
 ;S BDGTYP=$$READ^BDGF("SO^1:Inpatients;2:Day Surgeries","Select Visit Type to Include") Q:BDGTYP<1
 S BDGTYP=$$READ^BDGF("SO^1:Inpatients Only;2:Day Surgeries & Observations","Select Visit Type to Include") Q:BDGTYP<1
 ;
 S TYPE=$S(BDGTYP=1:"Discharge",1:"Surgery")
 S BDGBD=$$READ^BDGF("DO^::EP","Select Beginning "_TYPE_" Date")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EP","Select Ending "_TYPE_" Date") Q:BDGED<1
 ;
 S BDGSRT=$$READ^BDGF("SO^1:Sort Alphabetically by Name;2:Sort by Terminal Digit","Select Patient Sort") Q:BDGSRT<1
 ;
 W !!,"If printing to paper, please use wide paper or condensed print"
 D ZIS^BDGF("PQ","EN^BDGICS4","IC WORKLOAD STATS","BDGTYP;BDGBD;BDGED;BDGSRT")
 Q
 ;
EN ; -- main entry point for BDG IC WORKLOAD STATS
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC WORKLOAD STATS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added observations
 ;S X=$S(BDGTYP=1:"Inpatients",1:"Day Surgeries")
 S X=$S(BDGTYP=1:"Inpatients Only",1:"Day Surgeries & Observations")
 ;
 S VALMHDR(1)=$$SP(79-$L(X)\2)_X
 S X=$$RANGE^BDGF(BDGBD,BDGED)
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S VALMHDR(3)=$$SP(50)_$G(IOUON)_"# of Days until ..."_$G(IOUOFF)
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 K ^TMP("BDGICS4",$J),^TMP("BDGICS4A",$J)
 S VALMCNT=0
 NEW BDGCNT,BDGTOT,BDGNUM           ;totals
 ;
 ; first find all by date range & sort by patient
 NEW DATE,END,BDGCNT,BDGTBP
 S BDGTBP=$$GET1^DIQ(9009020.1,+$$DIV^BSDU,.13,"I")  ;track bill prep?
 S DATE=BDGBD-.0001,END=BDGED+.24
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 group observations with day surgeries
 ;I BDGTYP=1 D FIND("AD")    ;gather inpatients & observation
 ;I BDGTYP=2 D FIND("AS")    ;gather day surgeries
 I BDGTYP=1 D FIND("AD",0)               ;gather inpatients
 I BDGTYP=2 D FIND("AS"),FIND("AD",1)    ;gather day surgeries & observations
 ;
 ; now take sorted list and put into display array
 NEW SORT,IEN,LINE,PRV,NAME,STATUS,BDGI
 S SORT=0
 F   S SORT=$O(^TMP("BDGICS4A",$J,SORT)) Q:SORT=""  D
 . S IEN=0 F  S IEN=$O(^TMP("BDGICS4A",$J,SORT,IEN)) Q:'IEN  D
 .. ;
 .. S STATUS=^TMP("BDGICS4A",$J,SORT,IEN)
 .. ;
 .. ; build display line
 .. S LINE=$$PAD($$GET1^DIQ(9009016.1,IEN,.01),20)    ;patient
 .. S LINE=LINE_$J($$GET1^DIQ(9009016.1,IEN,.011),8)  ;chart #
 .. S LINE=$$PAD(LINE,30)_$$DATES(IEN)                ;admit/surg date
 .. S LINE=$$PAD(LINE,45)
 .. ;
 .. ; find # of days until each stage was completed
 .. ;   and increment counts for reporting averages
 .. S BDG1=$$IDATES(IEN,2)    ;internal format for begin date
 .. F BDGI=2:1:8 D
 ... S X=$$DAYS(BDGI,IEN,BDG1)    ;# of days
 ... S LINE=LINE_$J(X,3)_$$SP(5)
 ... I X S BDGTOT(BDGI)=$G(BDGTOT(BDGI))+X,BDGNUM(BDGI)=$G(BDGNUM(BDGI))+1
 .. ;
 .. D SET(LINE,.VALMCNT)
 ;
 D TOTALS
 ;
 I '$D(^TMP("BDGICS4",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICS4A",$J)
 Q
 ;
FIND(SUB,OBS) ; find all entries for date range;IHS/OIT/LJF 04/14/2006 PATCH 1005 added OBS
 ; SUB=subscript depending on visit type
 ; OBS=1 if SUB ="AD" but only observations are needed;IHS/OIT/LJF 04/14/2006 PATCH 1005
 NEW DATE,END,IEN,STATUS
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^BDGIC(SUB,DATE)) Q:'DATE  Q:(DATE>END)  D
 . S IEN=0 F  S IEN=$O(^BDGIC(SUB,DATE,IEN)) Q:'IEN  D
 .. Q:$$GET1^DIQ(9009016.1,IEN,.17)]""   ;deleted entry
 .. ;
 .. ;IHS/OIT/LJF 04/14/2006 PATCH 1005 separate H and O visits
 .. I SUB="AD",OBS=0 Q:$$GET1^DIQ(9009016.1,IEN,.0392)'="HOSPITALIZATION"
 .. I SUB="AD",OBS=1 Q:$$GET1^DIQ(9009016.1,IEN,.0392)'="OBSERVATION"
 .. ;
 .. ; calculate entry's status (one of 8 categories)
 .. D STATUS(IEN)     ;sets STATUS variable
 .. ;
 .. ; set sort value to patient name or chart #
 .. S SORT=$$GET1^DIQ(9009016.1,IEN,$S(BDGSRT=1:.01,1:.011))
 .. I BDGSRT=2 S SORT=$$HRCNT^BDGF2(SORT)   ;convert to terminal digit
 .. ;
 .. S ^TMP("BDGICS4A",$J,SORT,IEN)=STATUS
 .. S BDGCNT=$G(BDGCNT)+1,BDGCNT(STATUS)=$G(BDGCNT(STATUS))+1
 Q
 ;
STATUS(IEN) ; calculate entry's completion status
 ; Status: 1=newly incomplete, 2=chart recvd, 3=chart tagged
 ; 4=insurance identified, 5=ready to code, 6=coded, 7=completed
 ; 8=bill prepped (only used if track bill prep turned on
 ;
 NEW DATA
 D ENP^XBDIQ1(9009016.1,IEN,".11:.21","DATA(")
 S STATUS=1                         ;initialize as newly incomplete
 I DATA(.14)]"" D  Q                ;if completed
 . S STATUS=$S(BDGTBP'=1:7,DATA(.15)]"":8,1:7) Q
 ;
 I DATA(.13)]"" S STATUS=6 Q        ;coded
 I DATA(.12)]"" S STATUS=5 Q        ;ready to code
 I DATA(.21)]"" S STATUS=4 Q        ;insurance identified
 I DATA(.19)]"" S STATUS=3 Q        ;tagged
 I DATA(.11)]"" S STATUS=2 Q        ;chart received
 Q
 ;
DATES(IEN) ; return dates for entry
 Q $P($$GET1^DIQ(9009016.1,IEN,.0211),"@")
 ;
IDATES(IEN,NUM) ; return dates for entry in internal format
 ; NUM=1 for visit date, =2 for discharge date
 NEW X
 I NUM=2 S X=$$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.02,"I")\1,1)
 I $G(X) Q X
 S X=$$GET1^DIQ(9009016.1,IEN,.03,"I") I 'X Q "??"          ;visit ien
 Q $$NUMDATE^BDGF($$GET1^DIQ(9000010,X,.01,"I")\1,1)      ;visit date
 ;
DAYS(NUM,IEN,BEGIN) ; return # days for this stage of completion
 NEW DAYS,X,FIELD
 S FIELD=$P($T(FIELDS+NUM),";;",2)    ;time field
 S X=$$GET1^DIQ(9009016.1,IEN,FIELD)
 Q $S(X="":"---",1:X)     ;leave dashes if date not entered
 ;
TOTALS ; display totals and averages
 NEW LINE,I,J,X
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT)
 ;
 ; display time averages
 S LINE=$$PAD($$SP(22)_"Averages:",40)
 F I=2:1:8 D
 . I '$G(BDGTOT(I)) S LINE=LINE_$$SP(8) Q
 . S X=BDGTOT(I)\BDGNUM(I),LINE=$$PAD(LINE,$L(LINE)+5)_$J(X,3)
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 ;
 ; display total incomplete and completed charts
 F I=1:1:8 D
 . I I=7 D    ;total incomplete charts
 .. S X=0 F J=1:1:6 S X=X+$G(BDGCNT(J))
 .. S LINE=$$PAD($$SP(10)_"TOTAL INCOMPLETE CHARTS:",40)_$J(X,6)
 .. D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 . ;
 . Q:'$G(BDGCNT(I))
 . S LINE=$$PAD($$SP(10)_$P($T(STATNM+I),";;",2),40)_$J(BDGCNT(I),6)
 . D SET(LINE,.VALMCNT)
 ;
 S X=$G(BDGCNT(7))+$G(BDGCNT(8))
 S LINE=$$PAD($$SP(10)_"TOTAL COMPLETED CHARTS:",40)_$J(X,6)
 D SET(LINE,.VALMCNT)
 ;
 Q
 ;
SET(DATA,NUM) ; puts display line into list template array
 S NUM=NUM+1
 S ^TMP("BDGICS4",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICS4",$J) K BDGPRT
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
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICS4",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGICS4",$J,BDGX,0)
 . W !,BDGLN
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?11,"*****",$$CONF^BDGF,"*****"
 W !,BDGDATE,?25,"Incomplete Charts Workload Report",?70,"Page: ",BDGPG
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005
 ;NEW X S X=$S(BDGTYP=1:"Inpatient Charts",1:"Day Surgery Charts")
 NEW X S X=$S(BDGTYP=1:"Inpatient Charts Only",1:"Day Surgery & Observation Charts")
 ;
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,?50,"# of Days Until ..."
 W !?2,"Patient",?23,"HRCN",?30,"Dsch/Surg",?44,"Rcvd",?51,"Taggd"
 W ?59,"Insur",?67,"Ready",?75,"Coded",?82,"Complt",?90,"Bill Prep"
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
FIELDS ;;
 ;;
 ;;.1191;;chart pickup time;;
 ;;.1991;;time to tag;;
 ;;.2191;;time to identify insurance;;
 ;;.1291;;prepare to code time;;
 ;;.1391;;coding time;;
 ;;.1491;;chart procesing time;;
 ;;.1591;;time in bill prep;;
 ;
STATNM ;;
 ;;New Incomplete Charts;;
 ;;Incomplete-Received;;
 ;;Incomplete-Tagged;;
 ;;Incomplete-Insurance Identified;;
 ;;Incomplete-Ready to Code;;
 ;;Incomplete-In Code;;
 ;;Completed-In Bill Prep;;
 ;;Completed-Bill Prep Done;;
